Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab0HPVHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 17:07:46 -0400
Received: from mail.windriver.com ([147.11.1.11]:34509 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697Ab0HPVHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 17:07:42 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [GIT PULL] kgdb/kdb fixes for 2.6.36-rc1
Date: Mon, 16 Aug 2010 16:06:24 -0500
Message-Id: <1281992789-2471-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
X-OriginalArrivalTime: 16 Aug 2010 21:06:34.0963 (UTC) FILETIME=[E8BA5A30:01CB3D86]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the for_linus branch which contains:
   * Fixes for compilation/warning errors since the kdb/kms merge
   * 1 run time fix for atomic kms where console_blanked was not saved

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_lin
us

Thanks,
Jason.

---
The following changes since commit da5cabf80e2433131bf0ed8993abc0f7ea618c73:
  Linus Torvalds (1):
        Linux 2.6.36-rc1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_lin
us

Eric Miao (1):
      arm,kgdb: fix GDB_MAX_REGS no longer used

Jason Wessel (3):
      kdb: fix compile error without CONFIG_KALLSYMS
      vt: fix regression warnings from KMS merge
      vt,console,kdb: preserve console_blanked while in kdb

Namhyung Kim (1):
      kgdb: add missing __percpu markup in arch/x86/kernel/kgdb.c

 arch/arm/kernel/kgdb.c         |    2 +-
 arch/x86/kernel/kgdb.c         |    2 +-
 drivers/char/vt.c              |   11 +++++++----
 kernel/debug/kdb/kdb_private.h |    7 +++++++
 kernel/debug/kdb/kdb_support.c |    4 ++--
 5 files changed, 18 insertions(+), 8 deletions(-)
