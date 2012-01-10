Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab2AJCxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 21:53:44 -0500
Received: from mx5.pku.edu.cn ([162.105.129.59]:45673 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755960Ab2AJCxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 21:53:43 -0500
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jan 2012 21:53:42 EST
X-Spam-Flag: NO
X-Spam-Score: -311.064
Subject: [git pull] Please  pull my unicore32 branch
From: Guan Xuetao <gxt@pku.edu.cn>
Reply-To: gxt@pku.edu.cn
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Peking University
Date: Tue, 10 Jan 2012 10:46:17 +0800
Message-ID: <1326163577.1782.33.camel@epip-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus,
  Could you please pull unicore32 branch from my repo:
	git://github.com/gxt/linux.git unicore32

  Thanks!

Guan Xuetao

The following changes since commit
c99516ca854770000c277b2680a15581c691e18c:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../viro/vfs

are available in the git repository at:

  git://github.com/gxt/linux.git unicore32

Guan Xuetao (6):
      unicore32: delete specified xlate_dev_mem_ptr
      unicore32: add ioremap_nocache definition
      rtc-puv3: irq: remove IRQF_DISABLED
      i2c-puv3: using module_platform_driver()
      rtc-puv3: using module_platform_driver()
      rtc-puv3: solve section mismatch in rtc-puv3.c

Kees Cook (1):
      unicore32: standardize /proc/iomem "Kernel code" name

Matt Fleming (1):
      unicore32: Use set_current_blocked()

Yong Zhang (1):
      unicore32: Remove IRQF_DISABLED

Yu Yue (1):
      of: add include asm/setup.h in drivers/of/fdt.c

 arch/unicore32/include/asm/io.h     |    8 +-------
 arch/unicore32/kernel/puv3-nb0916.c |    4 ++--
 arch/unicore32/kernel/setup.c       |    2 +-
 arch/unicore32/kernel/signal.c      |   15 +++++----------
 arch/unicore32/kernel/time.c        |    2 +-
 drivers/i2c/busses/i2c-puv3.c       |   16 ++--------------
 drivers/of/fdt.c                    |    1 +
 drivers/rtc/rtc-puv3.c              |   22 ++++------------------
 8 files changed, 17 insertions(+), 53 deletions(-)

