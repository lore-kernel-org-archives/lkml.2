Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab1F3NfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 09:35:16 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49908 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab1F3NfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 09:35:11 -0400
Subject: [PATCH] ARM i.MX23/28: platform-mxsfb: Add missing include of
 linux/dma-mapping.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Jun 2011 21:35:03 +0800
Message-ID: <1309440903.22791.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build error:
  CC      arch/arm/mach-mxs/devices/platform-mxsfb.o
arch/arm/mach-mxs/devices/platform-mxsfb.c: In function 'mx23_add_mxsfb':
arch/arm/mach-mxs/devices/platform-mxsfb.c:27: error: implicit declaration of function 'DMA_BIT_MASK'
make[2]: *** [arch/arm/mach-mxs/devices/platform-mxsfb.o] Error 1
make[1]: *** [arch/arm/mach-mxs/devices] Error 2
make: *** [arch/arm/mach-mxs] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 arch/arm/mach-mxs/devices/platform-mxsfb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mxs/devices/platform-mxsfb.c b/arch/arm/mach-mxs/devices/platform-mxsfb.c
index bf72c9b..5a75b71 100644
--- a/arch/arm/mach-mxs/devices/platform-mxsfb.c
+++ b/arch/arm/mach-mxs/devices/platform-mxsfb.c
@@ -5,6 +5,7 @@
  * the terms of the GNU General Public License version 2 as published by the
  * Free Software Foundation.
  */
+#include <linux/dma-mapping.h>
 #include <asm/sizes.h>
 #include <mach/mx23.h>
 #include <mach/mx28.h>
-- 
1.7.4.1



