Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab1IUVxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:53:21 -0400
Received: from jcz.nl ([213.196.18.5]:42545 "EHLO jcz.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012Ab1IUVxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:53:18 -0400
From: Jaap Crezee <jaap@jcz.nl>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        hjanssen@microsoft.com, haiyangz@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, Jaap Crezee <jaap@jcz.nl>
Subject: [PATCH 3/3] Staging: hv: hv_mouse: Fixed coding style issues
Date: Wed, 21 Sep 2011 23:53:23 +0200
Message-Id: <1316642003-9703-1-git-send-email-jaap@jcz.nl>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some coding style issues

Signed-off-by: Jaap Crezee <jaap@jcz.nl>
---
 drivers/staging/hv/hv_mouse.c |   38 +++++++++++++++++++-------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index d957fc2..e92d6c7 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -54,7 +54,7 @@ struct hv_input_dev_info {
 					 (SYNTHHID_INPUT_VERSION_MAJOR << 16))
 
 
-#pragma pack(push,1)
+#pragma pack(push, 1)
 /*
  * Message types in the synthetic input protocol
  */
@@ -120,8 +120,8 @@ struct synthhid_input_report {
 
 #pragma pack(pop)
 
-#define INPUTVSC_SEND_RING_BUFFER_SIZE		10*PAGE_SIZE
-#define INPUTVSC_RECV_RING_BUFFER_SIZE		10*PAGE_SIZE
+#define INPUTVSC_SEND_RING_BUFFER_SIZE		(10*PAGE_SIZE)
+#define INPUTVSC_RECV_RING_BUFFER_SIZE		(10*PAGE_SIZE)
 
 #define NBITS(x) (((x)/BITS_PER_LONG)+1)
 
@@ -509,22 +509,22 @@ static void mousevsc_on_channel_callback(void *context)
 				desc = (struct vmpacket_descriptor *)buffer;
 
 				switch (desc->type) {
-					case VM_PKT_COMP:
-						mousevsc_on_send_completion(
-							device, desc);
-						break;
-
-					case VM_PKT_DATA_INBAND:
-						mousevsc_on_receive(
-							device, desc);
-						break;
-
-					default:
-						pr_err("unhandled packet type %d, tid %llx len %d\n",
-							   desc->type,
-							   req_id,
-							   bytes_recvd);
-						break;
+				case VM_PKT_COMP:
+					mousevsc_on_send_completion(
+						device, desc);
+					break;
+
+				case VM_PKT_DATA_INBAND:
+					mousevsc_on_receive(
+						device, desc);
+					break;
+
+				default:
+					pr_err("unhandled packet type %d, tid %llx len %d\n",
+						   desc->type,
+						   req_id,
+						   bytes_recvd);
+					break;
 				}
 
 				/* reset */
-- 
1.7.6.3

