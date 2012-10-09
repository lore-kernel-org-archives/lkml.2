Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab2JIPYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:24:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50610 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab2JIPYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:24:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        <arnd@arndb.de>, bryan.wu@canonical.com, catalin.marinas@arm.com,
        dave.martin@linaro.org, jeremy@goop.org, jonathan.austin@arm.com,
        konrad.wilk@oracle.com, leif.lindholm@arm.com,
        linus.walleij@linaro.org, damm@opensource.se, mmarek@suse.cz,
        rjw@sisk.pl, stefano.stabellini@eu.citrix.com, sboyd@codeaurora.org,
        tglx@linutronix.de, will.deacon@arm.com, xen-devel@lists.xensource.com
Subject: [GIT PULL 0/9] ARM architecture fixes for 3.7
Date: Tue,  9 Oct 2012 17:22:54 +0200
Message-Id: <1349796183-30648-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
X-Provags-ID: V02:K0:yDMisN99TU4omIRjUsuBeYvP0ndX8ZwpmCJoiA1Icfb
 s6WI3MDb1Oma4n4DC2WHiHX27dk9zISJUPesd649uL9K0NZs9g
 VNy8ymUAIDGpIQVTGyiqpX7fpyAYXfxUBpUJa86jV1uz9ZsVqr
 cIw1FdzWOm7yu7W6DlIH+CBwT6e40ajLABdif3C9gnljBGWycz
 vqz4paDR3JWWnDm0hui6oCxD7w+ALiIbglDFaa8YRfyXdIWkQa
 l1ibAnENHmwmBw+DpQe7TL2Hc4I8p7fXUizhQCecDXK+S2BaLS
 8TyiKrvFvEM7QvllO30lB6ZpKM5xRcmSf6mFNeO/GlX9yNvUes
 gtQJNPOnhN6Q9JoA7kGDSURBRoRdx7SUvdhGOoGLjKzM5Eqmll
 cnghweeL4359x6wzTzH9kwlOVaTwqRd7zk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <arnd@arndb.de>

Hi Russell,

Here are some patches that belong into your domain, I hope you can
just send the lot to Linus the next time you send other patches.

These bug fixes all address problems found with automated build testing.
Some of them have been around for a long time, other bugs are
regressions since the merge window.

	Arnd

The following changes since commit 0e51793e162ca432fc5f04178cf82b80a92c2659:

  Merge branch 'for-linus' of git://git.linaro.org/people/rmk/linux-arm (2012-10-07 21:20:57 +0900)

are available in the git repository at:

 git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-rmk

for you to fetch changes up to 93c6cee8e966ceb78a08e6a69a3afc948b74d254:

  ARM: warnings in arch/arm/include/asm/uaccess.h (2012-10-09 17:07:44 +0200)

----------------------------------------------------------------
Arnd Bergmann (9):
      ARM: kprobes: make more tests conditional
      ARM: export set_irq_flags
      ARM: Fix another build warning in arch/arm/mm/alignment.c
      ARM: export default read_current_timer
      ARM: Xen: fix initial build problems:
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

Cc: bryan.wu@canonical.com
Cc: catalin.marinas@arm.com
Cc: dave.martin@linaro.org
Cc: jeremy@goop.org
Cc: jonathan.austin@arm.com
Cc: konrad.wilk@oracle.com
Cc: leif.lindholm@arm.com
Cc: linus.walleij@linaro.org
Cc: damm@opensource.se
Cc: mmarek@suse.cz
Cc: rjw@sisk.pl
Cc: rmk+kernel@arm.linux.org.uk
Cc: stefano.stabellini@eu.citrix.com
Cc: sboyd@codeaurora.org
Cc: tglx@linutronix.de
Cc: will.deacon@arm.com
Cc: xen-devel@lists.xensource.com
