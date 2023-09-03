Shader "Blend/PSBlendMode"
{
    Properties
    {
        [IntRange]_ModeID ("ModeID", Range(0.0, 26.0)) = 0.0
        [Header(A is Dst Texture)]
        [Space(10)]
        _Color1 ("TextureColor_A", Color) = (1.0, 1.0, 1.0, 0.5)
        [Space(100)]
        [Header(B is Src Texture)]
        [Space(10)]
        _Color2 ("TextureColor_B", Color) = (1.0, 1.0, 1.0, 1.0)
        _MainTex2 ("Texture_B", 2D) = "white" { }
        [HideInInspector]_IDChoose ("", float) = 0.0
    }
    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent" "Queue" = "Transparent"
        }
        ZWrite On

        Blend One Zero //Normal      or blend off


        GrabPass
        {
            "_BackgroundTexture"
        }



        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "./Include/PhotoshopBlendMode.cginc"
            

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float2 bguv : TEXCOORD1;

            };

            uniform sampler2D  _MainTex2;
            uniform float4 _MainTex2_ST;
            uniform float4 _Color1, _Color2;
            uniform float _ModeID;

            sampler2D _BackgroundTexture;


            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex2);
                o.bguv = ComputeGrabScreenPos(o.vertex);
                return o;
            }


            float4 frag(v2f i) : SV_Target
            {
                float4 D = tex2D(_BackgroundTexture, i.bguv) * _Color1;
                float4 S = tex2D(_MainTex2, i.uv) * _Color2;
                return float4(OutPutMode(S, D, _ModeID), 1.0);
            }
            ENDCG
        }
    }
    CustomEditor "BlendModeGUI"
}