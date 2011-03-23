Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab1CWSLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 14:11:54 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:33315
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755392Ab1CWSLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 14:11:53 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 16/16] Staging: hv: Make the function stor_vsc_on_host_reset() static
Date: Wed, 23 Mar 2011 10:50:34 -0700
Message-Id: <1300902635-1347-16-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300902635-1347-1-git-send-email-kys@microsoft.com>
References: <1300902537-1290-1-git-send-email-kys@microsoft.com>
 <1300902635-1347-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make stor_vsc_on_host_reset() a static function.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_api.h |    1 -
 drivers/staging/hv/storvsc_drv.c |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index d46b4de..5f41ef6 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -163,7 +163,6 @@ static inline void put_stor_device(struct hv_device *device)
 }
 
 /* Interface */
-int stor_vsc_on_host_reset(struct hv_device *device);
 
 int stor_vsc_on_device_add(struct hv_device *device,
 				void *additional_info);
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index e0a1195..127d122 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -233,7 +233,7 @@ static int storvsc_drv_init(void)
 }
 
 
-int stor_vsc_on_host_reset(struct hv_device *device)
+static int stor_vsc_on_host_reset(struct hv_device *device)
 {
 	struct storvsc_device *stor_device;
 	struct storvsc_request_extension *request;
-- 
1.7.4.1

