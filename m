Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab2JIJUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:20:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541Ab2JIJPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:15:30 -0400
From: David Howells <dhowells@redhat.com>
To: vapier@gentoo.org
Cc: dhowells@redhat.com, uclinux-dist-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for blackfin [ver #2]
Date: Tue, 09 Oct 2012 10:15:17 +0100
Message-ID: <21116.1349774117@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the blackfin tree please.

This is to complete part of the UAPI disintegration for which the preparatory
patches were pulled recently.

Now that the fixups and the asm-generic chunk have been merged, I've
regenerated the patches to get rid of those dependencies and to take account of
any changes made so far in the merge window.  If you have already pulled the
older version of the branch aimed at you, then please feel free to ignore this
request.

The following changes since commit 9e2d8656f5e8aa214e66b462680cf86b210b74a8:

  Merge branch 'akpm' (Andrew's patch-bomb) (2012-10-09 16:23:15 +0900)

are available in the git repository at:


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-blackfin-20121009

for you to fetch changes up to ac3a050e89f2e6b8025e4176a36ed34de470fcad:

  UAPI: (Scripted) Disintegrate arch/blackfin/include/asm (2012-10-09 09:46:39 +0100)

----------------------------------------------------------------
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate arch/blackfin/include/asm

 arch/blackfin/include/asm/Kbuild                   |   5 -
 arch/blackfin/include/asm/bfin_sport.h             | 128 +-----
 arch/blackfin/include/asm/fixed_code.h             |  30 +-
 arch/blackfin/include/asm/ptrace.h                 | 161 +-------
 arch/blackfin/include/asm/unistd.h                 | 430 +-------------------
 arch/blackfin/include/uapi/asm/Kbuild              |  16 +
 arch/blackfin/include/uapi/asm/bfin_sport.h        | 136 +++++++
 arch/blackfin/include/{ => uapi}/asm/byteorder.h   |   0
 arch/blackfin/include/{ => uapi}/asm/cachectl.h    |   0
 arch/blackfin/include/{ => uapi}/asm/fcntl.h       |   0
 arch/blackfin/include/uapi/asm/fixed_code.h        |  38 ++
 arch/blackfin/include/{ => uapi}/asm/ioctls.h      |   0
 arch/blackfin/include/{ => uapi}/asm/kvm_para.h    |   0
 arch/blackfin/include/{ => uapi}/asm/poll.h        |   0
 arch/blackfin/include/{ => uapi}/asm/posix_types.h |   0
 arch/blackfin/include/uapi/asm/ptrace.h            | 170 ++++++++
 arch/blackfin/include/{ => uapi}/asm/sigcontext.h  |   0
 arch/blackfin/include/{ => uapi}/asm/siginfo.h     |   0
 arch/blackfin/include/{ => uapi}/asm/signal.h      |   0
 arch/blackfin/include/{ => uapi}/asm/stat.h        |   0
 arch/blackfin/include/{ => uapi}/asm/swab.h        |   0
 arch/blackfin/include/uapi/asm/unistd.h            | 437 +++++++++++++++++++++
 22 files changed, 802 insertions(+), 749 deletions(-)
 create mode 100644 arch/blackfin/include/uapi/asm/bfin_sport.h
 rename arch/blackfin/include/{ => uapi}/asm/byteorder.h (100%)
 rename arch/blackfin/include/{ => uapi}/asm/cachectl.h (100%)
 rename arch/blackfin/include/{ => uapi}/asm/fcntl.h (100%)
 create mode 100644 arch/blackfin/include/uapi/asm/fixed_code.h
 rename arch/blackfin/include/{ => uapi}/asm/ioctls.h (100%)
 rename arch/blackfin/include/{ => uapi}/asm/kvm_para.h (100%)
 rename arch/blackfin/include/{ => uapi}/asm/poll.h (100%)
 rename arch/blackfin/include/{ => uapi}/asm/posix_types.h (100%)
 create mode 100644 arch/blackfin/include/uapi/asm/ptrace.h
 rename arch/blackfin/include/{ => uapi}/asm/sigcontext.h (100%)
 rename arch/blackfin/include/{ => uapi}/asm/siginfo.h (100%)
 rename arch/blackfin/include/{ => uapi}/asm/signal.h (100%)
 rename arch/blackfin/include/{ => uapi}/asm/stat.h (100%)
 rename arch/blackfin/include/{ => uapi}/asm/swab.h (100%)
 create mode 100644 arch/blackfin/include/uapi/asm/unistd.h
.
