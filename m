Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab0HRApg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 20:45:36 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:58605 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab0HRApa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 20:45:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=g5cgD7h0rqijhxE1tuwfdGGhOzT1Dc4qSVl059YUONsR5Dqshk+Zfx+jgq7TMPvrEu
         f9kdmRCgqJHJyPxrEG/kX1XpBkjjEGJbDGoyRZfaMn2YQ09CGW2aAnqCse1xon8jQZc4
         j9BnztBd1B5alAkvjwCX7noq5QS+d9W+D8R+M=
MIME-Version: 1.0
Date: Tue, 17 Aug 2010 17:45:28 -0700
Message-ID: <AANLkTinmWzTBPEsicB-AWv9-=mA8HE2qqEoYqhbV39t8@mail.gmail.com>
Subject: [PATCH] watchdog: Enable NXP LPC32XX support in Kconfig (resend)
From: Kevin Wells <wellsk40@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vitaly Wool <vitalywool@gmail.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NXP LPC32XX processor use the same watchdog as the Philips
PNX4008 processor.

Signed-off-by: Kevin Wells <wellsk40@gmail.com>
Tested-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/watchdog/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index b04b184..c442b2a 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -206,11 +206,11 @@ config OMAP_WATCHDOG
         here to enable the OMAP1610/OMAP1710/OMAP2420/OMAP3430/OMAP4430
watchdog timer.

 config PNX4008_WATCHDOG
-       tristate "PNX4008 Watchdog"
-       depends on ARCH_PNX4008
+       tristate "PNX4008 and LPC32XX Watchdog"
+       depends on ARCH_PNX4008 || ARCH_LPC32XX
       help
         Say Y here if to include support for the watchdog timer
-         in the PNX4008 processor.
+         in the PNX4008 or LPC32XX processors.
         This driver can be built as a module by choosing M. The module
         will be called pnx4008_wdt.

--
1.7.1.1
