Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240Ab2HHM4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 08:56:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51179 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758177Ab2HHMzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 08:55:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 5/6] ARM: integrator: include <linux/export.h
Date: Wed,  8 Aug 2012 14:54:52 +0200
Message-Id: <1344430493-5304-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1344430493-5304-1-git-send-email-arnd@arndb.de>
References: <1344430493-5304-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:+fGNomzR/ONSTTj+4XtP2QNQV9X7zDwC7pG9fla8ptp
 x5gWHwDhViaK7t0Cxf6BMGdTQSuzBlYfcZiOXU6PqnudwgxMbN
 SWwcQ3m+xgTRNNVEA+KG/7pJwc638VAzJvv31Y1v7cqWDcEhCa
 yP5qN3sm4vxfQmmtYdOap6C2aRsuP/3cL2+GskSBRXXN1dSpeC
 wzyLoXdiVRWDdACTPDnD3CIWEy7zr318VZ0J/Uh+8vA+CNF1Rp
 DzA+TpskvqgyAwWHkssjMCA0BkzyYJKF1V9XEKJVZ9VGv2wVgO
 oFqdJccQz0QsnX2FINqYRXRxRgi4lbVHSn8sxruNUiPrPqK6bq
 g063aRhFgJq6+OwIATT6stm/hE+itZwOaF/v+fe8KuGHoBUCqP
 vXdj33Xjey0ow==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch, building integrator_defconfig results in:

arch/arm/mach-integrator/core.c:150:1: warning: data definition has no type or storage class [enabled by default]
arch/arm/mach-integrator/core.c:150:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
arch/arm/mach-integrator/core.c:150:1: warning: parameter names (without types) in function declaration [enabled by default]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/mach-integrator/core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-integrator/core.c b/arch/arm/mach-integrator/core.c
index ebf680b..3fa6c51 100644
--- a/arch/arm/mach-integrator/core.c
+++ b/arch/arm/mach-integrator/core.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/device.h>
+#include <linux/export.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
-- 
1.7.10

