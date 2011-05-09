Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab1EIWIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:08:39 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47378
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752922Ab1EIVoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:44 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 029/206] Staging: hv: Rename stor_vsc_connect_to_vsp
Date: Mon,  9 May 2011 14:55:11 -0700
Message-Id: <1304978288-22999-29-git-send-email-kys@microsoft.com>
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
 drivers/staging/hv/storvsc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index b2ffbb7..234ce8b 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -412,7 +412,7 @@ static void storvsc_on_channel_callback(void *context)
 	return;
 }
 
-static int stor_vsc_connect_to_vsp(struct hv_device *device)
+static int storvsc_connect_to_vsp(struct hv_device *device)
 {
 	struct vmstorage_channel_properties props;
 	struct storvsc_driver *stor_driver;
@@ -471,7 +471,7 @@ int storvsc_dev_add(struct hv_device *device,
 
 	stor_device->port_number = device_info->port_number;
 	/* Send it back up */
-	ret = stor_vsc_connect_to_vsp(device);
+	ret = storvsc_connect_to_vsp(device);
 
 	device_info->path_id = stor_device->path_id;
 	device_info->target_id = stor_device->target_id;
-- 
1.7.4.1

