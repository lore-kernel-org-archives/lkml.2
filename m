Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab2LMB56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 20:57:58 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36216 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab2LMB54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 20:57:56 -0500
Date: Wed, 12 Dec 2012 17:57:54 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Subject: [GIT PULL 5/5] ARM: arm-soc board updates, take 2
Message-ID: <20121213015754.GE28281@quad.lixom.net>
References: <20121213015543.GA18953@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121213015543.GA18953@quad.lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This branch contains board updates for shmobile that had dependencies
on earlier branches past the first driver branch, and thus are merged
separately.

Most of these are to enable audio and USB on shmobile. They contain a
dependent ASoC branch that has been coordinated with Mark Brown.


Conflict seen with this merge:

None

----------------------------------------------------------------

The following changes since commit 370cdda68eb40e69a7a8950abec230976e5d9117:

  Merge branch 'next/drivers' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/boards2

for you to fetch changes up to d7460f4a3d75469deb1c6c028961da69608d02d9:

  Merge branch 'boards3' of git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas into next/boards2

----------------------------------------------------------------

Arnd Bergmann (3):
      Merge branches 'depends/asoc', 'renesas/boards' and 'renesas/soc' into next/boards2
      Merge branches 'depends/asoc', 'renesas/boards', 'renesas/soc' and 'renesas/soc2' into next/boards2
      Merge branch 'boards' of git://git.kernel.org/.../horms/renesas into next/boards2

Bastian Hecht (1):
      ARM: shmobile: mackerel: Add FLCTL IRQ resource

Kuninori Morimoto (12):
      ASoC: fsi: fixup channels_min/max
      ASoC: fsi: use devm_request_irq()
      ASoC: fsi: fsi_set_master_clk() was called from fsi_hw_xxx() only
      ASoC: fsi: care fsi_hw_start/stop() return value
      ASoC: fsi: add master clock control functions
      ARM: shmobile: marzen: add USB phy support
      ARM: shmobile: marzen: add USB EHCI driver support
      ARM: shmobile: marzen: add USB OHCI driver support
      ARM: shmobile: mackerel: enable DMAEngine on USB Host
      ARM: shmobile: use FSI driver's audio clock on armadillo800eva
      ARM: shmobile: use FSI driver's audio clock on mackerel
      ARM: shmobile: use FSI driver's audio clock on ap4evb

Olof Johansson (1):
      Merge branch 'boards3' of git://git.kernel.org/.../horms/renesas into next/boards2

Simon Horman (1):
      Merge branch 'soc' into boards


 arch/arm/configs/marzen_defconfig              |  14 +-
 arch/arm/mach-shmobile/Kconfig                 |   2 +
 arch/arm/mach-shmobile/board-ap4evb.c          | 139 +-----
 arch/arm/mach-shmobile/board-armadillo800eva.c |  38 +-
 arch/arm/mach-shmobile/board-mackerel.c        |  80 +---
 arch/arm/mach-shmobile/board-marzen.c          | 186 ++++++++-
 include/sound/sh_fsi.h                         |   6 +
 sound/soc/sh/fsi.c                             | 441 ++++++++++++++++++--
 8 files changed, 617 insertions(+), 289 deletions(-)
