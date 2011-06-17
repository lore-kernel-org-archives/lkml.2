Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211Ab1FQOmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:42:46 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:33358
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757848Ab1FQOmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:42:44 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 2/5] staging: hv: remove unnecessary includes in netvsc
Date: Fri, 17 Jun 2011 07:58:05 -0700
Message-Id: <1308322688-9796-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308322688-9796-1-git-send-email-haiyangz@microsoft.com>
References: <1308322688-9796-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hyperv.h is included by hyperv_net.h already, so no need to include it
again in these C files.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/netvsc.c       |    1 -
 drivers/staging/hv/netvsc_drv.c   |    1 -
 drivers/staging/hv/rndis_filter.c |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index b6e1fb9..ed9b8af 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -28,7 +28,6 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 
-#include "hyperv.h"
 #include "hyperv_net.h"
 
 
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 8380fe9..e5aba38 100644
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

