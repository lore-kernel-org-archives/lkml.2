Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760129Ab2DKL4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 07:56:00 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:61951 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab2DKLyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 07:54:55 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: plagnioj@jcrosoft.com, Josh.wu@atmel.com, Josh Wu <josh.wu@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/5] MAINTAINERS: add entry for Atmel touch screen ADC controller driver
Date: Wed, 11 Apr 2012 13:54:43 +0200
Message-Id: <c1168d0e754fce861b451eba0db61d179074ac49.1334137680.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9.4
In-Reply-To: <cover.1334137680.git.nicolas.ferre@atmel.com>
References: <cover.1334137680.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1334137680.git.nicolas.ferre@atmel.com>
References: <cover.1334137680.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Wu <josh.wu@atmel.com>

Signed-off-by: Josh Wu <josh.wu@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 652dad7..0ac46d8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1355,6 +1355,12 @@ M:	Nicolas Ferre <nicolas.ferre@atmel.com>
 S:	Supported
 F:	drivers/spi/spi-atmel.*
 
+ATMEL TSADCC DRIVER
+M:	Josh Wu <josh.wu@atmel.com>
+L:	linux-input@vger.kernel.org
+S:	Supported
+F:	drivers/input/touchscreen/atmel_tsadcc.c
+
 ATMEL USBA UDC DRIVER
 M:	Nicolas Ferre <nicolas.ferre@atmel.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-- 
1.7.9.4

