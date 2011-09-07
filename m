Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab1IGQrk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:47:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:24151 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610Ab1IGQrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:47:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="46039261"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: alan@linux.intel.com, sameo@linux.intel.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, feng.tang@intel.com,
        jacob.jun.pan@linux.intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 0/3] Intel MSIC MFD driver for Medfield platform
Date: Wed,  7 Sep 2011 16:06:49 +0300
Message-Id: <cover.1315399396.git.mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series adds support for the Intel MSIC (Mixed Signal IC) chip found on
Intel Medfield platforms. The MSIC chip embeds audio codec, ADC, GPIOs etc.

Existing drivers which use plain SCU IPC will continue to work and they can
be converted to the MSIC register interface later on. Any new drivers for
devices in the MSIC should use this interface.

Thanks.

Alan Cox (1):
  x86, mrst: Some drivers need to known when an SCU is available

Mika Westerberg (2):
  mfd: add Intel MSIC driver
  x86, mrst: add platform support for MSIC MFD driver

 arch/x86/include/asm/intel_scu_ipc.h |   22 ++
 arch/x86/platform/mrst/mrst.c        |  174 +++++++++++-
 drivers/mfd/Kconfig                  |    9 +
 drivers/mfd/Makefile                 |    1 +
 drivers/mfd/intel_msic.c             |  501 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/intel_msic.h       |  456 +++++++++++++++++++++++++++++++
 6 files changed, 1149 insertions(+), 14 deletions(-)
 create mode 100644 drivers/mfd/intel_msic.c
 create mode 100644 include/linux/mfd/intel_msic.h

-- 
1.7.5.4

