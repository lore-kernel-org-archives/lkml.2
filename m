Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab0HRFBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 01:01:01 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:43228 "HELO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750979Ab0HRFA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 01:00:57 -0400
Date: Wed, 18 Aug 2010 14:56:40 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-ID: <201008180456.o7I4uekp031013@goober.internal.moreton.com.au>
CC: <gerg@uclinux.org>, <linux-kernel@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>
Subject: [git pull] m68knommu arch fixes
To: <torvalds@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.0)
X-OriginalArrivalTime: 18 Aug 2010 04:59:52.0836 (UTC) FILETIME=[3197A440:01CB3E92]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Can you please pull the m68knommu git tree, for-linus branch.
A couple of minor bug fixes here for the m68knommu arch.

Thanks
Greg



The following changes since commit da5cabf80e2433131bf0ed8993abc0f7ea618c73:
  Linus Torvalds (1):
        Linux 2.6.36-rc1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

Greg Ungerer (1):
      m68knommu: include sched.h in ColdFire/SPI driver

Jate Sujjavanich (1):
      m68knommu: arch/m68k/include/asm/ide.h fix for nommu

Kulikov Vasiliy (1):
      m68knommu: formatting of pointers in printk()

 arch/m68k/include/asm/ide.h     |   13 +++++++++++--
 arch/m68knommu/kernel/process.c |   10 +++++-----
 drivers/spi/coldfire_qspi.c     |    1 +
 3 files changed, 17 insertions(+), 7 deletions(-)
