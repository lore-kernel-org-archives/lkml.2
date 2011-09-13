Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab1IMSPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 14:15:55 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:59849
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756225Ab1IMSPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 14:15:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 11/20] Staging: hv: storvsc: Get rid of some unnecessary state and definitions
Date: Tue, 13 Sep 2011 10:59:47 -0700
Message-Id: <1315936796-20662-11-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315936796-20662-1-git-send-email-kys@microsoft.com>
References: <1315936759-20623-1-git-send-email-kys@microsoft.com>
 <1315936796-20662-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, get rid of some unnecessary state and definitions.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index ce8652e..5e306a5 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -245,7 +245,6 @@ enum storvsc_request_type {
 
 
 struct hv_storvsc_request {
-	struct hv_storvsc_request *request;
 	struct hv_device *device;
 
 	/* Synchronize the request/response if needed */
@@ -260,14 +259,6 @@ struct hv_storvsc_request {
 };
 
 
-struct storvsc_device_info {
-	u32 ring_buffer_size;
-	unsigned int port_number;
-	unsigned char path_id;
-	unsigned char target_id;
-};
-
-
 /* A storvsc device is a device object that contains a vmbus channel */
 struct storvsc_device {
 	struct hv_device *device;
-- 
1.7.4.1

