Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab1AYJwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 04:52:13 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:46817 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab1AYJwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 04:52:09 -0500
Date: Tue, 25 Jan 2011 18:51:59 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] fbdev updates for 2.6.38-rc3
Message-ID: <20110125095159.GA18633@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/fbdev-2.6.git fbdev-fixes-for-linus

Which contains:

Amerigo Wang (1):
      video: fix some comments in drivers/video/console/vgacon.c

Axel Lin (5):
      video: nuc900fb: fix compile error
      video: nuc900fb: properly free resources in nuc900fb_remove
      video: pxa3xx-gcu: Return -EFAULT when copy_from_user() fails
      video: da8xx-fb: fix fb_probe error path
      video: pxa168fb: remove a redundant pxa168fb_check_var call

Julia Lawall (1):
      drivers/video/bf537-lq035.c: Add missing IS_ERR test

Paul Mundt (1):
      mailmap: Add an entry for Axel Lin.

 .mailmap                       |    1 +
 drivers/video/bf537-lq035.c    |   58 ++++++++++++++++++++++-----------------
 drivers/video/console/vgacon.c |    6 +---
 drivers/video/da8xx-fb.c       |    3 +-
 drivers/video/nuc900fb.c       |    6 +++-
 drivers/video/pxa168fb.c       |    6 +---
 drivers/video/pxa3xx-gcu.c     |    4 +-
 7 files changed, 44 insertions(+), 40 deletions(-)
