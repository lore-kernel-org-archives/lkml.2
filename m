Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab1JBU32 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 16:29:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60744 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab1JBU3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 16:29:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/6] ASoC fixes from ARM randconfig builds
Date: Sun,  2 Oct 2011 22:27:58 +0200
Message-Id: <1317587284-2776-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:Ph4TI7rhmJV4jejP7mdcyo3E1pi+3kKHcH6L4aSoceZ
 HqYev5gCPNuwj18Nekd9onGuHYdz4RazdEeJ/eeTw0qQs1pnu2
 38eFqRhu9H0tMW9wJcP2kE0pFN1tHFnOS5ES2EpeJmvvPNoE6w
 +pM6SHeNqYggZzksT7ZEJWPjRuor4xToSQfFzLBLQW8b0K1v16
 fWoUbqa3X+W6plm4QVJAlD8cm9FGPm+PWFFBpOQmQutJx0ekIo
 5tZja4CnQaCOPZINQiDOvCgIiIU8RmUTNKryvEL7Sk/vjVrAVM
 bjSxvIGm+vkMEN/p2HmyAdt9Q6lCI7Xo4bTZ1wv6AcSJDuwVRA
 N5B6Vjs4mu2TLmr2wYNQZ5IxfP13TQr9A/8Rwi3fHLilsAu+o2
 NbsP3PsWtC0Pw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

As promised, here are the remaining ASoC patches from my
randconfig series. I hope I managed to get the submission
right this time. I've left out the ones that you already
took or NAKed, so this is shorter than I expected.

	Arnd

Arnd Bergmann (6):
  ASoC: codecs/wm8682: use __devexit_p
  ASoC: codecs: AK4641 depends on GPIOLIB
  ASoC: imx: eukrea_tlv320 needs i2c
  ASoC: sh: use correct __iomem annotations
  ASoC: samsung: fix Kconfig dependencies
  ASoC: samsung: add missing __devexit_p() annotations

 sound/soc/codecs/Kconfig  |    2 +-
 sound/soc/codecs/wm8782.c |    2 +-
 sound/soc/imx/Kconfig     |    1 +
 sound/soc/samsung/Kconfig |    4 ++++
 sound/soc/samsung/ac97.c  |    2 +-
 sound/soc/samsung/i2s.c   |    2 +-
 sound/soc/sh/fsi.c        |   10 +++++-----
 7 files changed, 14 insertions(+), 9 deletions(-)

-- 
1.7.5.4

