Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab0EXHLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 03:11:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51437
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753393Ab0EXHLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 03:11:21 -0400
Date: Mon, 24 May 2010 00:11:30 -0700 (PDT)
Message-Id: <20100524.001130.04664737.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT] IDE
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A few bug fixes, a comment typo fix, etc.  Ie. nothing really
interesting, as it should be, for a subsystem in deep
maintainence mode.

Please pull, thanks a lot!

The following changes since commit 8777c793d6a24c7f3adf52b1b1086e9706de4589:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../tj/wq

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/ide-2.6.git master

Sergei Shtylyov (4):
      ide: fix comment typo in ide.h
      pdc202xx_old: wire test_irq() method for PDC2026x
      pdc202xx_old: ignore "FIFO empty" bit in test_irq() method
      cmd640: fix kernel oops in test_irq() method

Yegor Yefremov (1):
      IDE: pass IRQ flags to the IDE core

 drivers/ide/cmd640.c       |    6 ++----
 drivers/ide/ide_platform.c |    1 +
 drivers/ide/pdc202xx_old.c |    5 +++--
 include/linux/ide.h        |    4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)
