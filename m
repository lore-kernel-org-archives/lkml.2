Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab2GaOqD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:46:03 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38049 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347Ab2GaOqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:46:01 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com
Subject: [PATCH 0/6] Bugfixes and clean-ups bound for the v3.6 RCs
Date: Tue, 31 Jul 2012 15:45:39 +0100
Message-Id: <1343745944-18418-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set includes some important changes which should make
their way to the Mainline Release Candidates for the v3.6 release.
Without them Audio doesn't even probe (at all) when booting with
Device Tree selected. The kernel can't compile with ux500 audio
enabled. Even if we can get that far SoC Core will assume we're
using regmaps and attempt to use them; however, none exist for
this driver, so the kernel will oops.

 arch/arm/mach-ux500/board-mop500-msp.c |    2 +-
 arch/arm/mach-ux500/board-mop500.c     |    9 ++++-----
 sound/soc/codecs/ab8500-codec.c        |    4 ++++
 sound/soc/soc-dapm.c                   |    2 --
 4 files changed, 9 insertions(+), 8 deletions(-)

