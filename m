Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab1HEK3C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:29:02 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:54374 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab1HEK3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 06:29:00 -0400
Date: Fri, 05 Aug 2011 03:28:57 -0700 (PDT)
Message-Id: <20110805.032857.238496289247403195.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] IDE
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 05 Aug 2011 03:28:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Two small fixups, that's all this merge window:

1) Fix abuse of resource IRQ flags, from Thomas Gleixner.

2) Fix PCI device ref leak, from Julia Lawall.

Please pull, thanks a lot!

The following changes since commit 140d0b2108faebc77c6523296e211e509cb9f5f9:

  Do 'shm_init_ns()' in an early pure_initcall (2011-08-04 19:35:59 -1000)

are available in the git repository at:
  master.kernel.org:/pub/scm/linux/kernel/git/davem/ide.git master

Julia Lawall (1):
      drivers/ide/cy82c693.c: Add missing pci_dev_put

Thomas Gleixner (1):
      ide: Fix irq flags madness

 drivers/ide/cy82c693.c     |    2 ++
 drivers/ide/ide_platform.c |    6 +++++-
 2 files changed, 7 insertions(+), 1 deletions(-)
