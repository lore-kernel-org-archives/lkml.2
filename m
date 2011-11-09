Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991Ab1KIATh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 19:19:37 -0500
Received: from mail.windriver.com ([147.11.1.11]:32790 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab1KIATg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 19:19:36 -0500
Date: Tue, 8 Nov 2011 19:19:32 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] module.h fixes for recently merged new content
Message-ID: <20111109001932.GA32250@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull this to get what should be the last of the module.h fixups
for recently merged content that wasn't in linux-next for us to test/fix
in advance.

The u8500 fix may look like something you just merged, but it is not; it
is the same file/author, but an independent fix.

Thanks,
Paul.

---

The following changes since commit 1ea6b8f48918282bdca0b32a34095504ee65bab5:

  Linux 3.2-rc1 (2011-11-07 16:16:02 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git for-linus

Axel Lin (1):
      hwspinlock/u8500: include linux/module.h

Jonas Gorski (1):
      MTD: MAPS: bcm963xx-flash.c: explicitly include module.h

Paul Gortmaker (2):
      mfd: fix build failures in recently added ab5500 code
      drivers/media: video/a5k6aa is a module and so needs module.h

 drivers/hwspinlock/u8500_hsem.c   |    1 +
 drivers/media/video/s5k6aa.c      |    1 +
 drivers/mfd/ab5500-core.c         |    1 +
 drivers/mfd/ab5500-debugfs.c      |    1 +
 drivers/mtd/maps/bcm963xx-flash.c |    1 +
 5 files changed, 5 insertions(+), 0 deletions(-)

