Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab1DIO1Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 10:27:25 -0400
Received: from smtp.nokia.com ([147.243.1.47]:50821 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217Ab1DIO1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 10:27:24 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Date: Sat, 09 Apr 2011 17:30:19 +0300
Message-Id: <20110409143019.1210.78760.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] MTD fixes for 2.6.39
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

dwmw2 is still off duty, so I'm taiking care of MTD so far.

Here are several bug-fixes which make Atmel NAND driver work again, plus
one compilation warning fix for mtdswap. Please, pull.

The following changes since commit 0ce790e7d736cedc563e1fb4e998babf5a4dbc3d:

  Linux 2.6.39-rc1 (2011-03-29 12:09:47 -0700)

are available in the git repository at:
  git://git.infradead.org/mtd-2.6.git master

Hong Xu (2):
      mtd: atmel_nand: fix support for CPUs that do not support DMA access
      mtd: atmel_nand: use CPU I/O when buffer is in vmalloc(ed) region

Nicolas Ferre (2):
      mtd: atmel_nand: trivial: change DMA usage information trace
      mtd: atmel_nand: modify test case for using DMA operations

Randy Dunlap (1):
      mtd: mtdswap: fix printk format warning

 drivers/mtd/mtdswap.c         |    2 +-
 drivers/mtd/nand/atmel_nand.c |   32 ++++++++++++--------------------
 2 files changed, 13 insertions(+), 21 deletions(-)

--
Artem.
