Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab2DKLyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 07:54:54 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:12692 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab2DKLyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 07:54:53 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: plagnioj@jcrosoft.com, Josh.wu@atmel.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3/5] MAINTAINERS: add entry for Atmel DMA driver
Date: Wed, 11 Apr 2012 13:54:44 +0200
Message-Id: <a322a49e3fe11155f8b0dc19bedaf21018b390fb.1334137680.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9.4
In-Reply-To: <cover.1334137680.git.nicolas.ferre@atmel.com>
References: <cover.1334137680.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1334137680.git.nicolas.ferre@atmel.com>
References: <cover.1334137680.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0ac46d8..4fc6a6c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1331,6 +1331,14 @@ M:	Nicolas Ferre <nicolas.ferre@atmel.com>
 S:	Supported
 F:	drivers/tty/serial/atmel_serial.c
 
+ATMEL DMA DRIVER
+M:	Nicolas Ferre <nicolas.ferre@atmel.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Supported
+F:	drivers/dma/at_hdmac.c
+F:	drivers/dma/at_hdmac_regs.h
+F:	arch/arm/mach-at91/include/mach/at_hdmac.h
+
 ATMEL ISI DRIVER
 M:	Josh Wu <josh.wu@atmel.com>
 L:	linux-media@vger.kernel.org
-- 
1.7.9.4

