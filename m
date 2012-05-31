Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab2EaK51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 06:57:27 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37282 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751518Ab2EaK5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 06:57:25 -0400
Message-ID: <1338461840.3073.15.camel@dabdike.int.hansenpartnership.com>
Subject: [GIT PULL] parisc updates for the 3.4+ merge window
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Parisc List <linux-parisc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 31 May 2012 11:57:20 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a couple of updates to complete our fixes and one to fix a
compile failure caused during the merge window.  Additionally, we now
switch to the generic strncopy_from_user.

The update is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/parisc-2.6.git parisc-misc

The short changelog is:

James Bottomley (3):
      [PARISC] update parisc to use generic strncpy_from_user()
      [PARISC] Fix parisc compile failure after smp: Add task_struct argument to __cpu_up()
      [PARISC] fix TLB fault path on PA2.0 narrow systems

John David Anglin (1):
      [PARISC] fix boot failure on 32-bit systems caused by branch stubs placed before .text

And the diffstat:

 arch/parisc/Kconfig               |    1 +
 arch/parisc/include/asm/smp.h     |    2 --
 arch/parisc/include/asm/uaccess.h |    5 ++---
 arch/parisc/kernel/entry.S        |   30 +++++++++++++++------------
 arch/parisc/kernel/parisc_ksyms.c |    1 -
 arch/parisc/kernel/vmlinux.lds.S  |    6 ++++--
 arch/parisc/lib/lusercopy.S       |   41 -------------------------------------
 7 files changed, 24 insertions(+), 62 deletions(-)

James


