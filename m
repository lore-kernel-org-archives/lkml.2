Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309Ab1IAANr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 20:13:47 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:59984 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536Ab1IAANq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 20:13:46 -0400
Subject: [PATCH RESEND] video: nuc900fb: remove include of mach/clkdev.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wan ZongShun <mcuos.com@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Sep 2011 08:13:38 +0800
Message-ID: <1314836018.2208.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit aa3831cf9d29cfeaebd8c2169378b74111364487
"ARM: Consolidate the clkdev header files",
the header file arch/arm/mach-nuc93x/include/mach/clkdev.h is removed.

This patch fixes below build error:

drivers/video/nuc900fb.c:42:25: error: mach/clkdev.h: No such file or directory
make[2]: *** [drivers/video/nuc900fb.o] Error 1
make[1]: *** [drivers/video] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/nuc900fb.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/video/nuc900fb.c b/drivers/video/nuc900fb.c
index 0fff5978..37dd850 100644
--- a/drivers/video/nuc900fb.c
+++ b/drivers/video/nuc900fb.c
@@ -39,7 +39,6 @@
 #include <mach/regs-clock.h>
 #include <mach/regs-ldm.h>
 #include <mach/fb.h>
-#include <mach/clkdev.h>
 
 #include "nuc900fb.h"
 
-- 
1.7.4.1



