Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab2BVQPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:15:50 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:40678 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab2BVQPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:15:45 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 1/2] ARM: at91: add at91sam9g25ek.dts in Makefile.boot
Date: Wed, 22 Feb 2012 17:15:26 +0100
Message-Id: <76d3abda7e00e0bd2c8b42b2cf87ff8da16314c0.1329926750.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329927327-10613-1-git-send-email-nicolas.ferre@atmel.com>
References: <5a6951fcbe28c3093c936d40c4b28f7ae3161d8d.1329903206.git.nicolas.ferre@atmel.com>
 <1329927327-10613-1-git-send-email-nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/Makefile.boot |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-at91/Makefile.boot b/arch/arm/mach-at91/Makefile.boot
index 2fd051e..be7200b 100644
--- a/arch/arm/mach-at91/Makefile.boot
+++ b/arch/arm/mach-at91/Makefile.boot
@@ -14,3 +14,4 @@ initrd_phys-y	:= 0x20410000
 endif
 
 dtb-$(CONFIG_MACH_AT91SAM_DT) += at91sam9m10g45ek.dtb usb_a9g20.dtb
+dtb-$(CONFIG_MACH_AT91SAM_DT) += at91sam9g25ek.dtb
-- 
1.7.9

