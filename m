Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab2ARXpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 18:45:55 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:53526 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753130Ab2ARXpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 18:45:53 -0500
X-Authenticated: #10150493
X-Provags-ID: V01U2FsdGVkX1/WhuxpmhTWAonpY/TzqcBWChTCTvwK1KcO37w6YS
	4dqiyWb+cdmT7k
Message-ID: <4F1759A8.5080209@gmx.de>
Date: Thu, 19 Jan 2012 00:45:44 +0100
From: Thomas Faber <thfabba@gmx.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>,
        Po-Yu Chuang <ratbert@faraday-tech.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: ftgmac100/ftmac100: add missing interrupt.h include
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes compilation failure of these modules due to missing
irqreturn_t type for the ft(g)mac100_interrupt definition.

Signed-off-by: Thomas Faber <thfabba@gmx.de>
---
 drivers/net/ethernet/faraday/ftgmac100.c |    1 +
 drivers/net/ethernet/faraday/ftmac100.c  |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index fb5579a..47f85c3 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -25,6 +25,7 @@
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/init.h>
+#include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
index a127cb2..bb336a0 100644
--- a/drivers/net/ethernet/faraday/ftmac100.c
+++ b/drivers/net/ethernet/faraday/ftmac100.c
@@ -25,6 +25,7 @@
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/init.h>
+#include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/mii.h>
 #include <linux/module.h>
--
1.7.3.4
