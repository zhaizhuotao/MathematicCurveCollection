using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class lemniscateEffect : MonoBehaviour {
    [SerializeField]
    private Material _mat;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source,destination,_mat);
    }
}
