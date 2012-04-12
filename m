Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762202Ab2DLIsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 04:48:47 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:63771 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257Ab2DLIsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 04:48:45 -0400
Date: Thu, 12 Apr 2012 10:48:32 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, sameo@linux.intel.com,
        grant.likely@secretlab.ca, linus.walleij@stericsson.com
Subject: [PATCH V3 0/2] MFD and GPIO for STA2X11
Message-ID: <cover.1334219873.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches introduce the multi-function device and GPIO support for
the STA2X11 I/O Hub.  Core PCI support is already in linux-next.

V1: sent on Jan 26th as RFC and got no comments back

V2: sent on Feb 16th, fixed a number of minor details, got comments from
Linus Walleij and Samuel Ortiz.

V3: accepted all suggestions.  I delayed this resending a while because
I hoped the base STA2X11 patches to be accepted, but despite the positive
comments I got on those patches, they are not in linux-next as of today

This set, thus, refers to CONFIG_STA2X11 which is not yet upstream.linux-next.

Like in V2, I Cc'd both patches to all interested parties, because
the MFD patch must be fore the GPIO one, so they're better merged to
the same tree.

Alessandro Rubini (2):
  mfd: Add driver for STA2X11 MFD block
  gpio: add STA2X11 GPIO block

 arch/x86/include/asm/sta2x11.h  |   12 +
 drivers/gpio/Kconfig            |    8 +
 drivers/gpio/Makefile           |    1 +
 drivers/gpio/gpio-sta2x11.c     |  435 ++++++++++++++++++++++++++++++++++++
 drivers/mfd/Kconfig             |    6 +
 drivers/mfd/Makefile            |    1 +
 drivers/mfd/sta2x11-mfd.c       |  467 +++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/sta2x11-mfd.h |  324 +++++++++++++++++++++++++++
 8 files changed, 1254 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/sta2x11.h
 create mode 100644 drivers/gpio/gpio-sta2x11.c
 create mode 100644 drivers/mfd/sta2x11-mfd.c
 create mode 100644 include/linux/mfd/sta2x11-mfd.h

-- 
1.7.7.2
