Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab0KGVPM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 16:15:12 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:60092 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab0KGVPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 16:15:09 -0500
From: Stefan Weil <weil@mail.berlios.de>
Cc: Stefan Weil <weil@mail.berlios.de>, Ashish Gupta <asg@thelearninglabs.com>,
        Mike Frysinger <vapier@gentoo.org>,
        "David S. Miller" <davem@davemloft.net>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Blackfin: Fix spelling in unused code (struct name)
Date: Sun,  7 Nov 2010 22:14:53 +0100
Message-Id: <1289164493-9124-1-git-send-email-weil@mail.berlios.de>
X-Mailer: git-send-email 1.7.2.3
X-Provags-ID: V02:K0:iA5ruCx+4zpwSFcYDaSWRuZNEbKOYnCayq374KNgzTQ
 4yBB11/AkYBtlgGjVffKQ4GSnciQXZpW/aAn55vAaG5IJz1MdC
 HiMjAG8fzUPEPPcu3rGZXF4NrU1mTEmTrUjMf8gm4ephMSdht9
 R35My33QAfdds9R+pxGV257Zp8fr4rse+hk7h458GhbGKB5SYL
 uwc2Q524dd4vrmtxVYMxIfnk+S+RIl2nz+WUoVKL2tXaLOWFQ1
 uHci4nm5aOj9E
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

platfrom -> platform

This changes a struct name. The related code is conditionally
compiled and won't work because the include file linux/gpio-decoder.h
is missing, so removing this code would be an even better solution.

If the missing include file is added, it must fix the spelling, too.

Cc: Ashish Gupta <asg@thelearninglabs.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: uclinux-dist-devel@blackfin.uclinux.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Stefan Weil <weil@mail.berlios.de>
---
 arch/blackfin/mach-bf527/boards/tll6527m.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/mach-bf527/boards/tll6527m.c b/arch/blackfin/mach-bf527/boards/tll6527m.c
index 9ec5757..89ae87b 100644
--- a/arch/blackfin/mach-bf527/boards/tll6527m.c
+++ b/arch/blackfin/mach-bf527/boards/tll6527m.c
@@ -193,7 +193,7 @@ static unsigned gpio_addr_inputs[] = {
 	GPIO_PG1, GPIO_PH9, GPIO_PH10
 };
 
-static struct gpio_decoder_platfrom_data spi_decoded_cs = {
+static struct gpio_decoder_platform_data spi_decoded_cs = {
 	.base		= EXP_GPIO_SPISEL_BASE,
 	.input_addrs	= gpio_addr_inputs,
 	.nr_input_addrs = ARRAY_SIZE(gpio_addr_inputs),
-- 
1.7.2.3

