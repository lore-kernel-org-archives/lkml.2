Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab2HBRpQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 13:45:16 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:45124 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab2HBRpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 13:45:12 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
Date: Thu, 2 Aug 2012 10:45:11 -0700
Message-ID: <CAOesGMiBPVtYwMN2o-e_vBC_XOdgjuDfrBs-ftAByvfdCsrB3w@mail.gmail.com>
Subject: [GIT PULL 1/3] ARM: SoC fixes
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few fixes for merge window fallout, and a bugfix for timer resume
on PRIMA2.

----------------------------------------------------------------

The following changes since commit 1a9b4993b70fb1884716902774dc9025b457760d:

  Merge branch 'upstream' of
git://git.linux-mips.org/pub/scm/ralf/upstream-linus

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git
tags/fixes-for-linus

for you to fetch changes up to bac6f61550043195ee59e9cef0db67af23baf11e:

  ARM: mmp: add missing irqs.h

----------------------------------------------------------------

Barry Song (1):
      ARM: PRIMA2: delete redundant codes to restore LATCHED when timer resumes

Fabio Estevam (1):
      ARM: mxc: Include missing irqs.h header

Haojian Zhuang (1):
      ARM: mmp: add missing irqs.h

Thomas Petazzoni (1):
      arm: mvebu: fix typo in .dtsi comment for Armada XP SoCs


 arch/arm/boot/dts/armada-xp.dtsi | 2 +-
 arch/arm/mach-mmp/gplugd.c       | 1 +
 arch/arm/mach-prima2/timer.c     | 6 +++---
 arch/arm/plat-mxc/tzic.c         | 1 +
 4 files changed, 6 insertions(+), 4 deletions(-)
