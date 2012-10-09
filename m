Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab2JIJPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:15:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389Ab2JIJPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:15:23 -0400
From: David Howells <dhowells@redhat.com>
To: linux@arm.linux.org.uk
Cc: dhowells@redhat.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for arm [ver #2]
Date: Tue, 09 Oct 2012 10:15:10 +0100
Message-ID: <21107.1349774110@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the arm tree please.

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


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-arm-20121009

for you to fetch changes up to 86418cab1bb1aa591d48ea51d67aeb54f30732d1:

  UAPI: (Scripted) Disintegrate arch/arm/include/asm (2012-10-09 09:46:32 +0100)

----------------------------------------------------------------
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate arch/arm/include/asm

 arch/arm/include/asm/Kbuild                   |   2 -
 arch/arm/include/asm/hwcap.h                  |  27 +-
 arch/arm/include/asm/ptrace.h                 | 126 +-------
 arch/arm/include/asm/setup.h                  | 172 +---------
 arch/arm/include/asm/signal.h                 | 127 +-------
 arch/arm/include/asm/swab.h                   |  37 +--
 arch/arm/include/asm/unistd.h                 | 440 +------------------------
 arch/arm/include/uapi/asm/Kbuild              |  16 +
 arch/arm/include/{ => uapi}/asm/a.out.h       |   0
 arch/arm/include/{ => uapi}/asm/byteorder.h   |   0
 arch/arm/include/{ => uapi}/asm/fcntl.h       |   0
 arch/arm/include/uapi/asm/hwcap.h             |  29 ++
 arch/arm/include/{ => uapi}/asm/ioctls.h      |   0
 arch/arm/include/{ => uapi}/asm/kvm_para.h    |   0
 arch/arm/include/{ => uapi}/asm/mman.h        |   0
 arch/arm/include/{ => uapi}/asm/posix_types.h |   0
 arch/arm/include/uapi/asm/ptrace.h            | 137 ++++++++
 arch/arm/include/uapi/asm/setup.h             | 187 +++++++++++
 arch/arm/include/{ => uapi}/asm/sigcontext.h  |   0
 arch/arm/include/uapi/asm/signal.h            | 127 ++++++++
 arch/arm/include/{ => uapi}/asm/stat.h        |   0
 arch/arm/include/{ => uapi}/asm/statfs.h      |   0
 arch/arm/include/uapi/asm/swab.h              |  53 +++
 arch/arm/include/uapi/asm/unistd.h            | 450 ++++++++++++++++++++++++++
 24 files changed, 1005 insertions(+), 925 deletions(-)
 rename arch/arm/include/{ => uapi}/asm/a.out.h (100%)
 rename arch/arm/include/{ => uapi}/asm/byteorder.h (100%)
 rename arch/arm/include/{ => uapi}/asm/fcntl.h (100%)
 create mode 100644 arch/arm/include/uapi/asm/hwcap.h
 rename arch/arm/include/{ => uapi}/asm/ioctls.h (100%)
 rename arch/arm/include/{ => uapi}/asm/kvm_para.h (100%)
 rename arch/arm/include/{ => uapi}/asm/mman.h (100%)
 rename arch/arm/include/{ => uapi}/asm/posix_types.h (100%)
 create mode 100644 arch/arm/include/uapi/asm/ptrace.h
 create mode 100644 arch/arm/include/uapi/asm/setup.h
 rename arch/arm/include/{ => uapi}/asm/sigcontext.h (100%)
 create mode 100644 arch/arm/include/uapi/asm/signal.h
 rename arch/arm/include/{ => uapi}/asm/stat.h (100%)
 rename arch/arm/include/{ => uapi}/asm/statfs.h (100%)
 create mode 100644 arch/arm/include/uapi/asm/swab.h
 create mode 100644 arch/arm/include/uapi/asm/unistd.h
.
