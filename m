Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab2IZVI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 17:08:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab2IZVI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 17:08:56 -0400
Subject: [GIT PULL] generic syscall and c6x fixes
From: Mark Salter <msalter@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 26 Sep 2012 17:08:53 -0400
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1348693735.23104.35.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 979570e02981d4a8fc20b3cc8fd651856c98ee9d:

  Linux 3.6-rc7 (2012-09-23 18:10:57 -0700)

are available in the git repository at:

  git://linux-c6x.org/git/projects/linux-c6x-upstreaming.git tags/for-linus

for you to fetch changes up to 11ef4cfac935ab45eb4c7f98d26c78ee69627909:

  syscalls: add __NR_kcmp syscall to generic unistd.h (2012-09-26 15:26:30 -0400)

----------------------------------------------------------------
Some fixes for v3.6

  - Add __NR_kcmp to generic syscall list
  - C6X: Use generic asm/barrier.h

----------------------------------------------------------------
Mark Salter (2):
      c6x: use asm-generic/barrier.h
      syscalls: add __NR_kcmp syscall to generic unistd.h

 arch/c6x/include/asm/Kbuild    |    1 +
 arch/c6x/include/asm/barrier.h |   27 ---------------------------
 include/asm-generic/unistd.h   |    4 +++-
 3 files changed, 4 insertions(+), 28 deletions(-)
 delete mode 100644 arch/c6x/include/asm/barrier.h


