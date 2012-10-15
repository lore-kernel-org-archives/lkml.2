Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab2JOR0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:26:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59400 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab2JORYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:24:49 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 03/14] staging: csr: Removed trailing whitespaces on io.c
Date: Tue, 16 Oct 2012 02:24:22 +0900
Message-Id: <1350321868-2613-3-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350321868-2613-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350321868-2613-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just fixed a few trailing whitespaces from io.c.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/io.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/csr/io.c b/drivers/staging/csr/io.c
index b8556c4..b589408 100644
--- a/drivers/staging/csr/io.c
+++ b/drivers/staging/csr/io.c
@@ -10,7 +10,7 @@
  *	  recognise a UniFi being added to the system. This is because sdioemb
  *	  does not register itself as a device_driver, it uses it's own code
  *	  to handle insert and remove.
- *	  To have Ubuntu recognise UniFi, edit 
+ *	  To have Ubuntu recognise UniFi, edit
  *	  /etc/udev/rules.d/85-ifupdown.rules
  *	  to change this line:
  *		  SUBSYSTEM=="net", DRIVERS=="?*", GOTO="net_start"
@@ -178,7 +178,7 @@ uf_register_netdev(unifi_priv_t *priv, int interfaceTag)
 
 #ifdef CSR_SUPPORT_SME
 	/*
-	 * Register the inet handler; 
+	 * Register the inet handler;
 	 * it notifies us for changes in the IP address.
 	 */
 	uf_register_inet_notifier();
@@ -316,7 +316,7 @@ register_unifi_sdio(CsrSdioFunction *sdio_dev, int bus_id, struct device *dev)
 	Unifi_instances[bus_id] = priv;
 	In_use[bus_id] = UNIFI_DEV_IN_USE;
 
-	/* Save the netdev_priv for use by 
+	/* Save the netdev_priv for use by
 	 * the netdev event callback mechanism */
 	Unifi_netdev_instances[bus_id * CSR_WIFI_NUM_INTERFACES] =
 		netdev_priv(priv->netdev[0]);
-- 
1.7.9.5

