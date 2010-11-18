Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab0KRMzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 07:55:43 -0500
Received: from mail.windriver.com ([147.11.1.11]:53133 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897Ab0KRMzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 07:55:41 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [GIT PULL] kgdb/kdb tree for 2.6.37-rc3
Date: Thu, 18 Nov 2010 06:55:59 -0600
Message-Id: <1290084963-6376-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 18 Nov 2010 12:55:24.0026 (UTC) FILETIME=[DD82BDA0:01CB871F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the for_linus branch to pick up several regression fixes.

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

Summary:
  * Fix perf API problem with HW breakpoints ( >= 2.6.35)
  * kdb oops fixes ( >= 2.6.35)
  * ppc evr register handling ( >= 2.6.37-rc0)

Thanks,
Jason.

---
The following changes since commit e53beacd23d9cb47590da6a7a7f6d417b941a994:
  Linus Torvalds (1):
        Linux 2.6.37-rc2

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

Dongdong Deng (1):
      kgdb,ppc: Fix regression in evr register handling

Jason Wessel (1):
      kgdb,x86: fix regression in detach handling

Jovi Zhang (2):
      kdb: fix memory leak in kdb_main.c
      kdb: fix crash when KDB_BASE_CMD_MAX is exceeded

 arch/powerpc/kernel/kgdb.c  |    4 ++--
 arch/x86/kernel/kgdb.c      |   12 ++++++++----
 kernel/debug/kdb/kdb_main.c |   21 +++++++++++----------
 3 files changed, 21 insertions(+), 16 deletions(-)
