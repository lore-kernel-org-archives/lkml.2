Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab2JIJSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:18:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854Ab2JIJQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:16:05 -0400
From: David Howells <dhowells@redhat.com>
To: lethal@linux-sh.org
Cc: dhowells@redhat.com, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for sh [ver #2]
Date: Tue, 09 Oct 2012 10:15:57 +0100
Message-ID: <21197.1349774157@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the sh tree please.

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


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-sh-20121009

for you to fetch changes up to 0a9426df1858f71ac84eb7eef500b4247de5e3bb:

  UAPI: (Scripted) Disintegrate arch/sh/include/asm (2012-10-09 09:47:37 +0100)

----------------------------------------------------------------
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate arch/sh/include/asm

 arch/sh/include/asm/Kbuild                      | 11 ----
 arch/sh/include/asm/hw_breakpoint.h             |  4 +-
 arch/sh/include/asm/posix_types.h               |  8 ---
 arch/sh/include/asm/ptrace.h                    | 34 +----------
 arch/sh/include/asm/ptrace_32.h                 | 75 +-----------------------
 arch/sh/include/asm/ptrace_64.h                 | 12 +---
 arch/sh/include/asm/setup.h                     |  5 +-
 arch/sh/include/asm/types.h                     |  5 +-
 arch/sh/include/asm/unistd.h                    |  9 +--
 arch/sh/include/uapi/asm/Kbuild                 | 22 +++++++
 arch/sh/include/{ => uapi}/asm/auxvec.h         |  0
 arch/sh/include/{ => uapi}/asm/byteorder.h      |  0
 arch/sh/include/{ => uapi}/asm/cachectl.h       |  0
 arch/sh/include/{ => uapi}/asm/cpu-features.h   |  0
 arch/sh/include/{ => uapi}/asm/ioctls.h         |  0
 arch/sh/include/uapi/asm/posix_types.h          |  7 +++
 arch/sh/include/{ => uapi}/asm/posix_types_32.h |  0
 arch/sh/include/{ => uapi}/asm/posix_types_64.h |  0
 arch/sh/include/uapi/asm/ptrace.h               | 34 +++++++++++
 arch/sh/include/uapi/asm/ptrace_32.h            | 77 +++++++++++++++++++++++++
 arch/sh/include/uapi/asm/ptrace_64.h            | 14 +++++
 arch/sh/include/uapi/asm/setup.h                |  1 +
 arch/sh/include/{ => uapi}/asm/sigcontext.h     |  0
 arch/sh/include/{ => uapi}/asm/signal.h         |  0
 arch/sh/include/{ => uapi}/asm/sockios.h        |  0
 arch/sh/include/{ => uapi}/asm/stat.h           |  0
 arch/sh/include/{ => uapi}/asm/swab.h           |  0
 arch/sh/include/uapi/asm/types.h                |  1 +
 arch/sh/include/uapi/asm/unistd.h               |  7 +++
 arch/sh/include/{ => uapi}/asm/unistd_32.h      |  0
 arch/sh/include/{ => uapi}/asm/unistd_64.h      |  0
 31 files changed, 173 insertions(+), 153 deletions(-)
 rename arch/sh/include/{ => uapi}/asm/auxvec.h (100%)
 rename arch/sh/include/{ => uapi}/asm/byteorder.h (100%)
 rename arch/sh/include/{ => uapi}/asm/cachectl.h (100%)
 rename arch/sh/include/{ => uapi}/asm/cpu-features.h (100%)
 create mode 100644 arch/sh/include/uapi/asm/hw_breakpoint.h
 rename arch/sh/include/{ => uapi}/asm/ioctls.h (100%)
 create mode 100644 arch/sh/include/uapi/asm/posix_types.h
 rename arch/sh/include/{ => uapi}/asm/posix_types_32.h (100%)
 rename arch/sh/include/{ => uapi}/asm/posix_types_64.h (100%)
 create mode 100644 arch/sh/include/uapi/asm/ptrace.h
 create mode 100644 arch/sh/include/uapi/asm/ptrace_32.h
 create mode 100644 arch/sh/include/uapi/asm/ptrace_64.h
 create mode 100644 arch/sh/include/uapi/asm/setup.h
 rename arch/sh/include/{ => uapi}/asm/sigcontext.h (100%)
 rename arch/sh/include/{ => uapi}/asm/signal.h (100%)
 rename arch/sh/include/{ => uapi}/asm/sockios.h (100%)
 rename arch/sh/include/{ => uapi}/asm/stat.h (100%)
 rename arch/sh/include/{ => uapi}/asm/swab.h (100%)
 create mode 100644 arch/sh/include/uapi/asm/types.h
 create mode 100644 arch/sh/include/uapi/asm/unistd.h
 rename arch/sh/include/{ => uapi}/asm/unistd_32.h (100%)
 rename arch/sh/include/{ => uapi}/asm/unistd_64.h (100%)
.
