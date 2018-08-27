Shader "ZhaiZhuoTao/Mathematic/Curve/lemniscateShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
        _CircleMotionRadius("CircleMotionRadius",float) = 0.5
        _LemR("LemR",float) = 0.3
        _LemWidth("LemWidth",float) = 0.008
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#define PI 3.1415926
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;

            float sin01(in float x)
            {
                return (sin(x) + 1.0) / 2.0;
            }

            float smoothStep2(in float edge, in float x)
            {
                const float fadeWidth = 0.4;
                return smoothstep(edge - fadeWidth, edge + fadeWidth, x);
            }

            float2 complexProd(in float2 v1, in float2 v2)
            {
                return float2(v1.x * v2.x - v1.y * v2.y, v1.x * v2.y + v2.x * v1.y);
            }

            float lem(in float2 uv, in float2 f1, in float2 f2, in float r, in float width)
            {
                float2 cp12 = complexProd(uv - f1, uv - f2);
                return smoothStep2(abs(length(cp12) - (r * r)), width);
            }

            float lem(in float2 uv, in float2 f1, in float2 f2, in float2 f3, in float r, in float width)
            {
                float2 cp12 = complexProd(uv - f1, uv - f2);
                float2 cp123 = complexProd(uv - f3, cp12);
                return smoothStep2(abs(length(cp123) - (r * r * r)), width);
            }

            float lem(in float2 uv, in float2 f1, in float2 f2, in float2 f3, in float2 f4, in float r, in float width)
            {
                float2 cp12 = complexProd(uv - f1, uv - f2);
                float2 cp123 = complexProd(uv - f3, cp12);
                float2 cp1234 = complexProd(uv - f4, cp123);
                return smoothStep2(abs(length(cp1234) - pow(r, 4.0)), width);
            }

            float lem(in float2 uv, in float2 f1, in float2 f2, in float2 f3, in float2 f4, in float2 f5, in float r, in float width)
            {
                float2 cp12 = complexProd(uv - f1, uv - f2);
                float2 cp123 = complexProd(uv - f3, cp12);
                float2 cp1234 = complexProd(uv - f4, cp123);
                float2 cp12345 = complexProd(uv - f5, cp1234);
                return smoothStep2(abs(length(cp12345) - pow(r, 5.0)), width);
            }

            float2 circMotion(in float2 center, in float r, in float freq, in float phase)
            {
                float s = sin(_Time.y * freq + phase);
                float c = cos(_Time.y * freq + phase);
                return center + r * float2(c, s);
            }

            float2 ellipseMotion(in float2 center, in float a, in float b, in float angle, in float freq, in float phase)
            {
                float s = b * sin(_Time.y * freq + phase);
                float c = a * cos(_Time.y * freq + phase);
                float rs = sin(angle);
                float rc = cos(angle);
                return center + mul(float2x2(rc, -rs, rs, rc) , float2(c, s));
            }
            float getCircleMotionRadiusPeriodically()
            {
                return (sin(_Time.y) + 1.0) * 0.5*0.5 + 0.4; 
            }
            float _CircleMotionRadius;
            float _LemR;
            float _F1M;
            float _F2M;
            float _LemWidth;
			float4 frag (v2f i) : SV_Target
			{
                float2 uv;
                uv.x = (i.uv.x) * 2.0 - 1.0;
                uv.y = (i.uv.y) * 2.0 - 1.0;

                float3 c1 = float3(1.0, 0.0, 0.0);
                float3 c2 = float3(0.0, 1.0, 0.0);
                float3 c3 = float3(0.0, 0.0, 1.0);
           
                float circleMotionRadius = getCircleMotionRadiusPeriodically();
                float2 f1m = circMotion(float2(0,0), circleMotionRadius, 1, 0);
                float2 f2m = circMotion(float2(0,0), circleMotionRadius, 1, 2);
                float2 f3m = circMotion(float2(0,0), circleMotionRadius, 1, 4);

                float d1 = distance(uv, f1m);
                float d2 = distance(uv, f2m);
                float d3 = distance(uv, f3m);
                
                float3 col = (d1 * c1 + d2 * c2 + d3 * c3) / 1.5;
                float c = lem(uv, f1m, f2m,f3m, _LemR, _LemWidth);

                // Output to screen
                return float4(col * c,1.0);
			}
			ENDCG
		}
	}
}
