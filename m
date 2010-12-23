Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab0LWIt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 03:49:56 -0500
Received: from void.printf.net ([89.145.121.20]:40086 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab0LWIty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 03:49:54 -0500
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [GIT PULL] MMC fixes for 2.6.37
Date: Thu, 23 Dec 2010 03:56:16 -0500
Message-ID: <m3pqss50lr.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

to fix a regression in resume-from-hibernate, and two minor driver bugs
on Atmel controllers.  These have been tested in linux-next.  Thanks.

The following changes since commit 0a59228168d3722b71f8e3dbc623316fb4be78f4:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile (2010-12-18 10:28:54 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

Nicolas Ferre (1):
      mmc: atmel-mci: fix multiblock SDIO transfers

Takashi Iwai (1):
      mmc: Fix re-probing with PM_POST_RESTORE notification

Yauhen Kharuzhy (1):
      mmc: at91_mci: fix multiblock SDIO transfers

 arch/arm/mach-at91/include/mach/at91_mci.h |    2 ++
 drivers/mmc/core/core.c                    |    1 +
 drivers/mmc/host/at91_mci.c                |   13 +++++++++----
 drivers/mmc/host/atmel-mci.c               |   18 ++++++++++++------
 4 files changed, 24 insertions(+), 10 deletions(-)

-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
