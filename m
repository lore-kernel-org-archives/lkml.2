Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab2KWADq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 19:03:46 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:56336 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab2KWADp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 19:03:45 -0500
From: Andrea Adami <andrea.adami@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: pxa: pxa25x.c: add dummy SA1100 rtc clock
Date: Fri, 23 Nov 2012 01:03:39 +0100
Message-Id: <1353629019-32203-1-git-send-email-andrea.adami@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* fix failure seen on Zaurus corgi:
* sa1100-rtc sa1100-rtc: failed to find rtc clock source
* sa1100-rtc: probe of sa1100-rtc failed with error -2

Signed-off-by: Andrea Adami <andrea.adami@gmail.com>
---
 arch/arm/mach-pxa/pxa25x.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-pxa/pxa25x.c b/arch/arm/mach-pxa/pxa25x.c
index 3352b37..0f05671 100644
--- a/arch/arm/mach-pxa/pxa25x.c
+++ b/arch/arm/mach-pxa/pxa25x.c
@@ -209,6 +209,7 @@ static struct clk_lookup pxa25x_clkregs[] = {
 	INIT_CLKREG(&clk_pxa25x_gpio12, NULL, "GPIO12_CLK"),
 	INIT_CLKREG(&clk_pxa25x_mem, "pxa2xx-pcmcia", NULL),
 	INIT_CLKREG(&clk_dummy, "pxa-gpio", NULL),
+	INIT_CLKREG(&clk_dummy, "sa1100-rtc", NULL),
 };
 
 static struct clk_lookup pxa25x_hwuart_clkreg =
-- 
1.7.8.6

