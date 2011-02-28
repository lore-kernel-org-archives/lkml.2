Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab1B1Uwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 15:52:30 -0500
Received: from mxout1.idt.com ([157.165.5.25]:58632 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab1B1Uw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 15:52:29 -0500
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Thomas Moll <thomas.moll@sysgo.com>,
        Micha Nelissen <micha@neli.hopto.org>
Subject: [PATCH 0/5] RapidIO: configuration and initialization changes 
Date: Mon, 28 Feb 2011 15:51:00 -0500
Message-Id: <1298926265-5381-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This set of patches eliminates RapidIO dependency on PowerPC architecture and
makes it available to other architectures (x86 and MIPS).
It also enables support of new platform independent RapidIO controllers such
as PCI-to-SRIO and PCI Express-to-SRIO.

Alexandre Bounine (5):
  RapidIO: Add architecture specific callbacks
  RapidIO: Modify configuration to support PCI-SRIO controller
  RapidIO: Modify subsystem and driver initialization sequence
  RapidIO: Modify mport ID assignment
  RapidIO: remove mport resource reservation from common RIO code

 arch/mips/Kconfig             |   10 ++++
 arch/powerpc/Kconfig          |   10 ++++-
 arch/powerpc/sysdev/Makefile  |    2 +-
 arch/powerpc/sysdev/fsl_rio.c |   96 ++++++++++++++++-------------------------
 arch/x86/Kconfig              |   10 ++++
 drivers/net/rionet.c          |    6 +-
 drivers/rapidio/rio-sysfs.c   |    1 +
 drivers/rapidio/rio.c         |   84 ++++++++++++++++++++++++-----------
 include/linux/rio.h           |   25 ++++++++---
 include/linux/rio_drv.h       |    7 ++-
 10 files changed, 151 insertions(+), 100 deletions(-)

-- 
1.7.3.1

