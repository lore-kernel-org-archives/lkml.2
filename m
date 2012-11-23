Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab2KWTsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 14:48:36 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49739 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab2KWTsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 14:48:35 -0500
Date: Fri, 23 Nov 2012 14:48:31 -0500 (EST)
Message-Id: <20121123.144831.453731602280182518.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull in this bug fix from Al Viro.

Thanks!

The following changes since commit 3587b1b097d70c2eb9fee95ea7995d13c05f66e5:

  fanotify: fix FAN_Q_OVERFLOW case of fanotify_read() (2012-11-18 09:30:00 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc master

for you to fetch changes up to fae2ae2a900a5c7bb385fe4075f343e7e2d5daa2:

  sparc64: not any error from do_sigaltstack() should fail rt_sigreturn() (2012-11-18 22:27:03 -0500)

----------------------------------------------------------------
Al Viro (1):
      sparc64: not any error from do_sigaltstack() should fail rt_sigreturn()

 arch/sparc/kernel/signal_64.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)
