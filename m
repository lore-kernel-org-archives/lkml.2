Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab0IMTtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:49:32 -0400
Received: from mail.perches.com ([173.55.12.10]:1918 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755421Ab0IMTsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:48:43 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 22/25] net/dsa: Use static const char arrays
Date: Mon, 13 Sep 2010 12:48:00 -0700
Message-Id: <6f30d7cee56ea84ece4fea487a7859857c811cb0.1284406639.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284406638.git.joe@perches.com>
References: <cover.1284406638.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/dsa/dsa.c      |    2 +-
 net/dsa/dsa_priv.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 6112a12..cca6a10 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -15,7 +15,7 @@
 #include <net/dsa.h>
 #include "dsa_priv.h"
 
-char dsa_driver_version[] = "0.1";
+const char dsa_driver_version[] = "0.1";
 
 
 /* switch driver registration ***********************************************/
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 4b0ea05..634c22d 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -158,7 +158,7 @@ struct dsa_switch_driver {
 };
 
 /* dsa.c */
-extern char dsa_driver_version[];
+extern const char dsa_driver_version[];
 void register_switch_driver(struct dsa_switch_driver *type);
 void unregister_switch_driver(struct dsa_switch_driver *type);
 
-- 
1.7.3.rc1

