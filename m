Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758903Ab1CDIPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 03:15:12 -0500
Received: from linux-sh.org ([111.68.239.195]:57861 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645Ab1CDIPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 03:15:10 -0500
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Mar 2011 03:15:10 EST
Date: Fri, 4 Mar 2011 17:09:20 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] rmobile updates for 2.6.38-rc8
Message-ID: <20110304080920.GA13319@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git rmobile-fixes-for-linus

Which contains:

Kuninori Morimoto (4):
      ARM: mach-shmobile: ap4evb: fixup memory initialize for zboot
      ARM: mach-shmobile: mackerel: fixup memory initialize for zboot
      ARM: mach-shmobile: ap4evb: modify LCDC clock divider value
      ARM: mach-shmobile: mackerel: modify LCDC clock divider value

Magnus Damm (2):
      ARM: mach-shmobile: AG5EVM MIPI-DSI LCD reset delay fix
      ARM: mach-shmobile: Add sh73a0 MIPI-CSI and CEU clocks

 arch/arm/mach-shmobile/board-ag5evm.c              |    1 +
 arch/arm/mach-shmobile/board-ap4evb.c              |    2 +-
 arch/arm/mach-shmobile/board-mackerel.c            |    2 +-
 arch/arm/mach-shmobile/clock-sh73a0.c              |   17 ++++++++++++++---
 .../arm/mach-shmobile/include/mach/head-ap4evb.txt |   10 +++++-----
 .../mach-shmobile/include/mach/head-mackerel.txt   |   10 +++++-----
 6 files changed, 27 insertions(+), 15 deletions(-)
