Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540Ab2G0MqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 08:46:11 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63195 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab2G0MqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 08:46:09 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com
Subject: [PATCH 00/18] Configure ux500 Audio Drivers for Device Tree 
Date: Fri, 27 Jul 2012 13:45:44 +0100
Message-Id: <1343393162-11938-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set sees many of the ux500 related Audio drivers gain
Device Tree enablement. There are also some fixes to issues which
where encountered along the way. 

 Documentation/devicetree/bindings/sound/ux500.txt |   62 +++++
 arch/arm/boot/dts/db8500.dtsi                     |   48 ++++
 arch/arm/mach-ux500/Kconfig                       |    1 +
 arch/arm/mach-ux500/Makefile                      |    2 +-
 arch/arm/mach-ux500/board-mop500-audio.c          |  194 +++++++++++++++
 arch/arm/mach-ux500/board-mop500-msp.c            |  267 ---------------------
 arch/arm/mach-ux500/board-mop500-msp.h            |   14 --
 arch/arm/mach-ux500/board-mop500.c                |   22 +-
 arch/arm/mach-ux500/board-mop500.h                |    6 +
 arch/arm/mach-ux500/include/mach/msp.h            |    3 +-
 include/linux/mfd/abx500/ab8500-codec.h           |    6 +-
 sound/soc/codecs/ab8500-codec.c                   |   81 +++++++
 sound/soc/ux500/mop500.c                          |   41 ++++
 sound/soc/ux500/ux500_msp_dai.c                   |    6 +
 sound/soc/ux500/ux500_msp_i2s.c                   |  114 +++++++--
 sound/soc/ux500/ux500_msp_i2s.h                   |    3 +-
 sound/soc/ux500/ux500_pcm.c                       |    6 +
 17 files changed, 561 insertions(+), 315 deletions(-)

