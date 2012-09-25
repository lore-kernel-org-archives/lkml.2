Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab2IYOmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 10:42:15 -0400
Received: from linux-sh.org ([111.68.239.195]:34369 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753743Ab2IYOmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 10:42:13 -0400
Date: Tue, 25 Sep 2012 23:42:07 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh fixes for 3.6-final
Message-ID: <20120925144207.GK13568@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One last minute regression fix..

The following changes since commit 56d27adcb536b7430d5f8a6240df8ad261eb00bd:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile (2012-09-24 16:17:17 -0700)

are available in the git repository at:


  git://github.com/pmundt/linux-sh tags/sh-for-linus

for you to fetch changes up to 16d74ebeb1b056dfc80e69b44cc3a26515db1925:

  sh: pfc: Fix up GPIO mux type reconfig case. (2012-09-25 11:51:05 +0900)

----------------------------------------------------------------
SuperH fixes for 3.6-final

----------------------------------------------------------------
Paul Mundt (1):
      sh: pfc: Fix up GPIO mux type reconfig case.

 drivers/sh/pfc/pinctrl.c | 2 ++
 1 file changed, 2 insertions(+)
