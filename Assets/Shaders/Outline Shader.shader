Shader "Unlit/Outline Shader"
{
    Properties
    {
        _InkColor("InkColo", Color) = (0, 0, 0, 0)
        _InkSize("InkSize", float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Cull Front

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal: NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            float4 _InkColor;
            float _InkSize;

            v2f vert (appdata v)
            {
                v2f o;

                // Translate the vertex on the normal vector by the distance specified with _OutlineThickness
                o.vertex = UnityObjectToClipPos(v.vertex + _InkSize * v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return _InkColor;
            }
            ENDCG
        }
    }
}
