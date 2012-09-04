Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab2IDKa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 06:30:58 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:55846 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752309Ab2IDKa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 06:30:56 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+zDHYpoG2z2EHUtTqA8/r1SSPkwWXFeGJGgoDjxL
	IEsTofYtvOCPWg
Message-ID: <5045D85B.6060501@gmx.de>
Date: Tue, 04 Sep 2012 10:30:51 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: [GIT PULL] fbdev fixes for 3.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the fixes below.


Thanks,

Florian Tobias Schandinat


The following changes since commit fea7a08acb13524b47711625eebea40a0ede69a0:

  Linux 3.6-rc3 (2012-08-22 13:29:06 -0700)

are available in the git repository at:

  git://github.com/schandinat/linux-2.6.git fbdev-fixes-for-3.6-1

for you to fetch changes up to c1c52848cef52e157468b8879fc3cae23b6f3a99:

  OMAPFB: fix framebuffer console colors (2012-08-23 12:37:22 +0000)

----------------------------------------------------------------
fbdev fixes for 3.6

- a fix by Paul Cercueil to prevent a possible buffer overflow
- a fix by Bruno Prémont to prevent a rare sleep in invalid context
- a fix by Julia Lawall for a double free in auo_k190x
- a fix by Dan Carpenter to prevent a division by zero in mb862xxfb
- a regression fix by Tomi Valkeinen for the SDI output in OMAP
- a fix by Grazvydas Ignotas to fix the console colors in OMAP

----------------------------------------------------------------
Bruno Prémont (1):
      fbcon: Fix bit_putcs() call to kmalloc(s, GFP_KERNEL)

Dan Carpenter (1):
      video: mb862xxfb: prevent divide by zero bug

Grazvydas Ignotas (1):
      OMAPFB: fix framebuffer console colors

Julia Lawall (1):
      drivers/video/auo_k190x.c: drop kfree of devm_kzalloc's data

Paul Cercueil (1):
      fbcon: prevent possible buffer overflow.

Tomi Valkeinen (1):
      OMAPDSS: Fix SDI PLL locking

 drivers/video/auo_k190x.c                |    2 --
 drivers/video/console/bitblit.c          |    2 +-
 drivers/video/console/fbcon.c            |    2 +-
 drivers/video/mb862xx/mb862xxfbdrv.c     |    2 ++
 drivers/video/omap2/dss/sdi.c            |   14 ++++++++++++++
 drivers/video/omap2/omapfb/omapfb-main.c |    2 +-
 6 files changed, 19 insertions(+), 5 deletions(-)
