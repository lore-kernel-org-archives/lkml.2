Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902Ab1CRWAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 18:00:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41083
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932857Ab1CRV7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:59:45 -0400
Date: Fri, 18 Mar 2011 15:00:23 -0700 (PDT)
Message-Id: <20110318.150023.27819221.davem@davemloft.net>
To: grant.likely@secretlab.ca
CC: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] of_mmc_spi: Need to include irq.h and of_irq.h
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since these are the headers that provide irq_of_parse_and_map()
and NO_IRQ.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/mmc/host/of_mmc_spi.c b/drivers/mmc/host/of_mmc_spi.c
index 5530def..e2aecb7 100644
--- a/drivers/mmc/host/of_mmc_spi.c
+++ b/drivers/mmc/host/of_mmc_spi.c
@@ -15,9 +15,11 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/slab.h>
+#include <linux/irq.h>
 #include <linux/gpio.h>
 #include <linux/of.h>
 #include <linux/of_gpio.h>
+#include <linux/of_irq.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/mmc_spi.h>
 #include <linux/mmc/core.h>
