Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523Ab1IATGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 15:06:13 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:35919
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757144Ab1IATGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 15:06:12 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 01/10] staging: hv: remove unnecessary includes in netvsc
Date: Thu,  1 Sep 2011 12:19:39 -0700
Message-Id: <1314904788-32746-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314904788-32746-1-git-send-email-haiyangz@microsoft.com>
References: <1314904788-32746-1-git-send-email-haiyangz@microsoft.com>
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
index 30d3139..9a9228c 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -28,7 +28,6 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 
-#include "hyperv.h"
 #include "hyperv_net.h"
 
 
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 90a3198..30a0cb2 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -38,7 +38,6 @@
 #include <net/sock.h>
 #include <net/pkt_sched.h>
 
-#include "hyperv.h"
 #include "hyperv_net.h"
 
 struct net_device_context {
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

