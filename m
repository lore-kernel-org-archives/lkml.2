Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab0KYCXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 21:23:09 -0500
Received: from sh.osrg.net ([192.16.179.4]:40349 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab0KYCXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 21:23:07 -0500
Date: Thu, 25 Nov 2010 11:22:55 +0900 (JST)
Message-Id: <20101125.112255.65842026.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [GIT PULL] nilfs2 fixes for 2.6.37-rc4
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 25 Nov 2010 11:22:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

to grab the following regression fixes, an error handling bug fix and
a typo fix.

Thanks.

Ryusuke Konishi
--
The following changes since commit 3561d43fd289f590fdae672e5eb831b8d5cf0bf6:

  Linux 2.6.37-rc3 (2010-11-21 15:18:56 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git fixes

Dan Carpenter (1):
      nilfs2: nilfs_iget_for_gc() returns ERR_PTR

Ryusuke Konishi (1):
      nilfs2: fix typo in comment of nilfs_dat_move function

 fs/nilfs2/dat.c   |    2 +-
 fs/nilfs2/ioctl.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)
