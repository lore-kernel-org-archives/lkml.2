Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab2DDIDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 04:03:30 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:42871 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088Ab2DDID0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 04:03:26 -0400
Date: Wed, 04 Apr 2012 04:03:23 -0400 (EDT)
Message-Id: <20120404.040323.342187037087621691.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 04 Apr 2012 01:03:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get one build regressiona done serial probe
regression fix on sparc.

Thanks!

The following changes since commit dd775ae2549217d3ae09363e3edb305d0fa19928:

  Linux 3.4-rc1 (2012-03-31 16:24:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc master

for you to fetch changes up to ca6f327dfdc6b3b90aa0c5247182ae023dce6450:

  serial/sunzilog: fix keyboard on SUN SPARCstation (2012-04-04 00:37:10 -0700)

----------------------------------------------------------------
Aaro Koskinen (1):
      sparc: pgtable_64: change include order

Sam Ravnborg (1):
      serial/sunzilog: fix keyboard on SUN SPARCstation

 arch/sparc/include/asm/pgtable_64.h |    4 ++--
 drivers/tty/serial/sunzilog.c       |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)
