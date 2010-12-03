Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab0LCLmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 06:42:50 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:59754 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932404Ab0LCLmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 06:42:43 -0500
From: manjunatha_halli@ti.com
To: mchehab@infradead.org, hverkuil@xs4all.nl
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Manjunatha Halli <manjunatha_halli@ti.com>
Subject: [RFC v6 2/9] Documentation:DocBook:v4l: Update the controls.xml for TI FM driver
Date: Fri,  3 Dec 2010 07:50:24 -0500
Message-Id: <1291380631-25993-3-git-send-email-manjunatha_halli@ti.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1291380631-25993-2-git-send-email-manjunatha_halli@ti.com>
References: <1291380631-25993-1-git-send-email-manjunatha_halli@ti.com>
 <1291380631-25993-2-git-send-email-manjunatha_halli@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunatha Halli <manjunatha_halli@ti.com>

Added entries for following 2 new CID's which are added for TI FM
driver:
- V4L2_CID_RSSI_THRESHOLD
- V4L2_CID_TUNE_AF

Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
---
 Documentation/DocBook/v4l/controls.xml |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/v4l/controls.xml b/Documentation/DocBook/v4l/controls.xml
index 2fae3e8..b560953 100644
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

