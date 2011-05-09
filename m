Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab1EJJhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 05:37:33 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:46112
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752480Ab1EJJh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 05:37:29 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 131/206] Staging: hv: Get rid of some unnecessary DPRINTs
Date: Mon,  9 May 2011 14:56:53 -0700
Message-Id: <1304978288-22999-131-git-send-email-kys@microsoft.com>
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
 drivers/staging/hv/storvsc_drv.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 0d7e43b..07db877 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -103,10 +103,6 @@ static int storvsc_initialize(struct hv_driver *driver)
 			   sizeof(struct vstor_packet) + sizeof(u64),
 			   sizeof(u64)));
 
-	DPRINT_INFO(STORVSC, "max io %u, currently %u\n",
-		    stor_driver->max_outstanding_req_per_channel,
-		    STORVSC_MAX_IO_REQUESTS);
-
 
 	return 0;
 }
@@ -807,10 +803,6 @@ static int storvsc_drv_init(void)
 	/* Callback to client driver to complete the initialization */
 	storvsc_initialize(&storvsc_drv_obj->base);
 
-	DPRINT_INFO(STORVSC_DRV,
-		    "max outstanding reqs %u",
-		    storvsc_drv_obj->max_outstanding_req_per_channel);
-
 	if (storvsc_drv_obj->max_outstanding_req_per_channel <
 	    STORVSC_MAX_IO_REQUESTS)
 		return -1;
-- 
1.7.4.1

