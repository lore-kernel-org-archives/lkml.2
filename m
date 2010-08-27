Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab0H0W7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 18:59:25 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:56151 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab0H0W7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 18:59:24 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dist-devel@blackfin.uclinux.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH 0/2] Blackfin fixes for 2.6.36-rc2
Date: Fri, 27 Aug 2010 19:08:36 -0400
Message-Id: <1282950518-7094-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the drivers have caught up, we can push out the Blackfin arch
changes.  This fixes some issues David pointed out.

Only failures left are the NOMMU FB fix which David has already pushed,
the linker script issue Sam sent out, and a new bug that has hit the
NAND tree.  I'll research & fix that in a bit.

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

-- 
1.7.2.2

