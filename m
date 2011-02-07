Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab1BGBuk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 20:50:40 -0500
Received: from smtp-out-016.synserver.de ([212.40.185.16]:1041 "HELO
	smtp-out-016.synserver.de" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1754206Ab1BGBug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 20:50:36 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 23313
From: Lars-Peter Clausen <lars@metafoo.de>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 02/09] ARM: s3c2440: gta02: Register PCM device
Date: Mon,  7 Feb 2011 02:51:54 +0100
Message-Id: <1297043521-21903-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297043521-21903-1-git-send-email-lars@metafoo.de>
References: <1297043521-21903-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ASoC multi-component patch introduced a new pcm platform device, which needs
to be registered by board files in order for sound to work.
This patch does this for the gta02 board.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 arch/arm/mach-s3c2440/mach-gta02.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s3c2440/mach-gta02.c b/arch/arm/mach-s3c2440/mach-gta02.c
index 9f2c14e..e83062b 100644
--- a/arch/arm/mach-s3c2440/mach-gta02.c
+++ b/arch/arm/mach-s3c2440/mach-gta02.c
@@ -509,6 +509,7 @@ static struct platform_device *gta02_devices[] __initdata = {
 	&gta02_nor_flash,
 	&s3c24xx_pwm_device,
 	&s3c_device_iis,
+	&samsung_asoc_dma,
 	&s3c_device_i2c0,
 };
 
-- 
1.7.2.3

