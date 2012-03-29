Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759058Ab2C2N2C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 09:28:02 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:44938 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab2C2N1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 09:27:55 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Cc: plagnioj@jcrosoft.com, ludovic.desroches@atmel.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de, olof@lixom.net,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 11/12] USB: ehci-atmel: add needed of.h header file
Date: Thu, 29 Mar 2012 15:27:22 +0200
Message-Id: <9c773949b61764153d82c9612a228256b535c581.1333026637.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9.4
In-Reply-To: <cover.1333026637.git.nicolas.ferre@atmel.com>
References: <cover.1333026637.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1333026637.git.nicolas.ferre@atmel.com>
References: <cover.1333026637.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compilation error in case of non-DT configuration without this
of.h header file.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
---
 drivers/usb/host/ehci-atmel.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/ehci-atmel.c b/drivers/usb/host/ehci-atmel.c
index 19f318a..cf14c95 100644
--- a/drivers/usb/host/ehci-atmel.c
+++ b/drivers/usb/host/ehci-atmel.c
@@ -13,6 +13,7 @@
 
 #include <linux/clk.h>
 #include <linux/platform_device.h>
+#include <linux/of.h>
 #include <linux/of_platform.h>
 
 /* interface and function clocks */
-- 
1.7.9.4

