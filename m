Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab0CZGOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 02:14:42 -0400
Received: from sh.osrg.net ([192.16.179.4]:50812 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068Ab0CZGOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 02:14:41 -0400
Date: Fri, 26 Mar 2010 15:14:34 +0900 (JST)
Message-Id: <20100326.151434.58363823.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [GIT PULL] nilfs2 fixes for 2.6.34
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 26 Mar 2010 15:14:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

to grab the following fixes for reported hangup issue and a few log
writer bugs.

Thanks!

Ryusuke Konishi
--
The following changes since commit 220bf991b0366cc50a94feede3d7341fa5710ee4:
  Linus Torvalds (1):
        Linux 2.6.34-rc2

Ryusuke Konishi (3):
      nilfs2: fix duplicate call to nilfs_segctor_cancel_freev
      nilfs2: fix hang-up of cleaner after log writer returned with error
      nilfs2: fix imperfect completion wait in nilfs_wait_on_logs

 fs/nilfs2/segbuf.c  |    8 ++++----
 fs/nilfs2/segment.c |   15 +++++++--------
 2 files changed, 11 insertions(+), 12 deletions(-)
