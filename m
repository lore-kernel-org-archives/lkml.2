Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab2JIJQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:16:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854Ab2JIJPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:15:51 -0400
From: David Howells <dhowells@redhat.com>
To: jonas@southpole.se
Cc: dhowells@redhat.com, linux@openrisc.net, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for openrisc [ver #2]
Date: Tue, 09 Oct 2012 10:15:43 +0100
Message-ID: <21156.1349774143@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the openrisc tree please.

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


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-openrisc-20121009

for you to fetch changes up to 913c230200ceea66dda3fda325af8365b3fdc670:

  UAPI: (Scripted) Disintegrate arch/openrisc/include/asm (2012-10-09 09:47:18 +0100)

----------------------------------------------------------------
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate arch/openrisc/include/asm

 arch/openrisc/include/asm/Kbuild                  |  2 -
 arch/openrisc/include/asm/elf.h                   | 51 +----------------
 arch/openrisc/include/asm/ptrace.h                | 17 +-----
 arch/openrisc/include/uapi/asm/Kbuild             |  7 +++
 arch/openrisc/include/{ => uapi}/asm/byteorder.h  |  0
 arch/openrisc/include/uapi/asm/elf.h              | 69 +++++++++++++++++++++++
 arch/openrisc/include/{ => uapi}/asm/kvm_para.h   |  0
 arch/openrisc/include/{ => uapi}/asm/param.h      |  0
 arch/openrisc/include/uapi/asm/ptrace.h           | 35 ++++++++++++
 arch/openrisc/include/{ => uapi}/asm/sigcontext.h |  0
 arch/openrisc/include/{ => uapi}/asm/unistd.h     |  0
 11 files changed, 113 insertions(+), 68 deletions(-)
 rename arch/openrisc/include/{ => uapi}/asm/byteorder.h (100%)
 create mode 100644 arch/openrisc/include/uapi/asm/elf.h
 rename arch/openrisc/include/{ => uapi}/asm/kvm_para.h (100%)
 rename arch/openrisc/include/{ => uapi}/asm/param.h (100%)
 create mode 100644 arch/openrisc/include/uapi/asm/ptrace.h
 rename arch/openrisc/include/{ => uapi}/asm/sigcontext.h (100%)
 rename arch/openrisc/include/{ => uapi}/asm/unistd.h (100%)
.
