Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab1DFNCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 09:02:04 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48445 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab1DFNB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 09:01:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Ea3lnQm8HKY31CNwJKlAobJexB1mbzwCWkHBm4Ct3bJFH7tgbwmhuhAKgTzTKEGli4
         lrxzXF21caOUlZOuuqUuIkvvd8gCKWXTySME/AifwNThH8gPl2BabXu0p1ctpO+wpB51
         jtw/7zfxX5ctpXJ0UkbuJoYi8/Rz04GInyLAk=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: ben-linux@fluff.org
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, esta1ien@gmail.com, buserror@gmail.com,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 3/4] s3c2440: mini2440: Select touchscreen by default.
Date: Wed,  6 Apr 2011 15:01:36 +0200
Message-Id: <1302094897-18446-4-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302094897-18446-1-git-send-email-marek.belisko@open-nandra.com>
References: <1302094897-18446-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 arch/arm/mach-s3c2440/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s3c2440/Kconfig b/arch/arm/mach-s3c2440/Kconfig
index 50825a3..e713eea 100644
--- a/arch/arm/mach-s3c2440/Kconfig
+++ b/arch/arm/mach-s3c2440/Kconfig
@@ -186,6 +186,7 @@ config MACH_MINI2440
 	select LEDS_TRIGGER_BACKLIGHT
 	select S3C_DEV_NAND
 	select S3C_DEV_USB_HOST
+	select TOUCHSCREEN_S3C2410
 	help
 	  Say Y here to select support for the MINI2440. Is a 10cm x 10cm board
 	  available via various sources. It can come with a 3.5" or 7" touch LCD.
-- 
1.7.1

