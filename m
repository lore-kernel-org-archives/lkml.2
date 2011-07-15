Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab1GORp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:45:26 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:33277
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754082Ab1GORaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:30:01 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 056/117] Staging: hv: storvsc: Fix/cleanup some dated comments in storvsc.c
Date: Fri, 15 Jul 2011 10:46:44 -0700
Message-Id: <1310752065-27895-56-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix/cleanup some dated comments in storvsc.c.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 3730f3f..827b6a3 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -166,7 +166,6 @@ static int storvsc_channel_init(struct hv_device *device)
 		goto cleanup;
 	}
 
-	/* TODO: Check returned version */
 	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
 	    vstor_packet->status != 0)
 		goto cleanup;
@@ -193,7 +192,6 @@ static int storvsc_channel_init(struct hv_device *device)
 		goto cleanup;
 	}
 
-	/* TODO: Check returned version */
 	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
 	    vstor_packet->status != 0)
 		goto cleanup;
@@ -384,11 +382,12 @@ int storvsc_dev_add(struct hv_device *device,
 
 	/* Save the channel properties to our storvsc channel */
 
-	/* FIXME: */
 	/*
 	 * If we support more than 1 scsi channel, we need to set the
 	 * port number here to the scsi channel but how do we get the
-	 * scsi channel prior to the bus scan
+	 * scsi channel prior to the bus scan.
+	 *
+	 * The host does not support this.
 	 */
 
 	stor_device->port_number = device_info->port_number;
@@ -545,4 +544,3 @@ int storvsc_get_major_info(struct storvsc_device_info *device_info,
 
 	return -ENODEV;
 }
-
-- 
1.7.4.1

