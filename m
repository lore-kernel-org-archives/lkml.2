Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719Ab0IZVT3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 17:19:29 -0400
Received: from void.printf.net ([89.145.121.20]:50256 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654Ab0IZVT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 17:19:28 -0400
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] MMC fixes for .36-rc6
Date: Sun, 26 Sep 2010 17:22:11 -0400
Message-ID: <m362xs42v0.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

to fix a regression from -rc2 and a NULL dereference against 2.6.35, both
with Samsung S3C controllers.  There's also a MAINTAINERS update -- I've
volunteered to take over MMC, and am running a tree in -next.  Thanks.

The following changes since commit 32163f4b2cef28a5aab8b226ffecfc6379a53786:
  Al Viro (1):
        alpha: fix usp value in multithreaded coredumps

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

Chris Ball (1):
      mmc: MAINTAINERS: add myself as MMC maintainer

Marek Szyprowski (2):
      mmc: sdhci-s3c: fix incorrect spinlock usage after merge
      mmc: sdhci-s3c: fix NULL ptr access in sdhci_s3c_remove

 MAINTAINERS                  |    8 ++++++--
 drivers/mmc/host/sdhci-s3c.c |   12 ++++++++----
 2 files changed, 14 insertions(+), 6 deletions(-)

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
