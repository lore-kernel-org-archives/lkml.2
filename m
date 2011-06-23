Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab1FWGjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 02:39:11 -0400
Received: from mail.perches.com ([173.55.12.10]:3157 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755672Ab1FWGjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 02:39:05 -0400
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] lib8390: Remove unnecessary extern
Date: Wed, 22 Jun 2011 23:38:59 -0700
Message-Id: <7cbec6eecb746e4cde5189a98b349dda92f02bd0.1308810463.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.rc3
In-Reply-To: <cover.1308810463.git.joe@perches.com>
References: <cover.1308810463.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Already declared in 8390.h

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/lib8390.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/lib8390.c b/drivers/net/lib8390.c
index 946b255..05ae214 100644
--- a/drivers/net/lib8390.c
+++ b/drivers/net/lib8390.c
@@ -108,7 +108,6 @@ int ei_debug = 1;
 /* Index to functions. */
 static void ei_tx_intr(struct net_device *dev);
 static void ei_tx_err(struct net_device *dev);
-void ei_tx_timeout(struct net_device *dev);
 static void ei_receive(struct net_device *dev);
 static void ei_rx_overrun(struct net_device *dev);
 
-- 
1.7.6.rc3

