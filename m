Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055Ab2JSVtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 17:49:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52411 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932972Ab2JSVtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 17:49:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: [GIT PULL v3] ARM architecture fixes for 3.7
Date: Fri, 19 Oct 2012 21:49:34 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210192149.34864.arnd@arndb.de>
X-Provags-ID: V02:K0:1F7NVQ3YeZf1VPx0LIH1y6hKpVyDIfDi4+KBrSEWh2v
 N7PU8bM9IIbFn4m35NSubEq2UIe3g/m+3XPyr0bpPEztVbUHKN
 NYto8a723IcPWjVprto3noLjSxCx8tSrwwy40mlg8mjHF4ZTkX
 yahRyCNCSWjo2v1dK3JPaz4kvcWwFV7N1roFA/CqwJeSPiYfLI
 TquIrzRPm5czem8WYxxDD3+EIspWisasXyHwRd8mJU1c+YUPXx
 gANiDZ/jUqHbbU+9qprOXWs9dFbkHFJDpYFnFu9HZS0pzDTJ7/
 jk2faGR+7fCx4EMRhmtLDXGm7VJw2DFIVN3UxRskaQhXBHV7Cf
 c/AVLaXMjS26r5Yd/uKs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

you never replied to the second version of the pull request, and it hasn't
shown up in linux-next or your git tree so far. I assume you've been busy
otherwise and missed it, so here is a friendly reminder.

The contents are still identical to what we had before after I fixed up
the changeset comment for the Xen patch.

	Arnd

---
The following changes since commit 0e51793e162ca432fc5f04178cf82b80a92c2659:

  Merge branch 'for-linus' of git://git.linaro.org/people/rmk/linux-arm (2012-10-07 21:20:57 +0900)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-rmk

for you to fetch changes up to 8e7fc18b5eacc37b6e6fcf486ec4eafbfef91738:

  ARM: warnings in arch/arm/include/asm/uaccess.h (2012-10-09 20:29:07 +0200)

----------------------------------------------------------------
These bug fixes all address problems found with automated build testing.
Some of them have been around for a long time, other bugs are
regressions since the merge window.

----------------------------------------------------------------
Arnd Bergmann (9):
      ARM: kprobes: make more tests conditional
      ARM: export set_irq_flags
      ARM: Fix another build warning in arch/arm/mm/alignment.c
      ARM: export default read_current_timer
      ARM: Xen: fix initial build problems
      ARM: pass -marm to gcc by default for both C and assembler
      ARM: be really quiet when building with 'make -s'
      ARM: binfmt_flat: unused variable 'persistent'
      ARM: warnings in arch/arm/include/asm/uaccess.h

 arch/arm/Kconfig                   |    1 +
 arch/arm/Makefile                  |   13 +++++++------
 arch/arm/boot/Makefile             |   10 +++++-----
 arch/arm/include/asm/flat.h        |    2 +-
 arch/arm/include/asm/uaccess.h     |    4 ++--
 arch/arm/kernel/irq.c              |    2 ++
 arch/arm/kernel/kprobes-test-arm.c |    4 ++++
 arch/arm/lib/delay.c               |    1 +
 arch/arm/mm/alignment.c            |    4 +++-
 arch/arm/tools/Makefile            |    2 +-
 drivers/xen/Kconfig                |    2 ++
 drivers/xen/sys-hypervisor.c       |    1 +
 12 files changed, 30 insertions(+), 16 deletions(-)
