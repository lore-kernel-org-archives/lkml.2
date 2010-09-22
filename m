Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab0IVKiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 06:38:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42748 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521Ab0IVKhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 06:37:48 -0400
From: x0130808@ti.com
To: linux-kernel@vger.kernel.org
Cc: Raja Mani <raja_mani@ti.com>, Pramodh AG <pramodh_ag@ti.com>,
        Manjunatha Halli <x0130808@ti.com>
Subject: [RFC/PATCH 8/9] Documentation:DocBook:v4l: Update the controls.xml
Date: Wed, 22 Sep 2010 07:48:38 -0400
Message-Id: <1285156119-28531-9-git-send-email-x0130808@ti.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1285156119-28531-8-git-send-email-x0130808@ti.com>
References: <1285156119-28531-1-git-send-email-x0130808@ti.com>
 <1285156119-28531-2-git-send-email-x0130808@ti.com>
 <1285156119-28531-3-git-send-email-x0130808@ti.com>
 <1285156119-28531-4-git-send-email-x0130808@ti.com>
 <1285156119-28531-5-git-send-email-x0130808@ti.com>
 <1285156119-28531-6-git-send-email-x0130808@ti.com>
 <1285156119-28531-7-git-send-email-x0130808@ti.com>
 <1285156119-28531-8-git-send-email-x0130808@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raja Mani <raja_mani@ti.com>

Added entries for following 2 new CID's which are added for TI FM driver:
- V4L2_CID_RSSI_THRESHOLD
- V4L2_CID_TUNE_AF

Signed-off-by: Raja Mani <raja_mani@ti.com>
Signed-off-by: Pramodh AG <pramodh_ag@ti.com>
Signed-off-by: Manjunatha Halli <x0130808@ti.com>
---
 Documentation/DocBook/v4l/controls.xml |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/v4l/controls.xml b/Documentation/DocBook/v4l/controls.xml
index 8408caa..e074f73 100644
--- a/Documentation/DocBook/v4l/controls.xml
+++ b/Documentation/DocBook/v4l/controls.xml
@@ -132,6 +132,18 @@ consumption state.</entry>
 	    <entry>Loudness mode (bass boost).</entry>
 	  </row>
 	  <row>
+           <entry><constant>V4L2_CID_RSSI_THRESHOLD</constant></entry>
+           <entry>integer</entry>
+           <entry>Set RSSI threshold level. Change the default threshold
+level used to select valid frequencies during vidioc_s_hw_freq_seek.</entry>
+         </row>
+         <row>
+           <entry><constant>V4L2_CID_TUNE_AF</constant></entry>
+           <entry>integer</entry>
+           <entry>Set Alternative Frequency mode. Enable or disable
+alternative frequency mode.</entry>
+         </row>
+         <row>
 	    <entry><constant>V4L2_CID_BLACK_LEVEL</constant></entry>
 	    <entry>integer</entry>
 	    <entry>Another name for brightness (not a synonym of
-- 
1.5.6.3

