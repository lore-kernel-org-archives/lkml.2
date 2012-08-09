Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031219Ab2HIPsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:48:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49027 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030969Ab2HIPsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:48:09 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com
Subject: [PATCH 00/22] mop500 related Audio reorganisation and fixups
Date: Thu,  9 Aug 2012 16:47:26 +0100
Message-Id: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another fine instalment of Audio fixes and Device Tree enablement
surrounding the mop500 sound driver. Hopefully containing all of 
the recommendations suggested by Mark Brown.

 Documentation/devicetree/bindings/mfd/ab8500.txt   |   15 +
 .../devicetree/bindings/sound/ux500-mop500.txt     |   39 ++
 .../devicetree/bindings/sound/ux500-msp.txt        |   43 ++
 arch/arm/boot/dts/db8500.dtsi                      |  627 ------------------
 arch/arm/boot/dts/dbx5x0.dtsi                      |  666 ++++++++++++++++++++
 arch/arm/boot/dts/snowball.dts                     |   18 +-
 arch/arm/mach-ux500/Makefile                       |    2 +-
 arch/arm/mach-ux500/board-mop500-audio.c           |  189 ++++++
 arch/arm/mach-ux500/board-mop500-msp.c             |  267 --------
 arch/arm/mach-ux500/board-mop500-msp.h             |   14 -
 arch/arm/mach-ux500/board-mop500.c                 |   18 +-
 arch/arm/mach-ux500/board-mop500.h                 |    6 +
 arch/arm/mach-ux500/include/mach/msp.h             |    2 -
 include/linux/mfd/abx500/ab8500-codec.h            |    6 +-
 sound/soc/codecs/ab8500-codec.c                    |   85 +++
 sound/soc/ux500/mop500.c                           |   44 +-
 sound/soc/ux500/ux500_msp_dai.c                    |   20 +-
 sound/soc/ux500/ux500_msp_i2s.c                    |   97 ++-
 sound/soc/ux500/ux500_msp_i2s.h                    |    2 -
 sound/soc/ux500/ux500_pcm.c                        |   19 +-
 sound/soc/ux500/ux500_pcm.h                        |    3 +
 21 files changed, 1225 insertions(+), 957 deletions(-)

