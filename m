Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab0FAM1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:27:49 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37804 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191Ab0FAM1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:27:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=PZX+St9smZq8WkvQvjEJrETwKzHCgF8Bu+B4IgsjddMeUAOJ9nDirexLqrB+NOx6/r
         WwWj5af5cka7z+ASXj8XgJxK57OBF8xEKyEVEuvVkkrAfVkrlKRdLsOd1+YOo7F/Gyuc
         qBddd9+0n1DLhKhLAq27hxIIu6fDEDIRDAMW4=
MIME-Version: 1.0
Date: Tue, 1 Jun 2010 13:27:46 +0100
Message-ID: <AANLkTimtfC5mRVNCW5Qv_6yV3_qfYn1_1sF_9lNL59LP@mail.gmail.com>
Subject: [2.6.35-rc1, patch] omap2/3 ohci build failure...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Anand Gadiyar <gadiyar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the 'DMA_BIT_MASK' missing symbol causing build failure when
building 2.6.35-rc1 for an TI OMAP2/3 platform.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/arch/arm/mach-omap2/usb-ehci.c b/arch/arm/mach-omap2/usb-ehci.c
index c68f799..d1a4f22 100644
--- a/arch/arm/mach-omap2/usb-ehci.c
+++ b/arch/arm/mach-omap2/usb-ehci.c
@@ -19,6 +19,7 @@
 #include <linux/errno.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
 #include <linux/clk.h>
 #include <asm/io.h>
 #include <plat/mux.h>
-- 
Daniel J Blueman
