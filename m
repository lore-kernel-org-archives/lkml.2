Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499Ab0HEAVC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 20:21:02 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60883
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758230Ab0HEAVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 20:21:00 -0400
Date: Wed, 04 Aug 2010 17:21:18 -0700 (PDT)
Message-Id: <20100804.172118.242112071.davem@davemloft.net>
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


1) Convert BKL --> mutex in SBUS drivers, from Arnd Bergmann.

2) Should use GFP_KERNEL in sparc32 SBUS init code, from Julia
   Lawall.

3) MAINTAINERS tweak

Please pull, thanks a lot!

The following changes since commit 3cfc2c42c1cbc8e238bb9c0612c0df4565e3a8b4:

  Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial (2010-08-04 15:31:02 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

Arnd Bergmann (1):
      sbus: autoconvert trivial BKL users to private mutex

David S. Miller (1):
      MAINTAINERS: Add trailing slash to SBUS path.

Julia Lawall (1):
      arch/sparc/mm: Use GFP_KERNEL

 MAINTAINERS                     |    2 +-
 arch/sparc/mm/iommu.c           |    2 +-
 drivers/sbus/char/display7seg.c |    8 ++++----
 drivers/sbus/char/envctrl.c     |    2 --
 drivers/sbus/char/flash.c       |   15 ++++++++-------
 drivers/sbus/char/openprom.c    |   15 ++++++++-------
 drivers/sbus/char/uctrl.c       |    7 ++++---
 7 files changed, 26 insertions(+), 25 deletions(-)
