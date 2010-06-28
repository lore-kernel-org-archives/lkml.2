Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab0F1Nk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 09:40:29 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:54237 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754825Ab0F1Nk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 09:40:28 -0400
Date: Mon, 28 Jun 2010 15:40:26 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Removing dead code
Message-ID: <cover.1277731915.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

        As part of the VAMOS[0] research project at the University of
Erlangen we are looking at multiple integrity errors in linux'
configuration system.

	I've been running a check on the arch/ia64 sourcetree for
config Items not defined in Kconfig and found 2 such cases. Sourcecode
blocks depending on these Items are not reachable from a vanilla
kernel -- dead code. I've seen such dead blocks made on purpose
e.g. while integrating new features into the kernel but generally
they're just useless.

	Each of the patches in this patchset removes on such dead
config Item, I'd be glad if you consider applying them. I've been
doing deeper analysis of such issues before and can do so again but
I'm not so sure they were fastly usefull.

        Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

        Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/

Christoph Egger (2):
  Removing dead CONFIG_PARAVIRT_GUEST_ASM_CLOBBER_CHECK
  Removing dead CONFIG_IOMMU_DEBUG

 arch/ia64/include/asm/native/inst.h |   96 ++++++++--------------------------
 arch/ia64/kernel/pci-dma.c          |    4 --
 2 files changed, 23 insertions(+), 77 deletions(-)

