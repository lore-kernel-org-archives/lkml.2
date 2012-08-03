Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab2HCPi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 11:38:29 -0400
Received: from mail1.windriver.com ([147.11.146.13]:46315 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab2HCPi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 11:38:27 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <kgdb-bugreport@lists.sourceforge.net>
Subject: [GIT PULL] KGDB/KDB/dbgp fixes for 3.6-rc1
Date: Fri, 3 Aug 2012 10:38:07 -0500
Message-ID: <1344008287-2453-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was ready to go in time for the 3.6 merge window, but the pull
request had not been sent prior to the merge window closing, as it was
waiting on some final regression testing which has since passed
correctly.

There are no new features, those will be delayed to the 3.7
window. There are only fixes/cleanup against the usual kernel churn
and at least we are removing more lines than we add. :-)

Thanks,
Jason.


The following changes since commit 28a33cbc24e4256c143dce96c7d93bf423229f92:

  Linux 3.5 (2012-07-21 13:58:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/kgdb.git tags/for_linux-3.6-rc1

for you to fetch changes up to f96a4216e85050c0a9d41a41ecb0ae9d8e39b509:

  USB: echi-dbgp: increase the controller wait time to come out of halt. (2012-07-31 08:16:43 -0500)

----------------------------------------------------------------
KGDB/KDB/usb-dbgp fixes and cleanups
   usb-dbgp - increase the controller wait time to come out of halt.
   kdb - Remove unused KDB_FLAG_ONLY_DO_DUMP code and cpu in more prompt
   debug core - pass NMI type on archs that provide NMI types

----------------------------------------------------------------
Anton Vorontsov (1):
      kernel/debug: Make use of KGDB_REASON_NMI

Colin Ian King (1):
      USB: echi-dbgp: increase the controller wait time to come out of halt.

Jason Wessel (2):
      kdb: Remove unused KDB_FLAG_ONLY_DO_DUMP
      kdb: Remove cpu from the more prompt

 drivers/usb/early/ehci-dbgp.c   |    2 +-
 include/linux/kdb.h             |    2 --
 kernel/debug/kdb/kdb_debugger.c |    4 ++++
 kernel/debug/kdb/kdb_io.c       |   11 -----------
 kernel/debug/kdb/kdb_main.c     |   15 +--------------
 5 files changed, 6 insertions(+), 28 deletions(-)
