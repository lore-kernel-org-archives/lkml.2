Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab1FLF1K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 01:27:10 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52145 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab1FLF1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 01:27:07 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 11 Jun 2011 23:21:01 -0600
X-Google-Sender-Auth: WkWrmSMYYHE2fHmtxD6Ev7ohT1c
Message-ID: <BANLkTi=FxDSSyVxenNtJJ5bfiYQHm9np+g@mail.gmail.com>
Subject: [GIT PULL] gpio bug fixes
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are a couple of gpio bug fixes.

The following changes since commit 06e86849cf4019945a106913adb9ff0abcc01770:

  Merge branch 'pm-fixes' of
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6
(2011-06-08 15:58:51 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 gpio/merge

Jamie Iles (1):
      gpio/basic_mmio: add missing include of spinlock_types.h

Linus Walleij (1):
      gpio/nomadik: fix sleepmode for elder Nomadik

 arch/arm/mach-ux500/cpu-db8500.c          |    3 ++
 arch/arm/plat-nomadik/include/plat/gpio.h |    1 +
 drivers/gpio/gpio-nomadik.c               |   40 +++++++++++++++++++++--------
 include/linux/basic_mmio_gpio.h           |    1 +
 4 files changed, 34 insertions(+), 11 deletions(-)

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
