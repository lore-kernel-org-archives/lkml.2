Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab1GOSFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 14:05:15 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:60807
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753105Ab1GOSDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 14:03:14 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 023/117] Staging: hv: netvsc: Get rid of the PCI signature
Date: Fri, 15 Jul 2011 10:46:11 -0700
Message-Id: <1310752065-27895-23-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have implemented a vmbus specific mechanism for auto-loading,
get rid of the PCI signature.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/netvsc_drv.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 5847662..9352277 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -34,7 +34,6 @@
 #include <linux/in.h>
 #include <linux/slab.h>
 #include <linux/dmi.h>
-#include <linux/pci.h>
 #include <net/arp.h>
 #include <net/route.h>
 #include <net/sock.h>
@@ -480,13 +479,6 @@ static int __init netvsc_drv_init(void)
 	return ret;
 }
 
-static const struct pci_device_id __initconst
-hv_netvsc_pci_table[] __maybe_unused = {
-	{ PCI_DEVICE(0x1414, 0x5353) }, /* VGA compatible controller */
-	{ 0 }
-};
-MODULE_DEVICE_TABLE(pci, hv_netvsc_pci_table);
-
 MODULE_LICENSE("GPL");
 MODULE_VERSION(HV_DRV_VERSION);
 MODULE_DESCRIPTION("Microsoft Hyper-V network driver");
-- 
1.7.4.1

