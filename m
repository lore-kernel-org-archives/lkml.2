Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933946Ab1KCQMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 12:12:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38535 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933739Ab1KCQMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 12:12:01 -0400
Date: Thu, 3 Nov 2011 17:12:00 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: pebolle@tiscali.nl, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] tree-wide kconfig cleanup
Message-ID: <20111103161200.GA8303@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Paul Bolle went through our Kconfig files and deleted a lot of bitrot.
You will get a conflict in the stmmac Kconfig, but the symbol is still
unused and should be deleted. Also, the sh fix got merged twice, I
didn't notice when I applied it to my tree.

Michal

The following changes since commit 322a8b034003c0d46d39af85bf24fee27b902f48:

  Linux 3.1-rc1 (2011-08-07 18:23:30 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild.git trivial

Paul Bolle (16):
      alpha: drop unused Kconfig symbol
      sparc: drop unused Kconfig symbol
      um: drop unused Kconfig symbol
      sh: drop unused Kconfig symbol
      score: drop unused Kconfig symbols
      m32r: drop unused Kconfig symbol
      samples: drop unused Kconfig symbol
      arm: at91: drop unused Kconfig symbol
      openrisc: drop unused Kconfig symbols
      mips: drop unused Kconfig symbols
      powerpc: 40x: drop unused Kconfig symbol
      powerpc: drop unused Kconfig symbols
      x86: drop unused Kconfig symbol
      stmmac: drop unused Kconfig symbol
      pci: drop unused Kconfig symbol
      scsi: drop unused Kconfig symbol

 arch/alpha/Kconfig                         |    5 -----
 arch/arm/mach-at91/Kconfig                 |    6 ------
 arch/m32r/Kconfig                          |    7 -------
 arch/mips/Kconfig                          |   14 --------------
 arch/mips/powertv/Kconfig                  |    2 --
 arch/mips/powertv/asic/Kconfig             |   28 ----------------------------
 arch/openrisc/Kconfig                      |   12 ------------
 arch/powerpc/Kconfig                       |   22 ----------------------
 arch/powerpc/platforms/40x/Kconfig         |    5 -----
 arch/powerpc/platforms/Kconfig.cputype     |    8 --------
 arch/powerpc/platforms/embedded6xx/Kconfig |    4 ----
 arch/powerpc/platforms/prep/Kconfig        |    9 ---------
 arch/powerpc/platforms/wsp/Kconfig         |    5 -----
 arch/score/Kconfig                         |   19 -------------------
 arch/sh/Kconfig                            |    4 ----
 arch/sparc/Kconfig                         |    7 +------
 arch/um/Kconfig.x86                        |    3 ---
 arch/x86/Kconfig                           |    3 ---
 drivers/net/stmmac/Kconfig                 |    9 ---------
 drivers/pci/Kconfig                        |   11 -----------
 drivers/scsi/Kconfig                       |   14 --------------
 samples/Kconfig                            |    6 ------
 22 files changed, 1 insertions(+), 202 deletions(-)
 delete mode 100644 arch/mips/powertv/asic/Kconfig
