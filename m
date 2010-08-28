Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab0H1UHb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 16:07:31 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:41040 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab0H1UHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 16:07:30 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Pull request blackfin.git (for-linus branch)
Date: Sat, 28 Aug 2010 16:16:48 -0400
Message-Id: <1283026608-19665-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282950518-7094-1-git-send-email-vapier@gentoo.org>
References: <1282950518-7094-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d4348c678977c7093438bbbf2067c49396ae941b:

  Merge branch 'perf-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2010-08-25 10:50:07 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin.git for-linus

Barry Song (1):
      Blackfin: bf52x/bf54x boards: drop unused nand page size

Mike Frysinger (1):
      Blackfin: punt duplicate SPORT MMR defines

 arch/blackfin/include/asm/bfin_sport.h             |    6 -
 .../mach-bf518/include/mach/defBF51x_base.h        |   82 ---------------
 arch/blackfin/mach-bf527/boards/cm_bf527.c         |    1 -
 arch/blackfin/mach-bf527/boards/ezbrd.c            |    1 -
 arch/blackfin/mach-bf527/boards/ezkit.c            |    1 -
 .../mach-bf527/include/mach/defBF52x_base.h        |   82 ---------------
 arch/blackfin/mach-bf533/include/mach/defBF532.h   |   92 -----------------
 arch/blackfin/mach-bf537/include/mach/defBF534.h   |   80 ---------------
 arch/blackfin/mach-bf538/include/mach/defBF539.h   |  107 --------------------
 arch/blackfin/mach-bf548/boards/cm_bf548.c         |    1 -
 arch/blackfin/mach-bf548/boards/ezkit.c            |    1 -
 .../mach-bf548/include/mach/defBF54x_base.h        |   67 ------------
 arch/blackfin/mach-bf561/include/mach/defBF561.h   |   60 -----------
 13 files changed, 0 insertions(+), 581 deletions(-)
