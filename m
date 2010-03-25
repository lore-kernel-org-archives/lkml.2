Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab0CYRXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 13:23:07 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:40717 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab0CYRXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 13:23:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=JNhQ+0L1l5+0QbnhzGIMDH7uvhu2wYEADYO4XQgpLa//V2H6CnKJV8zBSXRMV9V0qe
         gSwHTC7ZlizgJlrqCeTxKCEGu7fGusfns85HenTfLhgpD1xyrn1XKmy+zTYR7aWtdF/f
         d4FDYv7eFv1UzBc4H5SlLgGc4cdzo1ypUQo8c=
From: Andrea Gelmini <andrea.gelmini@gelma.net>
To: linux-doc@vger.kernel.org
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>,
       Russell King <linux@arm.linux.org.uk>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Andrew Victor <linux@maxim.org.za>, Dmitry Torokhov <dtor@mail.ru>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/16] ARM mach-at91: duplicated include
Date: Thu, 25 Mar 2010 18:22:32 +0100
Message-Id: <1269537767-7553-2-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: git-send-email 1.7.0.3.296.g9776a
In-Reply-To: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
References: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/mach-at91/board-sam9m10g45ek.c: mach/hardware.h is included more than once

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/arm/mach-at91/board-sam9m10g45ek.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
index 98f9f4b..ee80059 100644
--- a/arch/arm/mach-at91/board-sam9m10g45ek.c
+++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
@@ -25,7 +25,6 @@
 #include <linux/leds.h>
 #include <linux/clk.h>
 
-#include <mach/hardware.h>
 #include <video/atmel_lcdc.h>
 
 #include <asm/setup.h>
-- 
1.7.0.3.296.g9776a

