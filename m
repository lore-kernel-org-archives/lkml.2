Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab1BFKvY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 05:51:24 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:48122 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab1BFKvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 05:51:22 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        cz-bobek-lists-aranym@lists.bobek.cz
Subject: [PATCH 0/4] m68k/atari: Add ARAnyM support
Date: Sun,  6 Feb 2011 11:51:05 +0100
Message-Id: <1296989469-7844-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add improved support for running under the ARAnyM emulator
(Atari Running on Any Machine - http://aranym.org/).
Without these patches, you can run a Linux/m68k kernel with Atari support
under ARAnyM (it emulates the IDE interface), but you can't have network and
console access.

This support has been in active use for several years. In fact some Debian
build daemons run under ARAnyM, as it's the fastest m68k platform around.

  [1/4] m68k/atari: Initial ARAnyM support
  [2/4] m68k/atari: ARAnyM - Add support for block access
  [3/4] m68k/atari: ARAnyM - Add support for console access
  [4/4] m68k/atari: ARAnyM - Add support for network access

Questions:
  - Who should be listed as author for patches 1 and 4?
  - Can I please have Signed-off-by's from the ARAnyM people?

 arch/m68k/Kconfig               |   31 +++++
 arch/m68k/Makefile              |    1 +
 arch/m68k/emu/Makefile          |    9 ++
 arch/m68k/emu/natfeat.c         |   78 +++++++++++
 arch/m68k/emu/nfblock.c         |  195 ++++++++++++++++++++++++++++
 arch/m68k/emu/nfcon.c           |  162 +++++++++++++++++++++++
 arch/m68k/emu/nfeth.c           |  272 +++++++++++++++++++++++++++++++++++++++
 arch/m68k/include/asm/natfeat.h |   22 +++
 arch/m68k/kernel/setup.c        |    5 +
 9 files changed, 775 insertions(+), 0 deletions(-)

Thanks in advance!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
