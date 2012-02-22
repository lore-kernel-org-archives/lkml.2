Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab2BVMFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 07:05:54 -0500
Received: from sncsmrelay2.nai.com ([67.97.80.206]:56430 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab2BVMFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 07:05:53 -0500
Date: Wed, 22 Feb 2012 22:01:31 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-ID: <201202221201.q1MC1VKc010940@goober.corp.nai.org>
CC: <gerg@uclinux.org>, <linux-kernel@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>, <uclinux-dev@uclinux.org>,
        <geert@linux-m68k.org>
Subject: [git pull] m68k: coldfire machine fixes for 3.3
To: <torvalds@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Can you please pull from the m68knommu git tree, for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

It contains 3 important fixes for ColdFire based machines:
. fix processes getting stuck when running from strace
. fix kernel vmalloced pages not being visible in all kernel contexts
. fix shared user pages sometimes being visible in another process context

Thanks
Greg



The following changes since commit 62aa2b537c6f5957afd98e29f96897419ed5ebab:
  Linus Torvalds (1):
        Linux 3.3-rc2

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

Alexander Stein (2):
      m68k: Add shared bit to Coldfire kernel page entries
      m68k: Do not set global share for non-kernel shared pages

Greg Ungerer (1):
      m68knommu: fix syscall tracing stuck process

 arch/m68k/include/asm/mcf_pgtable.h |    3 ++-
 arch/m68k/mm/mcfmmu.c               |    9 +++++----
 arch/m68k/platform/coldfire/entry.S |    4 +---
 3 files changed, 8 insertions(+), 8 deletions(-)
