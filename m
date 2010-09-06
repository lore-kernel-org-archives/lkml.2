Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab0IFJRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 05:17:23 -0400
Received: from smtp.nokia.com ([147.243.1.47]:46129 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab0IFJRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 05:17:22 -0400
X-Greylist: delayed 2470 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Sep 2010 05:17:22 EDT
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 06 Sep 2010 11:35:12 +0300
Message-Id: <20100906083512.1268.48759.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBI fixes for 2.6.36-rc
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please UBI fixes for 2.6.36-rcX.

The following changes since commit 2bfc96a127bc1cc94d26bfaa40159966064f9c8c:

  Linux 2.6.36-rc3 (2010-08-29 08:36:04 -0700)

are available in the git repository at:
  git://git.infradead.org/ubi-2.6.git linux-next

Artem Bityutskiy (2):
      UBI: fix forward compatibility
      UBI: do not oops when erroneous PEB is scheduled for scrubbing

Julia Lawall (1):
      UBI: eliminate update of list_for_each_entry loop cursor

Randy Dunlap (1):
      UBI: fix kconfig unmet dependency

 drivers/mtd/ubi/Kconfig.debug |    2 +-
 drivers/mtd/ubi/cdev.c        |   12 ++++++------
 drivers/mtd/ubi/scan.c        |    2 +-
 drivers/mtd/ubi/wl.c          |    3 ++-
 4 files changed, 10 insertions(+), 9 deletions(-)

Thanks,
Artem.
