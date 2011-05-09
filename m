Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab1EIWBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:01:35 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47466
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754895Ab1EIVor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:47 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 049/206] Staging: hv: Staging: hv: Rename the function stor_vsc_on_host_reset()
Date: Mon,  9 May 2011 14:55:31 -0700
Message-Id: <1304978288-22999-49-git-send-email-kys@microsoft.com>
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
 drivers/staging/hv/storvsc_drv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 4c08328..d8ce28e 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -536,7 +536,7 @@ static int storvsc_drv_init(void)
 }
 
 
-static int stor_vsc_on_host_reset(struct hv_device *device)
+static int storvsc_host_reset(struct hv_device *device)
 {
 	struct storvsc_device *stor_device;
 	struct hv_storvsc_request *request;
@@ -933,7 +933,7 @@ static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
 		    scmnd->device, dev);
 
 	/* Invokes the vsc to reset the host/bus */
-	ret = stor_vsc_on_host_reset(dev);
+	ret = storvsc_host_reset(dev);
 	if (ret != 0)
 		return ret;
 
-- 
1.7.4.1

