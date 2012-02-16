Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab2BPNAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:00:43 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:62308 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab2BPNAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:00:42 -0500
Date: Thu, 16 Feb 2012 14:00:28 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: giancarlo.asnaghi@st.com, alan@linux.intel.com, sameo@linux.intel.com,
        grant.likely@secretlab.ca, linus.walleij@stericsson.com
Subject: [PATCH V2 0/2] MFD and GPIO for STA2X11
Message-ID: <cover.1329396583.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches introduce the multi-function device and GPIO support for
the STA2X11 I/O Hub.  Core PCI support is already in linux-next.

I sent version 1 on Jan 26th as RFC and got no comments back. This new
pair fixes a number of minor details and is rebased to the new
linux-next.

This time I Cc'd both patches to all interested parties, (last time
MFD people only got MFD and GPIO people only got GPIO), because the
relative order must be preserved.

Alessandro Rubini (2):
  mfd: Add driver for STA2X11 MFD block
  gpio: add STA2X11 GPIO block

 arch/x86/include/asm/sta2x11.h  |   12 +
 drivers/gpio/Kconfig            |    9 +
 drivers/gpio/Makefile           |    1 +
 drivers/gpio/gpio-sta2x11.c     |  443 ++++++++++++++++++++++++++++++++++++
 drivers/mfd/Kconfig             |    6 +
 drivers/mfd/Makefile            |    1 +
 drivers/mfd/sta2x11-mfd.c       |  470 +++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/sta2x11-mfd.h |  324 +++++++++++++++++++++++++++
 8 files changed, 1266 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/sta2x11.h
 create mode 100644 drivers/gpio/gpio-sta2x11.c
 create mode 100644 drivers/mfd/sta2x11-mfd.c
 create mode 100644 include/linux/mfd/sta2x11-mfd.h

-- 
1.7.7.2
