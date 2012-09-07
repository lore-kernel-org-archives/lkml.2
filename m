Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028Ab2IGLPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 07:15:20 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42854 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab2IGLPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 07:15:16 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: [PATCH 00/19] First HREF Device Tree enablement patch-set
Date: Fri,  7 Sep 2012 12:14:40 +0100
Message-Id: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on v3.6-rc4

This patch consists of Device Tree related enablement for
ST-Ericsson's development HREF hardware reference board.
Most devices are very similar, if not the same to the
previously enabled Snowball low-cost development board.
These are referenced from the relevant .dtsi file and
merely enabled in the HREF specific Device Tree. There 
are also one or two minor Device Tree related fixes which
were stumbled upon along the way.

 arch/arm/boot/dts/hrefv60plus.dts      |  140 ++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/snowball.dts         |    1 -
 arch/arm/mach-ux500/board-mop500-sdi.c |    4 +-
 arch/arm/mach-ux500/board-mop500.c     |   12 +--
 arch/arm/mach-ux500/board-mop500.h     |    2 +
 drivers/gpio/gpio-tc3589x.c            |  120 +++++++++++++++++++--------
 drivers/i2c/busses/i2c-nomadik.c       |    4 +
 drivers/mfd/mfd-core.c                 |   10 ++-
 drivers/mfd/tc3589x.c                  |  112 +++++++++++++++++++------
 include/linux/mfd/tc3589x.h            |    1 +
 10 files changed, 327 insertions(+), 79 deletions(-)

