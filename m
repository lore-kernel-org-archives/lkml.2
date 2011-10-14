Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab1JNM1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:27:21 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:57591 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349Ab1JNM1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:27:20 -0400
Subject: [PATCH 00/21] drop unused Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 14:27:10 +0200
Message-ID: <1318595230.6132.56.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches removes unused Kconfig symbols from Kconfig files
across the tree. Roughly half of the changes turned out to be in the
cris architecture.

Unused Kconfig symbols were identified using a few silly scripts. I
actually expected more unused symbols. It's likely I missed a few. Maybe
I'll discover more in a next iteration using smarter scripts. (If I find
the courage to do this again, that is.)

Testing was done with "git grep" only. (Well, "git grep" and a lot of
tedious manual inspection of these Kconfig files.) I lack the
(intellectual) bandwidth to come up with some reasonable test, given the
fact that this touches a lot of architectures, subsystems and drivers I
know absolutely nothing about. Any suggestions?

Paul Bolle (21):
  alpha: drop unused Kconfig symbol
  blackfin: drop unused Kconfig symbol
  sparc: drop unused Kconfig symbol
  um: drop unused Kconfig symbol
  sh: drop unused Kconfig symbol
  unicore32: drop unused Kconfig symbols
  score: drop unused Kconfig symbols
  m32r: drop unused Kconfig symbol
  samples: drop unused Kconfig symbol
  tomoyo: drop unused Kconfig symbols
  ARM: drop unused Kconfig symbols
  m68k: drop unused Kconfig symbols
  openrisc: drop unused Kconfig symbols
  mips: drop unused Kconfig symbols
  powerpc: drop unused Kconfig symbols
  x86: drop unused Kconfig symbol
  stmmac: drop unused Kconfig symbol
  pci: drop unused Kconfig symbol
  scsi: drop unused Kconfig symbol
  staging: drop unused Kconfig symbols
  cris: drop unused Kconfig symbols

 arch/alpha/Kconfig                         |    5 -
 arch/arm/mach-at91/Kconfig                 |    6 -
 arch/arm/mach-ixp4xx/Kconfig               |    1 +
 arch/arm/mach-pxa/Kconfig                  |    3 -
 arch/blackfin/Kconfig                      |    4 -
 arch/cris/Kconfig                          |   49 ----
 arch/cris/arch-v10/drivers/Kconfig         |   23 --
 arch/cris/arch-v32/drivers/Kconfig         |  380 ----------------------------
 arch/cris/arch-v32/mach-a3/Kconfig         |    4 -
 arch/m32r/Kconfig                          |    7 -
 arch/m68k/Kconfig                          |   28 +--
 arch/m68k/Kconfig.nommu                    |   44 ----
 arch/mips/Kconfig                          |   14 -
 arch/mips/powertv/Kconfig                  |    2 -
 arch/mips/powertv/asic/Kconfig             |   28 --
 arch/openrisc/Kconfig                      |   12 -
 arch/powerpc/Kconfig                       |   22 --
 arch/powerpc/platforms/40x/Kconfig         |    5 -
 arch/powerpc/platforms/Kconfig.cputype     |    8 -
 arch/powerpc/platforms/embedded6xx/Kconfig |    4 -
 arch/powerpc/platforms/prep/Kconfig        |    9 -
 arch/powerpc/platforms/wsp/Kconfig         |    5 -
 arch/score/Kconfig                         |   19 --
 arch/sh/Kconfig                            |    4 -
 arch/sparc/Kconfig                         |    7 +-
 arch/um/Kconfig.x86                        |    3 -
 arch/unicore32/Kconfig.debug               |   14 -
 arch/x86/Kconfig                           |    3 -
 drivers/net/stmmac/Kconfig                 |    9 -
 drivers/pci/Kconfig                        |   11 -
 drivers/scsi/Kconfig                       |   14 -
 drivers/staging/et131x/Kconfig             |    9 -
 drivers/staging/pohmelfs/Kconfig           |    8 -
 samples/Kconfig                            |    6 -
 security/tomoyo/Kconfig                    |   24 --
 35 files changed, 3 insertions(+), 791 deletions(-)
 delete mode 100644 arch/mips/powertv/asic/Kconfig

-- 
1.7.4.4

