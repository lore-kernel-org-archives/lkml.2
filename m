Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934245Ab1CZBuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:50:24 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:50519 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932402Ab1CZBuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:50:22 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19+ZvV763Z+lrM33dcac9YdFOYJsaAMevbfxbRcNT
	I0/hg1QuhA3G8N
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 23/27] staging/vt6655: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:49:58 +0100
Message-Id: <1301104202-16592-23-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some common spelling mistakes in
drivers/staging/vt6655.

WRONG -> RIGHT
enviroment	-> environment
reguest		-> request

Kernel Version: staging/staging-next 20110325 (4bbba111)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/vt6655/device_main.c |    2 +-
 drivers/staging/vt6655/tether.h      |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index efaf19b..ad39c87 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -137,7 +137,7 @@ DEVICE_PARAM(TxDescriptors1,"Number of transmit descriptors1");
 /* IP_byte_align[] is used for IP header unsigned long byte aligned
    0: indicate the IP header won't be unsigned long byte aligned.(Default) .
    1: indicate the IP header will be unsigned long byte aligned.
-      In some enviroment, the IP header should be unsigned long byte aligned,
+      In some environment, the IP header should be unsigned long byte aligned,
       or the packet will be droped when we receive it. (eg: IPVS)
 */
 DEVICE_PARAM(IP_byte_align,"Enable IP header dword aligned");
diff --git a/drivers/staging/vt6655/tether.h b/drivers/staging/vt6655/tether.h
index 787d885..3b4efb2 100644
--- a/drivers/staging/vt6655/tether.h
+++ b/drivers/staging/vt6655/tether.h
@@ -53,7 +53,7 @@
 #define TYPE_PKT_802_1x     0x888e
 #define TYPE_PKT_PreAuth    0x88C7
 
-#define TYPE_PKT_PING_M_REQ 0x8011      // master reguest
+#define TYPE_PKT_PING_M_REQ 0x8011      // master request
 #define TYPE_PKT_PING_S_GNT 0x8022      // slave grant
 #define TYPE_PKT_PING_M     0x8077      // pingpong master packet
 #define TYPE_PKT_PING_S     0x8088      // pingpong slave packet
@@ -106,7 +106,7 @@
 #define TYPE_PKT_802_1x     0x8e88
 #define TYPE_PKT_PreAuth    0xC788
 
-#define TYPE_PKT_PING_M_REQ 0x1180      // master reguest
+#define TYPE_PKT_PING_M_REQ 0x1180      // master request
 #define TYPE_PKT_PING_S_GNT 0x2280      // slave grant
 #define TYPE_PKT_PING_M     0x7780      // pingpong master packet
 #define TYPE_PKT_PING_S     0x8880      // pingpong slave packet
-- 
1.7.3.4

