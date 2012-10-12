Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab2JLT0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 15:26:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50624 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab2JLT0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 15:26:21 -0400
Date: Fri, 12 Oct 2012 15:26:17 -0400 (EDT)
Message-Id: <20121012.152617.102293507587771934.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) Updated syscall tracing fix from Al Viro.

2) SUN4V error reporting was deficient in several areas.

Please pull, thanks a lot!

The following changes since commit 2474542f64432398f503373f53bdf620491bcfa8:

  Merge tag 'for-3.7-rc1' of git://gitorious.org/linux-pwm/linux-pwm (2012-10-10 20:15:24 +0900)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to 55c2770e413e96871147b9406a9c41fe9bc5209c:

  sparc64: fix ptrace interaction with force_successful_syscall_return() (2012-10-10 17:25:00 -0700)

----------------------------------------------------------------
Al Viro (1):
      sparc64: fix ptrace interaction with force_successful_syscall_return()

David S. Miller (1):
      sparc64: Fix deficiencies in sun4v error reporting.

 arch/sparc/include/asm/uaccess_64.h |   5 ++
 arch/sparc/kernel/syscalls.S        |  32 ++++++------
 arch/sparc/kernel/traps_64.c        | 263 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------
 arch/sparc/mm/fault_64.c            |   2 -
 4 files changed, 221 insertions(+), 81 deletions(-)
