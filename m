Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab1C3K6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 06:58:17 -0400
Received: from sh.osrg.net ([192.16.179.4]:44573 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754193Ab1C3K6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 06:58:16 -0400
Date: Wed, 30 Mar 2011 19:58:09 +0900 (JST)
Message-Id: <20110330.195809.130853394.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        linux-nilfs@vger.kernel.org
Subject: [GIT PULL] nilfs2 fixes
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 30 Mar 2011 19:58:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

This fixes a kernel oops on the rc1 and a data loss issue in mmap
write.

Thanks!

Ryusuke Konishi
--
The following changes since commit 0ce790e7d736cedc563e1fb4e998babf5a4dbc3d:

  Linux 2.6.39-rc1 (2011-03-29 12:09:47 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

Nicolas Kaiser (1):
      nilfs2: fix whitespace coding style issues

Ryusuke Konishi (2):
      nilfs2: fix data loss in mmap page write for hole blocks
      nilfs2: fix oops due to a bad aops initialization

 fs/nilfs2/file.c  |   11 +++++------
 fs/nilfs2/nilfs.h |   14 +++++++-------
 fs/nilfs2/page.c  |    4 +++-
 3 files changed, 15 insertions(+), 14 deletions(-)
