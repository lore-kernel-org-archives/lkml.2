Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103Ab2DKLzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 07:55:01 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:20716 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759956Ab2DKLy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 07:54:58 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: plagnioj@jcrosoft.com, Josh.wu@atmel.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: [PATCH 5/5] MAINTAINERS: remove non-responding web link for atmel_usba driver
Date: Wed, 11 Apr 2012 13:54:46 +0200
Message-Id: <05cc973152bedd39bf37fa1222960c2a2c438500.1334137680.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9.4
In-Reply-To: <cover.1334137680.git.nicolas.ferre@atmel.com>
References: <cover.1334137680.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1334137680.git.nicolas.ferre@atmel.com>
References: <cover.1334137680.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
---
 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index be04d43..cde4008 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1379,7 +1379,6 @@ F:	drivers/input/touchscreen/atmel_tsadcc.c
 ATMEL USBA UDC DRIVER
 M:	Nicolas Ferre <nicolas.ferre@atmel.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-W:	http://avr32linux.org/twiki/bin/view/Main/AtmelUsbDeviceDriver
 S:	Supported
 F:	drivers/usb/gadget/atmel_usba_udc.*
 
-- 
1.7.9.4

