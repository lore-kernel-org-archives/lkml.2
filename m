Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab1JBUcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 16:32:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49777 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab1JBUcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 16:32:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 3/6] ASoC: imx: eukrea_tlv320 needs i2c
Date: Sun,  2 Oct 2011 22:28:01 +0200
Message-Id: <1317587284-2776-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317587284-2776-1-git-send-email-arnd@arndb.de>
References: <1317587284-2776-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:LuRBzmsz0vofjuNY0QS8DkJspYP2Qe40CBEaHsQIK7w
 adI2ETagwP7DxTdIN1DwaaNvgaB3QYaIw3M7Fz0WMkwIKNY/vw
 ZURMEENWuNhLTqfjScmJ350D8ozo367hQuD9O78qWX9Rnk61LN
 UbVf5C9p0hGxxaJsVbIQ1zzsCjCbaLtBPMWK8fR2x015WvIyQW
 9Mqw2m34++pj9HstHn5xN0Zs6dO329LkABYhs7/vrgqNo4BHoJ
 936K523UVV6YkgH8ZVAnCZPIiRqCLUIWV9hZ0Nnu87fuke2qsD
 7LmMPnB8EQ+rEA+zQb2tbP3o7ik4WjmW6Xae/DnIqJTQj7eEff
 4ryn5ZNF+p54ukvFVP5luN3RouBtvXYrOzVsRH/6a36Aoux/Of
 1EWkzt2Te2r7w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a missing dependency that is required for random configurations.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: "Eric Bénard" <eric@eukrea.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
---
 sound/soc/imx/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/imx/Kconfig b/sound/soc/imx/Kconfig
index bb699bb..dcd954b 100644
--- a/sound/soc/imx/Kconfig
+++ b/sound/soc/imx/Kconfig
@@ -50,6 +50,7 @@ config SND_SOC_EUKREA_TLV320
 		|| MACH_EUKREA_MBIMXSD25_BASEBOARD \
 		|| MACH_EUKREA_MBIMXSD35_BASEBOARD \
 		|| MACH_EUKREA_MBIMXSD51_BASEBOARD
+	depends on I2C
 	select SND_SOC_TLV320AIC23
 	select SND_MXC_SOC_FIQ
 	help
-- 
1.7.5.4

