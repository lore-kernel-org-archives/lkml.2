Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab1DTSlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 14:41:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41646 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499Ab1DTSlo (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 20 Apr 2011 14:41:44 -0400
Date: Wed, 20 Apr 2011 14:39:34 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: stefano.stabellini@eu.citrix.com, john.baboval@virtualcomputer.com
Subject: [GIT PULL] (xen) stable/bug-fixes-rc4 for 2.6.39-rc4.
Message-ID: <20110420183934.GA22131@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4DAF28E1.0014:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please git pull

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/bug-fixes-rc4

since git commit f0e615c3cb72b42191b558c130409335812621d8
Linus Torvalds (1)
    Linux 2.6.39-rc4

These are two patches that came about the patch introduced at the beginning
of 2.6.39 ("x86-64, mm: Put early page table high"
4b239f458c229de044d6905c2b0f9fe16ed9e01e). With the two patches, one fixes
booting of Linux with Xen hypervisor on a machine with an "gap" in the E820
right after 3.8GB to 4GB, while the other fixes booting of a 32-bit guest.

There is one more patch that we have been carrying in tree to fix the
regression introduced by "x86-64,mm: Put early page table high" which is not
yet ready - but hopefully will be at the end of the week, which will likely
go through the x86 tree.

Anyhow please pull these two following patches:

Stefano Stabellini (2):
      xen: do not create the extra e820 region at an addr lower than 4G
      xen: mask_rw_pte: do not apply the early_ioremap checks on x86_32

 arch/x86/xen/mmu.c   |   13 +++++++++----
 arch/x86/xen/setup.c |    2 +-
 2 files changed, 10 insertions(+), 5 deletions(-)

