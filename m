Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762869Ab2KBRRo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:17:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760873Ab2KBRRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:17:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@osdl.org
cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [GIT PULL] FRV fixes
Date: Fri, 02 Nov 2012 17:17:37 +0000
Message-ID: <22792.1351876657@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Can you pull these patches for FRV please?  They're a collection of small
fixes for the FRV architecture.

David
---
The following changes since commit 8c23f406c6d86808726ace580657186bc3b44587:

  Merge git://git.kernel.org/pub/scm/virt/kvm/kvm (2012-11-01 08:27:02 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-frv.git tags/frv-fixes-20121102

for you to fetch changes up to 1d72d9f83df057e71c7951def41138a0230bf737:

  frv: fix the broken preempt (2012-11-02 12:08:25 -0400)

----------------------------------------------------------------
FRV fixes for 3.7

----------------------------------------------------------------
Al Viro (2):
      frv: switch to saner kernel_execve() semantics
      frv: fix the broken preempt

David Howells (5):
      FRV: Add missing linux/export.h #inclusions
      FRV: Don't objcopy the GNU build_id note
      FRV: gcc-4.1.2 also inlines weak functions
      FRV: Fix the preemption handling
      FRV: Fix the new-style kernel_thread() stuff

 arch/frv/Kconfig                      |  1 +
 arch/frv/boot/Makefile                | 10 ++++++----
 arch/frv/include/asm/unistd.h         |  1 -
 arch/frv/kernel/entry.S               | 28 +++-------------------------
 arch/frv/kernel/process.c             |  5 +++--
 arch/frv/mb93090-mb00/pci-dma-nommu.c |  1 +
 init/main.c                           |  2 ++
 7 files changed, 16 insertions(+), 32 deletions(-)
