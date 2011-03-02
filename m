Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab1CBNYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 08:24:44 -0500
Received: from smtp.nokia.com ([147.243.1.47]:57379 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135Ab1CBNYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 08:24:41 -0500
From: Ilkka Koskinen <ilkka.koskinen@nokia.com>
To: peter.ujfalusi@nokia.com, tony@atomide.com, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 0/2] twl4030_codec cleanup
Date: Wed,  2 Mar 2011 15:24:04 +0200
Message-Id: <1299072246-26402-1-git-send-email-ilkka.koskinen@nokia.com>
X-Mailer: git-send-email 1.7.0.4
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches removes duplicate audio_mclk fields from
twl4030_codec driver.

The patches have been compiled on sound-2.6/for-2.6.39 branch.
I haven't tested them on any target board though.

Ilkka Koskinen (2):
  omap: Remove unnecessary twl4030_codec_audio settings from board
    files
  mfd: twl4030_codec: Remove unused and duplicate audio_mclk fields

 arch/arm/mach-omap2/board-3430sdp.c          |    4 +---
 arch/arm/mach-omap2/board-devkit8000.c       |    4 +---
 arch/arm/mach-omap2/board-igep0020.c         |    4 +---
 arch/arm/mach-omap2/board-omap3beagle.c      |    4 +---
 arch/arm/mach-omap2/board-omap3evm.c         |    4 +---
 arch/arm/mach-omap2/board-omap3pandora.c     |    4 +---
 arch/arm/mach-omap2/board-omap3stalker.c     |    4 +---
 arch/arm/mach-omap2/board-omap3touchbook.c   |    4 +---
 arch/arm/mach-omap2/board-overo.c            |    4 +---
 arch/arm/mach-omap2/board-zoom-peripherals.c |    4 +---
 include/linux/i2c/twl.h                      |    2 --
 11 files changed, 10 insertions(+), 32 deletions(-)

