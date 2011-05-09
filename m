Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab1EJIij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:38:39 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:35330
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756075Ab1EJIaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:30:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 185/206] Staging: hv: Include the newly created header file in the util driver
Date: Mon,  9 May 2011 14:57:47 -0700
Message-Id: <1304978288-22999-185-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include the newly created header file in the util driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/hv_kvp.c  |   11 +----------
 drivers/staging/hv/hv_util.c |   11 +----------
 2 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/hv/hv_kvp.c b/drivers/staging/hv/hv_kvp.c
index c71a148..94166e8 100644
--- a/drivers/staging/hv/hv_kvp.c
+++ b/drivers/staging/hv/hv_kvp.c
@@ -27,16 +27,7 @@
 #include <linux/connector.h>
 #include <linux/workqueue.h>
 
-#include "logging.h"
-#include "hv_api.h"
-#include "vmbus.h"
-#include "vmbus_packet_format.h"
-#include "vmbus_channel_interface.h"
-#include "version_info.h"
-#include "channel.h"
-#include "vmbus_private.h"
-#include "vmbus_api.h"
-#include "utils.h"
+#include <linux/hyperv.h>
 #include "hv_kvp.h"
 
 
diff --git a/drivers/staging/hv/hv_util.c b/drivers/staging/hv/hv_util.c
index ea76dda..14672b7 100644
--- a/drivers/staging/hv/hv_util.c
+++ b/drivers/staging/hv/hv_util.c
@@ -29,16 +29,7 @@
 #include <linux/dmi.h>
 #include <linux/pci.h>
 
-#include "logging.h"
-#include "hv_api.h"
-#include "vmbus.h"
-#include "vmbus_packet_format.h"
-#include "vmbus_channel_interface.h"
-#include "version_info.h"
-#include "channel.h"
-#include "vmbus_private.h"
-#include "vmbus_api.h"
-#include "utils.h"
+#include <linux/hyperv.h>
 #include "hv_kvp.h"
 
 static u8 *shut_txf_buf;
-- 
1.7.4.1

