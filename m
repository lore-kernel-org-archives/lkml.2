Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831Ab1CCMQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 07:16:30 -0500
Received: from sh.osrg.net ([192.16.179.4]:42137 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915Ab1CCMQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 07:16:28 -0500
Date: Thu, 03 Mar 2011 21:16:22 +0900 (JST)
Message-Id: <20110303.211622.78542371.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        linux-nilfs@vger.kernel.org
Subject: [GIT PULL] nilfs2 fix for 2.6.38
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 03 Mar 2011 21:16:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

This will fix a reported regression leading a snapshot management
application to create meaningless snapshots endlessly.

Thanks,

Ryusuke Konishi
--
The following changes since commit dd9c1549edef02290edced639f67b54a25abbe0e:

  Linux 2.6.38-rc7 (2011-03-01 13:55:12 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

Ryusuke Konishi (1):
      nilfs2: fix regression that i-flag is not set on changeless checkpoints

 fs/nilfs2/segment.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)
