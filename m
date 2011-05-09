Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab1EIVuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:50:12 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47672
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755065Ab1EIVox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:53 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 109/206] Staging: hv: Rename the variable gSupportedDeviceClasses
Date: Mon,  9 May 2011 14:56:31 -0700
Message-Id: <1304978288-22999-109-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject line says it all.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/channel_mgmt.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index 1929ab3..71b79c6 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -42,7 +42,7 @@ struct vmbus_channel_message_table_entry {
 #define MAX_NUM_DEVICE_CLASSES_SUPPORTED 8
 
 static const struct hv_guid
-	gSupportedDeviceClasses[MAX_NUM_DEVICE_CLASSES_SUPPORTED] = {
+	supported_device_classes[MAX_NUM_DEVICE_CLASSES_SUPPORTED] = {
 	/* {ba6163d9-04a1-4d29-b605-72e2ffb1dc7f} */
 	/* Storage - SCSI */
 	{
@@ -459,7 +459,8 @@ static void vmbus_onoffer(struct vmbus_channel_message_header *hdr)
 	offer = (struct vmbus_channel_offer_channel *)hdr;
 	for (i = 0; i < MAX_NUM_DEVICE_CLASSES_SUPPORTED; i++) {
 		if (memcmp(&offer->offer.if_type,
-		    &gSupportedDeviceClasses[i], sizeof(struct hv_guid)) == 0) {
+			&supported_device_classes[i],
+			sizeof(struct hv_guid)) == 0) {
 			fsupported = 1;
 			break;
 		}
-- 
1.7.4.1

