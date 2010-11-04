Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab0KDFdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 01:33:10 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:34498 "HELO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754176Ab0KDFdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 01:33:06 -0400
X-Greylist: delayed 617 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Nov 2010 01:33:06 EDT
Date: Thu, 4 Nov 2010 15:22:00 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-ID: <201011040522.oA45M09r006758@goober.internal.moreton.com.au>
CC: <gerg@uclinux.org>, <linux-kernel@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>
Subject: [git pull] m68knommu arch fixes
To: <torvalds@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.1)
X-OriginalArrivalTime: 04 Nov 2010 05:22:46.0627 (UTC) FILETIME=[50A80330:01CB7BE0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus-fixes

to get fixes for some rc1 breakage. Two things in there for minor problems
with some of the m68k/m68knommu merged headers.

Thanks
Greg


 
---
The following changes since commit d88c0922fa0e2c021a028b310a641126c6d4b7dc:
  Michel Lespinasse (1):
        Release page reference during page fault retry

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus-fixes

Greg Ungerer (1):
      m68knommu: add back in declaration of do_IRQ

Philippe De Muyter (1):
      m68k, m68knommu: Do not include linux/hardirq.h in asm/irqflags.h

 arch/m68k/include/asm/irqflags.h |    2 ++
 arch/m68k/include/asm/machdep.h  |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)
