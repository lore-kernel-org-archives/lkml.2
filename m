Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab1CUCv3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 22:51:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34081
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752663Ab1CUCvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 22:51:21 -0400
Date: Sun, 20 Mar 2011 19:51:59 -0700 (PDT)
Message-Id: <20110320.195159.71120857.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) Flesh out some missing OF layer interfaces to fix allmodconfig
   build.

2) Hook up new system calls.

Please pull, thanks a lot!

The following changes since commit a44f99c7efdb88fa41128065c9a9445c19894e34:

  Merge branch 'trivial' of git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6 (2011-03-20 18:14:55 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (4):
      sparc: Provide NO_IRQ definition.
      sparc: Implement of_address_to_resource().
      sparc: Implement of_iomap().
      sparc: Add {open_by,name_to}_handle_at and clock_adjtime syscalls.

 arch/sparc/include/asm/irq_32.h      |    3 +++
 arch/sparc/include/asm/irq_64.h      |    2 ++
 arch/sparc/include/asm/unistd.h      |    5 ++++-
 arch/sparc/kernel/of_device_common.c |   27 +++++++++++++++++++++++++++
 arch/sparc/kernel/systbls_32.S       |    2 +-
 arch/sparc/kernel/systbls_64.S       |    4 ++--
 6 files changed, 39 insertions(+), 4 deletions(-)
