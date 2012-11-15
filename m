Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993054Ab2KOJkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 04:40:23 -0500
Received: from mail.windriver.com ([147.11.1.11]:48102 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992490Ab2KOJkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 04:40:18 -0500
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/6] powerpc/book3e: support kexec and kdump
Date: Thu, 15 Nov 2012 17:39:50 +0800
Message-ID: <1352972396-13489-1-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is used to support kexec and kdump on book3e.

Tested on fsl-p5040 DS.

Tiejun Chen (6):
      powerpc/book3e: support CONFIG_RELOCATABLE
      book3e/kexec/kdump: enable kexec for kernel
      book3e/kexec/kdump: create a 1:1 TLB mapping
      book3e/kexec/kdump: introduce a kexec kernel flag
      book3e/kexec/kdump: skip ppc32 kexec specfic
      book3e/kexec/kdump: redefine VIRT_PHYS_OFFSET

 arch/powerpc/Kconfig                     |    2 +-
 arch/powerpc/include/asm/exception-64e.h |    8 ++++
 arch/powerpc/include/asm/page.h          |    2 +
 arch/powerpc/include/asm/smp.h           |    3 ++
 arch/powerpc/kernel/exceptions-64e.S     |   15 ++++++-
 arch/powerpc/kernel/head_64.S            |   43 +++++++++++++++++--
 arch/powerpc/kernel/machine_kexec_64.c   |    6 +++
 arch/powerpc/kernel/misc_64.S            |   67 +++++++++++++++++++++++++++++-
 arch/powerpc/lib/feature-fixups.c        |    7 ++++
 arch/powerpc/platforms/85xx/smp.c        |   26 ++++++++++++
 10 files changed, 173 insertions(+), 6 deletions(-)

Tiejun
