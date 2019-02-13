Shader "Custom/circle"{

	Properties{
		_Color   ("Main Color", Color) = (1, 0.5, 0.5, 1)
		_Texture ("Main Tex", 2D) = "white" {}
	}

	SubShader{
		Pass
		{
			AlphaTest Greater 0.95
			SetTexture[_Texture] {}
		}
	}
}