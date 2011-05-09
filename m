Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab1EJItn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:49:43 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:53085
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755995Ab1EJIau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:30:50 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 183/206] Staging: hv: Include the new header files in the network driver
Date: Mon,  9 May 2011 14:57:45 -0700
Message-Id: <1304978288-22999-183-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include the new header files in the network driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/netvsc.c       |    7 ++-----
 drivers/staging/hv/netvsc_drv.c   |    8 +++-----
 drivers/staging/hv/rndis_filter.c |    8 ++++----
 3 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 4eb4482..e489a32 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -27,12 +27,9 @@
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/slab.h>
-#include "hv_api.h"
-#include "logging.h"
-#include "netvsc.h"
-#include "rndis_filter.h"
-#include "channel.h"
 
+#include <linux/hyperv.h>
+#include "hyperv_net.h"
 
 /* Globals */
 static const char *driver_name = "netvsc";
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index c5e7b93..aac6748 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -38,11 +38,9 @@
 #include <net/route.h>
 #include <net/sock.h>
 #include <net/pkt_sched.h>
-#include "hv_api.h"
-#include "logging.h"
-#include "version_info.h"
-#include "vmbus.h"
-#include "netvsc_api.h"
+
+#include <linux/hyperv.h>
+#include "hyperv_net.h"
 
 struct net_device_context {
 	/* point back to our device context */
diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index 2037836..727b810 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -26,10 +26,10 @@
 #include <linux/io.h>
 #include <linux/if_ether.h>
 #include <linux/netdevice.h>
-#include "logging.h"
-#include "hv_api.h"
-#include "netvsc_api.h"
-#include "rndis_filter.h"
+
+#include <linux/hyperv.h>
+#include "hyperv_net.h"
+
 
 /* Data types */
 struct rndis_filter_driver_object {
-- 
1.7.4.1

