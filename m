Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255Ab2EIQ3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:29:18 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53038 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758285Ab2EIQ2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:28:44 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
Date: Wed, 9 May 2012 09:28:43 -0700
Message-ID: <CAOesGMheimXMjB=-+9WNXc8Wu2nStfF3=6C3tMENTJybhn96ng@mail.gmail.com>
Subject: [GIT PULL] ARM: SoC fixes for 3.4
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d48b97b403d23f6df0b990cee652bdf9a52337a3:

  Linux 3.4-rc6 (2012-05-06 15:07:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git
tags/fixes-for-linus

for you to fetch changes up to e396dbd4ed2ccfd362261b05027bbdccec192b14:

  Merge tag 'omap-fixes-for-v3.4-rc6-take-2' of
git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap into
fixes (2012-05-09 09:03:34 -0700)

----------------------------------------------------------------

ARM: SoC fixes for 3.4-rc

Things have slowed down a lot for us, but we have five more fixes for
omap and kirkwood below. Three are for boards setup issues, two are
SoC-level fixes.

----------------------------------------------------------------
Archit Taneja (1):
      ARM: OMAP: Revert "ARM: OMAP: ctrl: Fix CONTROL_DSIPHY register fields"

Ben Hutchings (1):
      ARM: orion5x: Fix GPIO enable bits for MPP9

Enrico Butera (1):
      ARM: OMAP: igep0020: fix smsc911x dummy regulator id

Ian Campbell (1):
      ARM: kirkwood: add missing kexec.h include

Janusz Krzysztofik (1):
      ARM: OMAP1: Amstrad Delta: Fix wrong IRQ base in FIQ handler

Olof Johansson (2):
      Merge branch 'kirkwood_fixes_for_v3.4' of
git://git.infradead.org/users/jcooper/linux-kirkwood into fixes
      Merge tag 'omap-fixes-for-v3.4-rc6-take-2' of
git://git.kernel.org/.../tmlind/linux-omap into fixes

 arch/arm/mach-kirkwood/board-dt.c                            | 1 +
 arch/arm/mach-omap1/ams-delta-fiq.c                          | 2 +-
 arch/arm/mach-omap2/board-igep0020.c                         | 2 +-
 arch/arm/mach-omap2/include/mach/ctrl_module_pad_core_44xx.h | 8 ++++----
 arch/arm/mach-orion5x/mpp.h                                  | 4 ++--
 5 files changed, 9 insertions(+), 8 deletions(-)
