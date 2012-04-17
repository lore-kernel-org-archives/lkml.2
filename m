Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab2DQBYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 21:24:36 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:3349 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab2DQBYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 21:24:34 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-127.messagelabs.com!1334625872!3266032!2
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] mmc: cd-gpio.c: Include header to pickup exported symbol prototypes
Date: Mon, 16 Apr 2012 18:24:26 -0700
User-Agent: KMail/1.9.9
CC: <linux-mmc@vger.kernel.org>, <cjb@laptop.org>, <g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204161824.26879.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include the linux/mmc/cd-gpio.h header to pickup the prototypes
for the two exported symbols.

This quiets the sparse warnings:

warning: symbol 'mmc_cd_gpio_request' was not declared. Should it be static?
warning: symbol 'mmc_cd_gpio_free' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Chris Ball <cjb@laptop.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

---

diff --git a/drivers/mmc/core/cd-gpio.c b/drivers/mmc/core/cd-gpio.c
index 29de31e..da7c3f9 100644
--- a/drivers/mmc/core/cd-gpio.c
+++ b/drivers/mmc/core/cd-gpio.c
@@ -13,6 +13,7 @@
 #include <linux/interrupt.h>
 #include <linux/jiffies.h>
 #include <linux/mmc/host.h>
+#include <linux/mmc/cd-gpio.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 
