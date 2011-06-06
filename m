Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271Ab1FFWgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:36:45 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:39500
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758215Ab1FFWfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:35:05 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: [PATCH 07/49] Staging: hv: stor: Rename the vriable gStorVscDeviceType in storvsc_drv.c
Date: Mon,  6 Jun 2011 15:49:31 -0700
Message-Id: <1307400613-13234-7-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307400613-13234-1-git-send-email-kys@microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the vriable gStorVscDeviceType in storvsc_drv.c.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 73fbded..9e51356 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -44,7 +44,7 @@ MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
 static const char *driver_name = "storvsc";
 
 /* {ba6163d9-04a1-4d29-b605-72e2ffb1dc7f} */
-static const struct hv_guid gStorVscDeviceType = {
+static const struct hv_guid stor_vsci_device_type = {
 	.data = {
 		0xd9, 0x63, 0x61, 0xba, 0xa1, 0x04, 0x29, 0x4d,
 		0xb6, 0x05, 0x72, 0xe2, 0xff, 0xb1, 0xdc, 0x7f
@@ -742,7 +742,7 @@ static int __init storvsc_drv_init(void)
 	sizeof(struct vstor_packet) + sizeof(u64),
 	sizeof(u64)));
 
-	memcpy(&drv->dev_type, &gStorVscDeviceType,
+	memcpy(&drv->dev_type, &stor_vsci_device_type,
 	       sizeof(struct hv_guid));
 
 	if (max_outstanding_req_per_channel <
-- 
1.7.4.1

