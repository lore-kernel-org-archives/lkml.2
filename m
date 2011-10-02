Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab1JBU3G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 16:29:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55058 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab1JBU3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 16:29:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Dmitry Artamonow <mad_soft@inbox.ru>
Subject: [PATCH 2/6] ASoC: codecs: AK4641 depends on GPIOLIB
Date: Sun,  2 Oct 2011 22:28:00 +0200
Message-Id: <1317587284-2776-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317587284-2776-1-git-send-email-arnd@arndb.de>
References: <1317587284-2776-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Vhf8zuRsXimmkvXfHaeXZUY40K97dcjP0bzhglANhkL
 eCOe10BtBTDkfoHebj05W8cnj6aZfFnsF6uyILPNkMyvRtuJc1
 1rUdggS9JoLxvopDDCT1pAzrCgm59mtimrCwwj6bWn/qQWMoY5
 Ip63C1A4qKBD3JuxPkb3Y2i3LTB0miKPRdS0PAYH6Wz1jg8pXj
 7cqgnaBlgtiSq/iqUQKWWhFquChD4fB2SK7NKqoZvgmJ9y8F32
 WFZUfISPwqL0NA9IBq2Eq3GTdUhVKtSmT+S0ssQJ7ZCpjJYUfT
 tx9rMC2F5KIpSO8v0zAhwVvCrIbdsvumIh1KH/cVm69XjUZjXV
 zLeeIsJgUQ14DjisbulJAhYfoaV9ZGI/tFNFhPwaNjbABd6Mwm
 i5vDWSl5rWyNw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver only builds correctly on platforms that use
GPIOLIB. Disable it otherwise.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitry Artamonow <mad_soft@inbox.ru>
---
 sound/soc/codecs/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 665d924..4d41447 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -21,7 +21,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_ADS117X
 	select SND_SOC_AK4104 if SPI_MASTER
 	select SND_SOC_AK4535 if I2C
-	select SND_SOC_AK4641 if I2C
+	select SND_SOC_AK4641 if I2C && GPIOLIB
 	select SND_SOC_AK4642 if I2C
 	select SND_SOC_AK4671 if I2C
 	select SND_SOC_ALC5623 if I2C
-- 
1.7.5.4

