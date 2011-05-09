Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab1EIWJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:09:40 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47367
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752871Ab1EIVoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:44 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 027/206] Staging: hv: Rename stor_vsc_on_receive
Date: Mon,  9 May 2011 14:55:09 -0700
Message-Id: <1304978288-22999-27-git-send-email-kys@microsoft.com>
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
index ecc62e1..ab9da5c 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -341,7 +341,7 @@ static void storvsc_on_io_completion(struct hv_device *device,
 	put_stor_device(device);
 }
 
-static void stor_vsc_on_receive(struct hv_device *device,
+static void storvsc_on_receive(struct hv_device *device,
 			     struct vstor_packet *vstor_packet,
 			     struct hv_storvsc_request *request)
 {
@@ -399,7 +399,7 @@ static void stor_vsc_on_channel_callback(void *context)
 				       sizeof(struct vstor_packet));
 				complete(&request->wait_event);
 			} else {
-				stor_vsc_on_receive(device,
+				storvsc_on_receive(device,
 						(struct vstor_packet *)packet,
 						request);
 			}
-- 
1.7.4.1

