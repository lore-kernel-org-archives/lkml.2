Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab2JIJPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:15:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385Ab2JIJPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:15:23 -0400
From: David Howells <dhowells@redhat.com>
To: catalin.marinas@arm.com
Cc: dhowells@redhat.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for arm64 [ver #2]
Date: Tue, 09 Oct 2012 10:15:13 +0100
Message-ID: <21110.1349774113@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the arm64 tree please.

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


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-arm64-20121009

for you to fetch changes up to a24b2da6de9a44f395c67219d300de21f66d0da3:

  UAPI: (Scripted) Disintegrate arch/arm64/include/asm (2012-10-09 09:46:34 +0100)

----------------------------------------------------------------
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate arch/arm64/include/asm

 arch/arm64/include/asm/Kbuild                   |   2 -
 arch/arm64/include/asm/hwcap.h                  |  22 +----
 arch/arm64/include/asm/ptrace.h                 |  88 +------------------
 arch/arm64/include/asm/sigcontext.h             |  40 +--------
 arch/arm64/include/asm/stat.h                   |   5 +-
 arch/arm64/include/asm/unistd.h                 |   8 +-
 arch/arm64/include/uapi/asm/Kbuild              |  14 +++
 arch/arm64/include/{ => uapi}/asm/auxvec.h      |   0
 arch/arm64/include/{ => uapi}/asm/bitsperlong.h |   0
 arch/arm64/include/{ => uapi}/asm/byteorder.h   |   0
 arch/arm64/include/{ => uapi}/asm/fcntl.h       |   0
 arch/arm64/include/uapi/asm/hwcap.h             |  39 +++++++++
 arch/arm64/include/{ => uapi}/asm/param.h       |   0
 arch/arm64/include/uapi/asm/ptrace.h            | 110 ++++++++++++++++++++++++
 arch/arm64/include/{ => uapi}/asm/setup.h       |   0
 arch/arm64/include/uapi/asm/sigcontext.h        |  57 ++++++++++++
 arch/arm64/include/{ => uapi}/asm/siginfo.h     |   0
 arch/arm64/include/{ => uapi}/asm/signal.h      |   0
 arch/arm64/include/uapi/asm/stat.h              |  16 ++++
 arch/arm64/include/{ => uapi}/asm/statfs.h      |   0
 arch/arm64/include/uapi/asm/unistd.h            |  16 ++++
 21 files changed, 257 insertions(+), 160 deletions(-)
 rename arch/arm64/include/{ => uapi}/asm/auxvec.h (100%)
 rename arch/arm64/include/{ => uapi}/asm/bitsperlong.h (100%)
 rename arch/arm64/include/{ => uapi}/asm/byteorder.h (100%)
 rename arch/arm64/include/{ => uapi}/asm/fcntl.h (100%)
 create mode 100644 arch/arm64/include/uapi/asm/hwcap.h
 rename arch/arm64/include/{ => uapi}/asm/param.h (100%)
 create mode 100644 arch/arm64/include/uapi/asm/ptrace.h
 rename arch/arm64/include/{ => uapi}/asm/setup.h (100%)
 create mode 100644 arch/arm64/include/uapi/asm/sigcontext.h
 rename arch/arm64/include/{ => uapi}/asm/siginfo.h (100%)
 rename arch/arm64/include/{ => uapi}/asm/signal.h (100%)
 create mode 100644 arch/arm64/include/uapi/asm/stat.h
 rename arch/arm64/include/{ => uapi}/asm/statfs.h (100%)
 create mode 100644 arch/arm64/include/uapi/asm/unistd.h
.
