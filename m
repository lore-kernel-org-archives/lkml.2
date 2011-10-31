Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206Ab1JaIcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 04:32:10 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:54440 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab1JaIcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 04:32:09 -0400
Date: Mon, 31 Oct 2011 04:32:05 -0400 (EDT)
Message-Id: <20111031.043205.1749829212092506403.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 31 Oct 2011 01:32:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Not very exciting stuff, basically just bug fixes.

1) Make memcpy on sparc32 properly return original dst pointer.

2) Fix VIS vector comparison instruction emulation.

Please pull, thanks a lot!

The following changes since commit 839d8810747bbf39e0a5a7f223b67bffa7945f8d:

  Merge branch 'i2c-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging (2011-10-30 15:54:59 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

David S. Miller (4):
      sparc32: Remove non-kernel code from memcpy implementation.
      sparc32: Remove uses of %g7 in memcpy implementation.
      sparc32: Correct the return value of memcpy.
      sparc64: Fix masking and shifting in VIS fpcmp emulation.

 arch/sparc/kernel/visemul.c |   32 +-
 arch/sparc/lib/memcpy.S     |  804 ++++++-------------------------------------
 2 files changed, 115 insertions(+), 721 deletions(-)
