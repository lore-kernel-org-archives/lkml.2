Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab2BPKkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 05:40:20 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:61564 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726Ab2BPKkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 05:40:18 -0500
Date: Thu, 16 Feb 2012 11:39:49 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: giancarlo.asnaghi@st.com, alan@linux.intel.com, andrzej.p@samsung.com,
        mingo@elte.hu, jbarnes@virtuousgeek.org
Subject: [PATCH 0/3] STA2X11 fixes for next
Message-ID: <cover.1329387617.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My patch to add sta2x11 initial support has been merged by Ingo Molnar
as commit 60dda96f, with signed-off by Jesse Barnes.  However, it
depended on two config symbols (the patch was 3/3, actually) and
I'm to get the blame for not noting it when Jesse told me he would
merge the 3/3.

Additionally, commit aa04651 by Andrzej Pietrasiewicz changed some
prototypes we use, so stuff is not compiling any more if
CONFIG_STA2X11 is on.

I Cc: all involved parties in all patches.  The commit
messages for the original patches have been reworded to match the fact
that they are going in after sta2x11-fixup.c .  At this point, they
are all bugfix patches.

Alessandro Rubini (3):
  x86/PCI: change sta2x11-fixup to account for commit aa04651
  x86: introduce CONFIG_X86_DEV_DMA_OPS
  x86: introduce CONFIG_X86_DMA_REMAP

 arch/x86/Kconfig                   |   11 +++++++++++
 arch/x86/include/asm/device.h      |    4 ++--
 arch/x86/include/asm/dma-mapping.h |    9 ++++++++-
 arch/x86/pci/sta2x11-fixup.c       |   12 +++++++-----
 4 files changed, 28 insertions(+), 8 deletions(-)

-- 
1.7.7.2
