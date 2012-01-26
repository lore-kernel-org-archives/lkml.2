Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab2AZVmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:42:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40427 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab2AZVmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:42:09 -0500
Date: Thu, 26 Jan 2012 13:41:55 -0800
From: tip-bot for Mika Westerberg <mika.westerberg@linux.intel.com>
Message-ID: <tip-7hp1otk4wf4mg5pqohcwt06w@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, mika.westerberg@linux.intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, mika.westerberg@linux.intel.com,
        tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/config:
  Select MSIC MFD driver on Intel Medfield platform
Git-Commit-ID: 15a713df4145ad2540f8d84c3f4de930806f6151
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jan 2012 13:42:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  15a713df4145ad2540f8d84c3f4de930806f6151
Gitweb:     http://git.kernel.org/tip/15a713df4145ad2540f8d84c3f4de930806f6151
Author:     Mika Westerberg <mika.westerberg@linux.intel.com>
AuthorDate: Thu, 26 Jan 2012 17:35:05 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Jan 2012 21:23:55 +0100

x86/config: Select MSIC MFD driver on Intel Medfield platform

On Intel Medfield platform we use MSIC MFD driver to create
necessary platform devices so it is essential to have the driver
compiled into the kernel.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: jacob.jun.pan@linux.intel.com
Link: http://lkml.kernel.org/n/tip-7hp1otk4wf4mg5pqohcwt06w@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a13addb..c0d4931 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -431,6 +431,7 @@ config X86_MDFLD
 	select SPI
 	select INTEL_SCU_IPC
 	select X86_PLATFORM_DEVICES
+	select MFD_INTEL_MSIC
 	---help---
 	  Medfield is Intel's Low Power Intel Architecture (LPIA) based Moblin
 	  Internet Device(MID) platform. 
