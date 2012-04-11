Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061Ab2DKLzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 07:55:36 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:16548 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543Ab2DKLyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 07:54:55 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: plagnioj@jcrosoft.com, Josh.wu@atmel.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 4/5] MAINTAINERS: add entry for Atmel timer counter (TC)
Date: Wed, 11 Apr 2012 13:54:45 +0200
Message-Id: <d8f2e44af30ba7fc2c40e614ea17d40cc82c374c.1334137680.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9.4
In-Reply-To: <cover.1334137680.git.nicolas.ferre@atmel.com>
References: <cover.1334137680.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1334137680.git.nicolas.ferre@atmel.com>
References: <cover.1334137680.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an entry for the Timer Counter (TC) library and the clocksource
driver that is using this library.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4fc6a6c..be04d43 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1363,6 +1363,13 @@ M:	Nicolas Ferre <nicolas.ferre@atmel.com>
 S:	Supported
 F:	drivers/spi/spi-atmel.*
 
+ATMEL Timer Counter (TC) AND CLOCKSOURCE DRIVERS
+M:	Nicolas Ferre <nicolas.ferre@atmel.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Supported
+F:	drivers/misc/atmel_tclib.c
+F:	drivers/clocksource/tcb_clksrc.c
+
 ATMEL TSADCC DRIVER
 M:	Josh Wu <josh.wu@atmel.com>
 L:	linux-input@vger.kernel.org
-- 
1.7.9.4

