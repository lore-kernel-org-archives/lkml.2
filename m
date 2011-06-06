Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab1FFDjL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 23:39:11 -0400
Received: from linux-sh.org ([111.68.239.195]:60048 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755586Ab1FFDjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 23:39:07 -0400
Date: Mon, 6 Jun 2011 12:39:00 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] fbdev fixes for 3.0-rc2
Message-ID: <20110606033900.GF26101@linux-sh.org>
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

Andy Lutomirski (3):
      efifb: Enable write-combining
      efifb: Fix mismatched request/release_mem_region
      efifb: Disallow manual bind and unbind

Bruno PrÃƒÆ’Ã‚Â©mont (1):
      video: Fix use-after-free by vga16fb on rmmod

Joe Perches (1):
      video: Convert vmalloc/memset to vzalloc

Julia Lawall (2):
      drivers/video/imxfb.c: add missing clk_put
      drivers/video/pxa168fb.c: add missing clk_put

Paul Mundt (1):
      fbdev: sh_mobile_lcdcfb: Fix up fallout from MERAM changes.

Steven Miao (1):
      fbdev: bf537-lq035: add missing blacklight properties type

Tormod Volden (1):
      savagefb: Use panel CVT mode as default

 drivers/video/arcfb.c                  |    5 +--
 drivers/video/bf537-lq035.c            |    1 +
 drivers/video/broadsheetfb.c           |    4 +--
 drivers/video/efifb.c                  |   34 ++++++++++++++++++++-----------
 drivers/video/hecubafb.c               |    5 +--
 drivers/video/imxfb.c                  |    4 +-
 drivers/video/metronomefb.c            |    4 +--
 drivers/video/modedb.c                 |    1 +
 drivers/video/pxa168fb.c               |   17 +++++++++------
 drivers/video/savage/savagefb_driver.c |   16 +++++++++++++++
 drivers/video/sh_mobile_lcdcfb.c       |    4 +-
 drivers/video/vga16fb.c                |    2 +
 drivers/video/xen-fbfront.c            |    3 +-
 13 files changed, 63 insertions(+), 37 deletions(-)
