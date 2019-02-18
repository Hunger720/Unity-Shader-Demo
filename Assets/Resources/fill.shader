Shader "Custom/fill"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Fill ("Fill", Range(0, 1)) = 1
		_PointOffset ("Point Offset", Range(0, 0.5)) = 0
		_PointSize ("Point Size", Range(0, 0.1)) = 0
	}
	SubShader
	{
		Tags
		{ 
			"RenderType"="Opaque"
			"Queue" = "Transparent"
		}
		LOD 100

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float4 color: COLOR;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 color : COLOR;
				float2 uv : TEXCOORD0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Fill;
			float _PointOffset;
			float _PointSize;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float pi = 3.1415926 * 2;
				float2 center = float2(0.5, 0.5);
				
				float2 pt_beg = center - float2(_PointOffset * sin(_Fill * pi), _PointOffset * cos(_Fill * pi));
				float2 pt_end = center - float2(_PointOffset * sin(0), _PointOffset * cos(0));
				float dis_beg = length(i.uv - pt_beg);
				float dis_end = length(i.uv - pt_end);

				float2 end = float2(0.0, -1.0);
				float2 beg = i.uv - center;
				float val = dot(beg,end) / (length(beg)*length(end));
				float rad = acos(val);
				float s = step(i.uv.x, 0.5);
				rad *= (2 * s - 1);
				rad += (1 - s)*pi;
				float percent = rad / pi;

				clip(0.5 - step(_PointSize, dis_beg)*step(_PointSize, dis_end)*step(_Fill, percent));

				return tex2D(_MainTex, i.uv) * i.color;
				
			}
			ENDCG
		}
	}
}
