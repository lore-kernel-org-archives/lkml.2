Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339Ab1FMERr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 00:17:47 -0400
Received: from sh.osrg.net ([192.16.179.4]:58495 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695Ab1FMERq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 00:17:46 -0400
Date: Mon, 13 Jun 2011 13:16:59 +0900 (JST)
Message-Id: <20110613.131659.170025547.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org
Subject: [GIT PULL] nilfs2 fixes for 3.0-rc3
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 13 Jun 2011 13:17:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

to receive the following bug fixes.  These fix a reported bug and two
boundary condition bugs recently found in btree code.

Thanks,

Ryusuke Konishi
--
The following changes since commit 59c5f46fbe01a00eedf54a23789634438bb80603:

  Linux 3.0-rc2 (2011-06-06 18:06:33 +0900)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

Ryusuke Konishi (3):
      nilfs2: fix incorrect block address termination in node concatenation
      nilfs2: fix missing block address termination in btree node shrinking
      nilfs2: fix problem in setting checkpoint interval

 fs/nilfs2/btree.c   |   39 +++++++++++++++++++++++++++------------
 fs/nilfs2/segment.c |    2 +-
 2 files changed, 28 insertions(+), 13 deletions(-)
