Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030200Ab2EPKX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 06:23:57 -0400
Received: from skyrme.org ([193.175.80.135]:36920 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967019Ab2EPKXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 06:23:54 -0400
Date: 16 May 2012 09:41:18 +0000
Message-Id: <1337161280-28953-4-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, hannes@cmpxchg.org, shess@hessware.de,
        "Oskar Schirmer" <oskar@scara.com>, netdev@vger.kernel.org
Subject: [PATCH 3/5] net: Change mail address of Oskar Schirmer
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1337161280-28953-1-git-send-email-oskar@scara.com>
References: <1337161280-28953-1-git-send-email-oskar@scara.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That old mail address doesnt exist any more.
This changes all occurences to my new address.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
Cc: netdev@vger.kernel.org
---
 drivers/net/ethernet/s6gmac.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/s6gmac.c b/drivers/net/ethernet/s6gmac.c
index 1895605..6f0d284 100644
--- a/drivers/net/ethernet/s6gmac.c
+++ b/drivers/net/ethernet/s6gmac.c
@@ -1,7 +1,7 @@
 /*
  * Ethernet driver for S6105 on chip network device
  * (c)2008 emlix GmbH http://www.emlix.com
- * Authors:	Oskar Schirmer <os@emlix.com>
+ * Authors:	Oskar Schirmer <oskar@scara.com>
  *		Daniel Gloeckner <dg@emlix.com>
  *
  * This program is free software; you can redistribute it and/or
@@ -1070,4 +1070,4 @@ module_exit(s6gmac_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("S6105 on chip Ethernet driver");
-MODULE_AUTHOR("Oskar Schirmer <os@emlix.com>");
+MODULE_AUTHOR("Oskar Schirmer <oskar@scara.com>");
-- 
1.7.5.4

