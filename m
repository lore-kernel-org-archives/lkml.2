Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760538Ab2CMW5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 18:57:15 -0400
Received: from qmta15.westchester.pa.mail.comcast.net ([76.96.59.228]:40157
	"EHLO qmta15.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753813Ab2CMW5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 18:57:14 -0400
X-Greylist: delayed 346 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Mar 2012 18:57:13 EDT
Message-ID: <4F5FCF6E.6060403@comcast.net>
Date: Tue, 13 Mar 2012 18:51:26 -0400
From: Chris Metcalf <cdmetcalf@comcast.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/tile update for 3.3
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following changes for 3.3 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git stable

These include a couple of queued-up minor bug fixes from the community, a fix
to unbreak the sysfs hooks in tile, and syncing up the defconfigs.

Thank you!

Chris Metcalf (2):
      arch/tile: Fix up from commit 8a25a2fd126c621f44f3aeaef80d51f00fc11639
      arch/tile: sync up the defconfig files to the tip

Matt Fleming (1):
      tile: Use set_current_blocked() and block_sigmask()

roel (1):
      arch/tile: misplaced parens near likely

 arch/tile/configs/tilegx_defconfig  |  600 ++++++++++-----
 arch/tile/configs/tilepro_defconfig | 1442 ++++++++++++++++++++++++++---------
 arch/tile/kernel/compat_signal.c    |    5 +-
 arch/tile/kernel/signal.c           |   13 +-
 arch/tile/kernel/sysfs.c            |    2 +-
 arch/tile/lib/spinlock_32.c         |    2 +-
 6 files changed, 1488 insertions(+), 576 deletions(-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

