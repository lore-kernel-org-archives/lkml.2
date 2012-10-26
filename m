Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571Ab2JZLcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 07:32:19 -0400
Received: from zmc.proxad.net ([212.27.53.206]:32850 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758505Ab2JZLcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 07:32:18 -0400
From: Florian Fainelli <ffainelli@freebox.fr>
To: tglx@linutronix.de
Cc: mingo@redhat.com, x86@kernel.org, rui.zhang@intel.com,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Florian Fainelli <ffainelli@freebox.fr>
Subject: [PATCH 0/3 v2] x86: ce4100 fixes and improvements
Date: Fri, 26 Oct 2012 13:30:51 +0200
Message-Id: <1351251054-19892-1-git-send-email-ffainelli@freebox.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1351242325-23724-1-git-send-email-ffainelli@freebox.fr>
References: <1351242325-23724-1-git-send-email-ffainelli@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This patch serie contains shutdown/reboot fixes for the CE4100 platform as
well as a PCI controller fix for devices without an interrupt line.

Changes since v1:
- added more comment to the pm_poweroff and reboot method fixup

Florian Fainelli (3):
  x86: ce4100: implement pm_poweroff
  x86: ce4100: force reboot method to be KBD
  x86: ce4100: fixup PCI configuration register access for devices
    without interrupts

 arch/x86/pci/ce4100.c             |   13 +++++++++++++
 arch/x86/platform/ce4100/ce4100.c |   24 ++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

-- 
1.7.10.4

