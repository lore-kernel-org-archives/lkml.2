Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab1H3SNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 14:13:44 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:57607 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab1H3SNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 14:13:43 -0400
Date: Tue, 30 Aug 2011 14:13:07 -0400 (EDT)
Message-Id: <20110830.141307.444194149590113106.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 30 Aug 2011 11:13:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get this popc support detection bug fix, thanks!

The following changes since commit 0f43dd546d991ca260d8a72d07f617907c508de8:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2011-08-29 13:38:29 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc.git master

David S. Miller (1):
      sparc64: Only Panther cheetah+ chips have POPC.

 arch/sparc/kernel/setup_64.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)
