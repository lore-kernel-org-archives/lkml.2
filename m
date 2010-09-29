Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab0I2TeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 15:34:05 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51507 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab0I2TeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 15:34:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:from:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=OyWzvLAodfMgPw1/BQOQzMmrkNOaln2J4ZJXdurD6w+NWotpR0nJw8/gsFMK21RC87
         irYIh73Un1PGDMMUXYWaIupw4TowkUxgeLustWChNnONQz0byFynl3ltRMilZL7P5dp3
         blLCzD8j6aGP4s8ca6l7GZEIFpNOkG0yh2IBQ=
Subject: [PATCH 4/9] ARM: S3C64XX: add USB host support for mach-real6410
To: linux-arm-kernel@lists.infradead.org
From: Darius Augulis <augulis.darius@gmail.com>
Cc: kgene.kim@samsung.com, paulius.zaleckas@gmail.com,
        linux-kernel@vger.kernel.org, ben-linux@fluff.org
Date: Wed, 29 Sep 2010 22:34:00 +0300
Message-ID: <20100929193346.25307.75373.stgit@darius-desktop>
In-Reply-To: <20100929192354.25307.40197.stgit@darius-desktop>
References: <20100929192354.25307.40197.stgit@darius-desktop>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add USB host device support for mach-real6410

Signed-off-by: Darius Augulis <augulis.darius@gmail.com>
---
 arch/arm/mach-s3c64xx/Kconfig         |    1 +
 arch/arm/mach-s3c64xx/mach-real6410.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s3c64xx/Kconfig b/arch/arm/mach-s3c64xx/Kconfig
index b706b80..c05ae12 100644
--- a/arch/arm/mach-s3c64xx/Kconfig
+++ b/arch/arm/mach-s3c64xx/Kconfig
@@ -109,6 +109,7 @@ config MACH_REAL6410
 	select S3C_DEV_NAND
 	select SAMSUNG_DEV_ADC
 	select SAMSUNG_DEV_TS
+	select S3C_DEV_USB_HOST
 	help
 	  Machine support for the CoreWind REAL6410
 
diff --git a/arch/arm/mach-s3c64xx/mach-real6410.c b/arch/arm/mach-s3c64xx/mach-real6410.c
index bad6990..00e7d7e 100644
--- a/arch/arm/mach-s3c64xx/mach-real6410.c
+++ b/arch/arm/mach-s3c64xx/mach-real6410.c
@@ -195,6 +195,7 @@ static struct platform_device *real6410_devices[] __initdata = {
 	&s3c_device_nand,
 	&s3c_device_adc,
 	&s3c_device_ts,
+	&s3c_device_ohci,
 };
 
 static struct s3c2410_ts_mach_info s3c_ts_platform __initdata = {

