Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761018Ab2FDVvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 17:51:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35207 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756332Ab2FDVvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 17:51:49 -0400
Date: Mon, 4 Jun 2012 22:51:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] fixups for vfs.git and signal.git
Message-ID: <20120604215148.GA30000@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assorted build breakage ;-/  Please, pull from
git.kernel.org/pub/scm/linux/kernel/git/viro/signal for-linus
Shortlog:
Al Viro (1):
      fixups for signal breakage

Diffstat:
 arch/avr32/kernel/signal.c        |    2 +-
 arch/xtensa/include/asm/syscall.h |    4 ++--
 arch/xtensa/kernel/signal.c       |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

and

git.kernel.org/pub/scm/linux/kernel/git/viro/vfs for-linus
Shortlog:
Greg Ungerer (1):
      nommu: fix compilation of nommu.c

Diffstat:
 mm/nommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


