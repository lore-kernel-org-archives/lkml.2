Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab1GUQ6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:58:20 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:36590
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751333Ab1GUQ6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:58:19 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 1/9] staging: hv: remove unnecessary includes in netvsc
Date: Thu, 21 Jul 2011 10:14:49 -0700
Message-Id: <1311268497-8671-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311268497-8671-1-git-send-email-haiyangz@microsoft.com>
References: <1311268497-8671-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hyperv.h is included by hyperv_net.h already, so no need to include it
again in these C files.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/netvsc.c       |    1 -
 drivers/staging/hv/netvsc_drv.c   |    1 -
 drivers/staging/hv/rndis_filter.c |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 16a80b1..c3cc880 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -29,7 +29,6 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 
-#include "hyperv.h"
 #include "hyperv_net.h"
 
 
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 474c5f0..1325de4 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -38,7 +38,6 @@
 #include <net/sock.h>
 #include <net/pkt_sched.h>
 
-#include "hyperv.h"
 #include "hyperv_net.h"
 
 static const char *driver_name = "netvsc";
diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index 6db48b9..8416bf2 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -27,7 +27,6 @@
 #include <linux/if_ether.h>
 #include <linux/netdevice.h>
 
-#include "hyperv.h"
 #include "hyperv_net.h"
 
 
-- 
1.6.3.2

