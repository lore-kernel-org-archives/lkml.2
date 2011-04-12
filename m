Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab1DLUvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:51:07 -0400
Received: from smtp-out-051.synserver.de ([212.40.185.51]:1063 "HELO
	smtp-out-049.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S932396Ab1DLUvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:51:04 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 28580
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Lars-Peter Clausen <lars@metafoo.de>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH] ARM: s3c2440: gta02; Register dfbmcs320 device
Date: Tue, 12 Apr 2011 22:51:04 +0200
Message-Id: <1302641464-27494-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register the dfbmcs320 device which provides the PCM DAI for the bluetooth
module.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---
 arch/arm/mach-s3c2440/mach-gta02.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s3c2440/mach-gta02.c b/arch/arm/mach-s3c2440/mach-gta02.c
index 0db2411..7166620 100644
--- a/arch/arm/mach-s3c2440/mach-gta02.c
+++ b/arch/arm/mach-s3c2440/mach-gta02.c
@@ -409,6 +409,10 @@ struct platform_device s3c24xx_pwm_device = {
 	.num_resources	= 0,
 };
 
+static struct platform_device gta02_dfbmcs320_device = {
+	.name = "dfbmcs320",
+};
+
 static struct i2c_board_info gta02_i2c_devs[] __initdata = {
 	{
 		I2C_BOARD_INFO("pcf50633", 0x73),
@@ -523,6 +527,7 @@ static struct platform_device *gta02_devices[] __initdata = {
 	&s3c_device_iis,
 	&samsung_asoc_dma,
 	&s3c_device_i2c0,
+	&gta02_dfbmcs320_device,
 	&gta02_buttons_device,
 	&s3c_device_adc,
 	&s3c_device_ts,
-- 
1.7.2.5

