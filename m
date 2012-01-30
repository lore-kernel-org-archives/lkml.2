Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab2A3QJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 11:09:50 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:63256 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469Ab2A3QJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 11:09:49 -0500
Date: Mon, 30 Jan 2012 17:09:18 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        giancarlo.asnaghi@st.com, alan@linux.intel.com
Subject: [PATCH V2 0/3] STA2X11: patches for pci bridge support
Message-ID: <cover.1327933724.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is V2 of what I sent on Jan 6th. Back then it was 6
patches, 3 of them are now in linux-next. The others are here again.

Patch 3 is dependent on patch 1 and 2, which are unordered.

V2: rebased, minor and less-minor changes in patch 3/3.

I repost because I got no feedback and 3 weeks passed. Also,
today I found errors in my previous patch 4, now 3.

Alessandro Rubini (3):
  x86: introduce CONFIG_X86_DEV_DMA_OPS
  x86: introduce CONFIG_X86_DMA_REMAP
  x86: initial support for sta2x11

 arch/x86/Kconfig                   |   34 +++-
 arch/x86/include/asm/device.h      |    4 +-
 arch/x86/include/asm/dma-mapping.h |    9 +-
 arch/x86/pci/Makefile              |    2 +
 arch/x86/pci/sta2x11-fixup.c       |  365 ++++++++++++++++++++++++++++++++++++
 5 files changed, 407 insertions(+), 7 deletions(-)
 create mode 100644 arch/x86/pci/sta2x11-fixup.c

-- 
1.7.7.2
