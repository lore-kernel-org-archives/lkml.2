Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab2JIJP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:15:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392Ab2JIJPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:15:23 -0400
From: David Howells <dhowells@redhat.com>
To: msalter@redhat.com
Cc: dhowells@redhat.com, linux-c6x-dev@linux-c6x.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for c6x [ver #2]
Date: Tue, 09 Oct 2012 10:15:20 +0100
Message-ID: <21119.1349774120@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the c6x tree please.

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


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-c6x-20121009

for you to fetch changes up to 41e3f8a642842a137833de40cec447d35d6a8196:

  UAPI: (Scripted) Disintegrate arch/c6x/include/asm (2012-10-09 09:46:40 +0100)

----------------------------------------------------------------
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate arch/c6x/include/asm

 arch/c6x/include/asm/Kbuild                  |   1 -
 arch/c6x/include/asm/ptrace.h                | 146 +-----------------------
 arch/c6x/include/uapi/asm/Kbuild             |   7 ++
 arch/c6x/include/{ => uapi}/asm/byteorder.h  |   0
 arch/c6x/include/{ => uapi}/asm/kvm_para.h   |   0
 arch/c6x/include/uapi/asm/ptrace.h           | 163 +++++++++++++++++++++++++++
 arch/c6x/include/{ => uapi}/asm/setup.h      |   0
 arch/c6x/include/{ => uapi}/asm/sigcontext.h |   0
 arch/c6x/include/{ => uapi}/asm/swab.h       |   0
 arch/c6x/include/{ => uapi}/asm/unistd.h     |   0
 10 files changed, 171 insertions(+), 146 deletions(-)
 rename arch/c6x/include/{ => uapi}/asm/byteorder.h (100%)
 rename arch/c6x/include/{ => uapi}/asm/kvm_para.h (100%)
 create mode 100644 arch/c6x/include/uapi/asm/ptrace.h
 rename arch/c6x/include/{ => uapi}/asm/setup.h (100%)
 rename arch/c6x/include/{ => uapi}/asm/sigcontext.h (100%)
 rename arch/c6x/include/{ => uapi}/asm/swab.h (100%)
 rename arch/c6x/include/{ => uapi}/asm/unistd.h (100%)
.
