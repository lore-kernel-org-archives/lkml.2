Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261Ab1KHUHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 15:07:39 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:45993 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222Ab1KHUHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 15:07:38 -0500
Date: Tue, 08 Nov 2011 15:07:31 -0500 (EST)
Message-Id: <20111108.150731.152390752080053131.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 08 Nov 2011 12:07:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This just hooks up the new system calls.

Please pull, thanks!

The following changes since commit 1ea6b8f48918282bdca0b32a34095504ee65bab5:

  Linux 3.2-rc1 (2011-11-07 16:16:02 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

David S. Miller (1):
      sparc: Hook up process_vm_{readv,writev} syscalls.

 arch/sparc/include/asm/unistd.h |    4 +++-
 arch/sparc/kernel/systbls_32.S  |    2 +-
 arch/sparc/kernel/systbls_64.S  |    4 ++--
 3 files changed, 6 insertions(+), 4 deletions(-)
