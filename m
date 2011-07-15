Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab1GORaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:30:20 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:60232
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753994Ab1GORaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:30:10 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 105/117] Staging: hv: storvsc: Make some non static functions, static functions
Date: Fri, 15 Jul 2011 10:47:33 -0700
Message-Id: <1310752065-27895-105-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make some non static functions, static functions.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 02f9c1e..a1e8d6a 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -645,7 +645,7 @@ static int storvsc_connect_to_vsp(struct hv_device *device, u32 ring_size)
 	return ret;
 }
 
-int storvsc_dev_add(struct hv_device *device,
+static int storvsc_dev_add(struct hv_device *device,
 					void *additional_info)
 {
 	struct storvsc_device *stor_device;
@@ -680,7 +680,7 @@ int storvsc_dev_add(struct hv_device *device,
 	return ret;
 }
 
-int storvsc_dev_remove(struct hv_device *device)
+static int storvsc_dev_remove(struct hv_device *device)
 {
 	struct storvsc_device *stor_device;
 	unsigned long flags;
@@ -714,7 +714,7 @@ int storvsc_dev_remove(struct hv_device *device)
 	return 0;
 }
 
-int storvsc_do_io(struct hv_device *device,
+static int storvsc_do_io(struct hv_device *device,
 			      struct hv_storvsc_request *request)
 {
 	struct storvsc_device *stor_device;
-- 
1.7.4.1

