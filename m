Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab2ITMJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:09:26 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48066 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab2ITMJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:09:24 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org
Subject: [GIT PULL] MOP500 Audio patches due for ASoC
Date: Thu, 20 Sep 2012 14:09:09 +0200
Message-Id: <1348142956-1872-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 5698bd757d55b1bb87edd1a9744ab09c142abfc2:

  Linux 3.6-rc6 (2012-09-16 14:58:51 -0700)

are available in the git repository at:

  git://git.linaro.org/people/ljones/linux-3.0-ux500.git for-asoc-next

for you to fetch changes up to b4cad7af6665743647f28119b689e1552326d4da:

  Documentation: Define the MSP Driver Device Tree bindings (2012-09-20 09:10:59 +0200)

----------------------------------------------------------------
Lee Jones (7):
      ASoC: Ux500: Move MSP pinctrl setup into the MSP driver
      ASoC: Ux500: Enable MOP500 driver for Device Tree
      ASoC: Ux500: Enable ux500 MSP driver for Device Tree
      ASoC: codecs: Enable AB8500 CODEC for Device Tree
      ASoC: Ux500: Minor coding layout changes
      Documentation: Define the MOP500 Audio Machine Driver Device Tree bindings
      Documentation: Define the MSP Driver Device Tree bindings

 .../devicetree/bindings/sound/ux500-mop500.txt     |   39 +++++++++
 .../devicetree/bindings/sound/ux500-msp.txt        |   43 ++++++++++
 arch/arm/mach-ux500/board-mop500-msp.c             |   79 +----------------
 arch/arm/mach-ux500/include/mach/msp.h             |    2 -
 include/linux/mfd/abx500/ab8500-codec.h            |    6 +-
 sound/soc/codecs/ab8500-codec.c                    |   81 ++++++++++++++++++
 sound/soc/ux500/mop500.c                           |   47 +++++++++--
 sound/soc/ux500/ux500_msp_dai.c                    |    6 ++
 sound/soc/ux500/ux500_msp_i2s.c                    |   89 +++++++++++++++-----
 sound/soc/ux500/ux500_msp_i2s.h                    |    8 +-
 10 files changed, 292 insertions(+), 108 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/sound/ux500-mop500.txt
 create mode 100644 Documentation/devicetree/bindings/sound/ux500-msp.txt

