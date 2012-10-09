Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab2JIJUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:20:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab2JIJPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:15:30 -0400
From: David Howells <dhowells@redhat.com>
To: rkuo@codeaurora.org
Cc: dhowells@redhat.com, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Disintegrate UAPI for hexagon [ver #2]
Date: Tue, 09 Oct 2012 10:15:27 +0100
Message-ID: <21134.1349774127@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you merge the following branch into the hexagon tree please.

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


  git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-hexagon-20121009

for you to fetch changes up to 044819a598469f603df5cfc8abfed766c9a9444a:

  UAPI: (Scripted) Disintegrate arch/hexagon/include/asm (2012-10-09 09:46:55 +0100)

----------------------------------------------------------------
UAPI Disintegration 2012-10-09

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate arch/hexagon/include/asm

 arch/hexagon/include/asm/Kbuild                   |  3 ---
 arch/hexagon/include/uapi/asm/Kbuild              | 12 ++++++++++++
 arch/hexagon/include/{ => uapi}/asm/bitsperlong.h |  0
 arch/hexagon/include/{ => uapi}/asm/byteorder.h   |  0
 arch/hexagon/include/{ => uapi}/asm/kvm_para.h    |  0
 arch/hexagon/include/{ => uapi}/asm/param.h       |  0
 arch/hexagon/include/{ => uapi}/asm/ptrace.h      |  0
 arch/hexagon/include/{ => uapi}/asm/registers.h   |  0
 arch/hexagon/include/{ => uapi}/asm/setup.h       |  0
 arch/hexagon/include/{ => uapi}/asm/sigcontext.h  |  0
 arch/hexagon/include/{ => uapi}/asm/signal.h      |  0
 arch/hexagon/include/{ => uapi}/asm/swab.h        |  0
 arch/hexagon/include/{ => uapi}/asm/unistd.h      |  0
 arch/hexagon/include/{ => uapi}/asm/user.h        |  0
 14 files changed, 12 insertions(+), 3 deletions(-)
 rename arch/hexagon/include/{ => uapi}/asm/bitsperlong.h (100%)
 rename arch/hexagon/include/{ => uapi}/asm/byteorder.h (100%)
 rename arch/hexagon/include/{ => uapi}/asm/kvm_para.h (100%)
 rename arch/hexagon/include/{ => uapi}/asm/param.h (100%)
 rename arch/hexagon/include/{ => uapi}/asm/ptrace.h (100%)
 rename arch/hexagon/include/{ => uapi}/asm/registers.h (100%)
 rename arch/hexagon/include/{ => uapi}/asm/setup.h (100%)
 rename arch/hexagon/include/{ => uapi}/asm/sigcontext.h (100%)
 rename arch/hexagon/include/{ => uapi}/asm/signal.h (100%)
 rename arch/hexagon/include/{ => uapi}/asm/swab.h (100%)
 rename arch/hexagon/include/{ => uapi}/asm/unistd.h (100%)
 rename arch/hexagon/include/{ => uapi}/asm/user.h (100%)
.
