Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab1HGWsJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 18:48:09 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35615 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab1HGWsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 18:48:06 -0400
Date: Sun, 07 Aug 2011 15:48:02 -0700 (PDT)
Message-Id: <20110807.154802.834385239075023278.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 07 Aug 2011 15:48:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get this build fix, thanks!

The following changes since commit 4d4487140d34c1b9b321889d2d209321b0da6643:

  arm: remove "optimized" SHA1 routines (2011-08-07 14:07:03 -0700)

are available in the git repository at:
  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc.git master

David S. Miller (1):
      sparc: Fix build with DEBUG_PAGEALLOC enabled.

 arch/sparc/mm/init_64.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)
