Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab1DUTua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:50:30 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:58309
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753417Ab1DUTuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:50:21 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 7/8] staging: hv: clean up unused forward declarations
Date: Thu, 21 Apr 2011 12:30:46 -0700
Message-Id: <1303414247-22118-8-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303414247-22118-1-git-send-email-haiyangz@microsoft.com>
References: <1303414247-22118-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/netvsc.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 1c3bdda..5838ed4 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -45,18 +45,6 @@ static const struct hv_guid netvsc_device_type = {
 	}
 };
 
-static int netvsc_init_send_buf(struct hv_device *device);
-
-static int netvsc_init_recv_buf(struct hv_device *device);
-
-static int netvsc_connect_vsp(struct hv_device *device);
-
-static void netvsc_send_completion(struct hv_device *device,
-				   struct vmpacket_descriptor *packet);
-
-static void netvsc_receive(struct hv_device *device,
-			    struct vmpacket_descriptor *packet);
-
 
 static struct netvsc_device *alloc_net_device(struct hv_device *device)
 {
-- 
1.6.3.2

