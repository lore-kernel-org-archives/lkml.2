Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab2BVWOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 17:14:30 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:65327 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817Ab2BVWO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 17:14:29 -0500
Date: Wed, 22 Feb 2012 23:13:57 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH V3 0/3] STA2X11: patches for pci bridge support
Message-ID: <cover.1329947637.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is V3 of what I sent on Jan 30th as V2.

Patch 3 is dependent on patch 1 and 2, which are unordered.  When I
posted V2 of this set, patch 3 was picked up, but compilation failed
because of the missing prerequisites. Also, some prototypes changed
in the meanwhile and patch 3 was miscompiling in linux-next so it
has been correctly dropped.

V3: rebased on next-20120221. Fixed patch 3 to match new DMA
prototypes. Renamed patch 3 as Ingo and Jesse merged it. Added both of
them to explicit Cc: list in the email set.

V2: rebased, minor and less-minor changes in patch 3/3.

Alessandro Rubini (3):
  x86: introduce CONFIG_X86_DEV_DMA_OPS
  x86: introduce CONFIG_X86_DMA_REMAP
  x86/PCI: initial support for sta2x11 I/O hub

 arch/x86/Kconfig                   |   34 +++-
 arch/x86/include/asm/device.h      |    4 +-
 arch/x86/include/asm/dma-mapping.h |    9 +-
 arch/x86/pci/Makefile              |    2 +
 arch/x86/pci/sta2x11-fixup.c       |  367 ++++++++++++++++++++++++++++++++++++
 5 files changed, 409 insertions(+), 7 deletions(-)
 create mode 100644 arch/x86/pci/sta2x11-fixup.c

-- 
1.7.7.2
