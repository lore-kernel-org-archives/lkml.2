Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab1GDIVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 04:21:40 -0400
Received: from linux-sh.org ([111.68.239.195]:38999 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab1GDIVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 04:21:38 -0400
Date: Mon, 4 Jul 2011 17:21:05 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] fbdev fixes for 3.0-rc6
Message-ID: <20110704082105.GC24169@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/fbdev-3.x.git fbdev-fixes-for-linus

Which contains:

Damian Hobson-Garcia (1):
      fbdev: sh_mobile_meram: Correct pointer check for YCbCr chroma plane

Daniel J Blueman (1):
      vesafb: fix memory leak

Loïc Minier (1):
      fbdev: amba: Link fb device to its parent

Pavel Shved (1):
      hecubafb: add module_put on error path in hecubafb_probe()

Randy Dunlap (2):
      gx1fb: Fix section mismatch warnings
      sm501fb: fix section mismatch warning

Timur Tabi (1):
      fsl-diu-fb: remove check for pixel clock ranges

William Katsak (1):
      udlfb: Correct sub-optimal resolution selection.

 drivers/video/amba-clcd.c        |    2 ++
 drivers/video/fsl-diu-fb.c       |   16 ----------------
 drivers/video/geode/gx1fb_core.c |   14 +++++++-------
 drivers/video/hecubafb.c         |    3 ++-
 drivers/video/sh_mobile_meram.c  |    2 +-
 drivers/video/sm501fb.c          |    2 +-
 drivers/video/udlfb.c            |    8 ++++++--
 drivers/video/vesafb.c           |    1 +
 include/linux/fsl-diu-fb.h       |    6 ------
 9 files changed, 20 insertions(+), 34 deletions(-)
