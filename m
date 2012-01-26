Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab2AZVz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:55:27 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:35094 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab2AZVzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:55:25 -0500
Date: Thu, 26 Jan 2012 16:55:21 -0500 (EST)
Message-Id: <20120126.165521.1045119684853288263.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 26 Jan 2012 13:55:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get this sparc 32-bit timer fix.

Thanks!

The following changes since commit 87f71ae2dd7471c1b4c94100be1f218e91dc64c3:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 (2012-01-25 19:28:58 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

Tkhai Kirill (1):
      sparc32: forced setting of mode of sun4m per-cpu timers

 arch/sparc/kernel/sun4m_irq.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)
