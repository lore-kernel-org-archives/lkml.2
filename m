Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab2JZJG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:06:58 -0400
Received: from zmc.proxad.net ([212.27.53.206]:36235 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757813Ab2JZJGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:06:54 -0400
From: Florian Fainelli <ffainelli@freebox.fr>
To: tglx@linutronix.de
Cc: mingo@redhat.com, x86@kernel.org, rui.zhang@intel.com,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Florian Fainelli <ffainelli@freebox.fr>
Subject: [PATCH 0/3] x86: ce4100 fixes and improvements
Date: Fri, 26 Oct 2012 11:05:22 +0200
Message-Id: <1351242325-23724-1-git-send-email-ffainelli@freebox.fr>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This patch serie contains shutdown/reboot fixes for the CE4100 platform as
well as a PCI controller fix for devices without an interrupt line.

Florian Fainelli (3):
  x86: ce4100: implement pm_poweroff
  x86: ce4100: force reboot method to be KBD
  x86: ce4100: fixup PCI configuration register access for devices
    without interrupts

 arch/x86/pci/ce4100.c             |   13 +++++++++++++
 arch/x86/platform/ce4100/ce4100.c |   10 ++++++++++
 2 files changed, 23 insertions(+)

-- 
1.7.10.4

