Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab1EIWIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:08:37 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:48597
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752988Ab1EIVoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:44 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 028/206] Staging: hv: Rename stor_vsc_on_channel_callback
Date: Mon,  9 May 2011 14:55:10 -0700
Message-Id: <1304978288-22999-28-git-send-email-kys@microsoft.com>
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
index ab9da5c..b2ffbb7 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -362,7 +362,7 @@ static void storvsc_on_receive(struct hv_device *device,
 	}
 }
 
-static void stor_vsc_on_channel_callback(void *context)
+static void storvsc_on_channel_callback(void *context)
 {
 	struct hv_device *device = (struct hv_device *)context;
 	struct storvsc_device *stor_device;
@@ -427,7 +427,7 @@ static int stor_vsc_connect_to_vsp(struct hv_device *device)
 			 stor_driver->ring_buffer_size,
 			 (void *)&props,
 			 sizeof(struct vmstorage_channel_properties),
-			 stor_vsc_on_channel_callback, device);
+			 storvsc_on_channel_callback, device);
 
 	DPRINT_DBG(STORVSC, "storage props: path id %d, tgt id %d, max xfer %d",
 		   props.path_id, props.target_id, props.max_transfer_bytes);
-- 
1.7.4.1

