Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab0HSGnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 02:43:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55877 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab0HSGnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 02:43:04 -0400
From: Michal Simek <monstr@monstr.eu>
To: grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH] of: Fix missing includes - ll_temac
Date: Thu, 19 Aug 2010 08:42:58 +0200
Message-Id: <1282200178-1145-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is the next patch which is fixing missing header
which were removed from prom.h.

Related patches:
"of/address: Clean up function declarations" (sha1 id 22ae782f8)
"of: Fix missing includes" (sha1 id f1ca09b2b)

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 drivers/net/ll_temac_main.c |    1 +
 drivers/net/ll_temac_mdio.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ll_temac_main.c b/drivers/net/ll_temac_main.c
index c7b6247..a9d216d 100644
--- a/drivers/net/ll_temac_main.c
+++ b/drivers/net/ll_temac_main.c
@@ -38,6 +38,7 @@
 #include <linux/of_device.h>
 #include <linux/of_mdio.h>
 #include <linux/of_platform.h>
+#include <linux/of_address.h>
 #include <linux/skbuff.h>
 #include <linux/spinlock.h>
 #include <linux/tcp.h>      /* needed for sizeof(tcphdr) */
diff --git a/drivers/net/ll_temac_mdio.c b/drivers/net/ll_temac_mdio.c
index 5ae28c9..8cf9d4f 100644
--- a/drivers/net/ll_temac_mdio.c
+++ b/drivers/net/ll_temac_mdio.c
@@ -10,6 +10,7 @@
 #include <linux/phy.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/of_address.h>
 #include <linux/slab.h>
 #include <linux/of_mdio.h>
 
-- 
1.5.5.6

