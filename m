Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759112Ab2J2Nmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 09:42:32 -0400
Received: from zmc.proxad.net ([212.27.53.206]:41643 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757344Ab2J2Nlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 09:41:46 -0400
From: Florian Fainelli <ffainelli@freebox.fr>
To: tglx@linutronix.de
Cc: mingo@redhat.com, x86@kernel.org, rui.zhang@intel.com,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Florian Fainelli <ffainelli@freebox.fr>
Subject: [PATCH 0/3 v3] x86: ce4100 fixes and improvements
Date: Mon, 29 Oct 2012 14:40:17 +0100
Message-Id: <1351518020-25556-1-git-send-email-ffainelli@freebox.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1351251054-19892-1-git-send-email-ffainelli@freebox.fr>
References: <1351251054-19892-1-git-send-email-ffainelli@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This patch serie contains shutdown/reboot fixes for the CE4100 platform as
well as a PCI controller fix for devices without an interrupt line.

Changes since v2:
- added Sebastian's Acked-by
- added Maxime's missing Signed-off-by

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

