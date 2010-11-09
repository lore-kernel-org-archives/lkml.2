Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab0KINUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 08:20:40 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63166 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab0KINUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 08:20:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VNnDMOK1sRL3niKaA6wA98U842s3cDWzv7iRwg4O5qQbdTQqfFfIQ1R6toDDi0KzVk
         X1cx7yhxIFUh/1xtZbW6UE4BnL7RUcV8BLu+8Hi4b86fUagkC46rCpWyej+c61bdtrNE
         zG5xPqL4mwqM8Di7SU5giXev1pfYt3C+4RwsU=
From: Marek Belisko <marek.belisko@gmail.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: s3c2440: mini2440: Add selection of touchscreen.
Date: Tue,  9 Nov 2010 14:22:47 +0100
Message-Id: <1289308967-14520-1-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add selection of touchscreen driver by default
when use mini2440 board.

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 arch/arm/mach-s3c2440/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s3c2440/Kconfig b/arch/arm/mach-s3c2440/Kconfig
index ff024a6..d4a33fb 100644
--- a/arch/arm/mach-s3c2440/Kconfig
+++ b/arch/arm/mach-s3c2440/Kconfig
@@ -181,6 +181,7 @@ config MACH_MINI2440
 	select LEDS_TRIGGER_BACKLIGHT
 	select S3C_DEV_NAND
 	select S3C_DEV_USB_HOST
+	select TOUCHSCREEN_S3C2410
 	help
 	  Say Y here to select support for the MINI2440. Is a 10cm x 10cm board
 	  available via various sources. It can come with a 3.5" or 7" touch LCD.
-- 
1.7.1

