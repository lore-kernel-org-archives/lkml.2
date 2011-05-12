Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567Ab1ELSRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:17:36 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17499 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab1ELSRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:17:35 -0400
Date: Thu, 12 May 2011 14:16:58 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        yinghai@kernel.org
Cc: mingo@elte.hu, jeremy@goop.org, stefano.stabellini@eu.citrix.com,
        hpa@linux.intel.com
Subject: [GIT PULL] (xen) stable/bug-fixes-for-rc7 for 2.6.39-rc7
Message-ID: <20110512181658.GA24799@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090207.4DCC2429.007F:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please git pull:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/bug-fixes-for-rc7

which has patches since git commit 0ee5623f9a6e52df90a78bd21179f8ab370e102e:

Linus Torvalds (1):

    Linux 2.6.39-rc6

It has the patches that we discussed in "Re: Linux 2.6.39-rc7" email thread
and I've put: "H. Peter Anvin <hpa@zytor.com>" on the ones touching the generic code.

Details and explanation are in the mentioned email thread
(http://marc.info/?i=4DC9CD60.6010200@zytor.com). As Peter mentioned I've promised to
drive the work to remove this workaround to get a better fix - so this workaround will
be removed.

Konrad Rzeszutek Wilk (1):
      Revert "xen/mmu: Add workaround "x86-64, mm: Put early page table high""

Sedat Dilek (1):
      x86/mm: Fix section mismatch derived from native_pagetable_reserve()

Stefano Stabellini (1):
      x86,xen: introduce x86_init.mapping.pagetable_reserve

 include/asm/pgtable_types.h |    1 
 include/asm/x86_init.h      |   12 +++
 kernel/x86_init.c           |    4 +
 mm/init.c                   |   24 +++++++
 xen/mmu.c                   |  138 ++++----------------------------------------
 5 files changed, 54 insertions(+), 125 deletions(-)
