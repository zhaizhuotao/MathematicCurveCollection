﻿using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class LemniscateOfGerono : MonoBehaviour {

  public LineRenderer lineRenderer;
  public int lineVertexCount = 25;
  public float lineLength = 2f;
  public float lineScaleX = 2f;
  public float lineScaleY = 2f;
  public float lineScaleZ = 2f;
  public float frequency = 1f;

  void OnRenderObject()
  {
    lineRenderer.SetVertexCount(lineVertexCount);

    Vector3[] positions = new Vector3[lineVertexCount];

    float sineWave = Mathf.PI * lineLength;
    float angleOffset = sineWave / (lineVertexCount - 1);

    for (int i = lineVertexCount; i-- > 0;)
    {
      float angle = angleOffset * i;
      float x = Mathf.Cos(angle + Time.time * frequency) * lineScaleX;
      float y = (Mathf.Sin(2 * (angle + Time.time * frequency)) / 2) * lineScaleY;
      float z = Mathf.Cos(angle) * lineScaleZ;

      positions[i] = new Vector3(x, y, z);
    }

    lineRenderer.SetPositions(positions);
  }

}
