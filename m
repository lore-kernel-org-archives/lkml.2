Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab2JWGRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 02:17:17 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:58963 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab2JWGRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 02:17:15 -0400
From: Kelvin Cheung <keguang.zhang@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org
Cc: mturquette@linaro.org, Kelvin Cheung <keguang.zhang@gmail.com>
Subject: [PATCH 0/4] MIPS: Loongson1B: enable common clock infrastructure
Date: Tue, 23 Oct 2012 14:16:59 +0800
Message-Id: <1350973023-7667-1-git-send-email-keguang.zhang@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches enable common clock infrastructure of Loongson1, and
include other minor fixes.

Kelvin Cheung (4):
  MIPS: Loongson1B: use common clock infrastructure instead of    
    private APIs
  MIPS: Loongson1B: improve ls1x_serial_setup()
  MIPS: Loongson1B: Update stmmac_mdio_bus_data
  MIPS: Loongson1B: Fix a typo

 arch/mips/include/asm/mach-loongson1/platform.h |    3 +-
 arch/mips/include/asm/mach-loongson1/regs-clk.h |    7 +-
 arch/mips/loongson1/Kconfig                     |    2 +-
 arch/mips/loongson1/common/clock.c              |  159 +----------------------
 arch/mips/loongson1/common/platform.c           |   10 +-
 arch/mips/loongson1/ls1b/board.c                |    5 +-
 6 files changed, 16 insertions(+), 170 deletions(-)

