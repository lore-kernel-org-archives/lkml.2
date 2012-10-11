Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933782Ab2JKBkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:40:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933369Ab2JKBkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:40:00 -0400
Subject: [GIT PULL] C6X uapi disintegration
From: Mark Salter <msalter@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 10 Oct 2012 21:39:57 -0400
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1349919599.2490.88.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 547b1e81afe3119f7daf702cc03b158495535a25:

  Fix staging driver use of VM_RESERVED (2012-10-09 21:06:41 +0900)

are available in the git repository at:

  git://linux-c6x.org/git/projects/linux-c6x-upstreaming.git tags/for-linus

for you to fetch changes up to fbdd63d76c5ad6ae56a7bd1acebabefafc6aadf0:

  UAPI: (Scripted) Disintegrate arch/c6x/include/asm (2012-10-09 14:56:38 -0400)

----------------------------------------------------------------
C6X UAPI Disintegration

----------------------------------------------------------------
David Howells (1):
      UAPI: (Scripted) Disintegrate arch/c6x/include/asm

 arch/c6x/include/asm/Kbuild                  |    1 -
 arch/c6x/include/asm/ptrace.h                |  146 +-----------------------
 arch/c6x/include/uapi/asm/Kbuild             |    7 +
 arch/c6x/include/{ => uapi}/asm/byteorder.h  |    0
 arch/c6x/include/{ => uapi}/asm/kvm_para.h   |    0
 arch/c6x/include/uapi/asm/ptrace.h           |  163 ++++++++++++++++++++++++++
 arch/c6x/include/{ => uapi}/asm/setup.h      |    0
 arch/c6x/include/{ => uapi}/asm/sigcontext.h |    0
 arch/c6x/include/{ => uapi}/asm/swab.h       |    0
 arch/c6x/include/{ => uapi}/asm/unistd.h     |    0
 10 files changed, 171 insertions(+), 146 deletions(-)
 rename arch/c6x/include/{ => uapi}/asm/byteorder.h (100%)
 rename arch/c6x/include/{ => uapi}/asm/kvm_para.h (100%)
 create mode 100644 arch/c6x/include/uapi/asm/ptrace.h
 rename arch/c6x/include/{ => uapi}/asm/setup.h (100%)
 rename arch/c6x/include/{ => uapi}/asm/sigcontext.h (100%)
 rename arch/c6x/include/{ => uapi}/asm/swab.h (100%)
 rename arch/c6x/include/{ => uapi}/asm/unistd.h (100%)


