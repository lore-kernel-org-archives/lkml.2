Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab1DUTul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:50:41 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:48177
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753412Ab1DUTuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:50:21 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 8/8] staging: hv: convert function name NetVscDisconnectFromVsp to lower case
Date: Thu, 21 Apr 2011 12:30:47 -0700
Message-Id: <1303414247-22118-9-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303414247-22118-1-git-send-email-haiyangz@microsoft.com>
References: <1303414247-22118-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/netvsc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 5838ed4..b3e6497 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -571,7 +571,7 @@ cleanup:
 	return ret;
 }
 
-static void NetVscDisconnectFromVsp(struct netvsc_device *net_device)
+static void netvsc_disconnect_vsp(struct netvsc_device *net_device)
 {
 	netvsc_destroy_recv_buf(net_device);
 	netvsc_destroy_send_buf(net_device);
@@ -600,7 +600,7 @@ static int netvsc_device_remove(struct hv_device *device)
 		udelay(100);
 	}
 
-	NetVscDisconnectFromVsp(net_device);
+	netvsc_disconnect_vsp(net_device);
 
 	/* Stop inbound traffic ie receives and sends completions */
 	net_device = release_inbound_net_device(device);
-- 
1.6.3.2

