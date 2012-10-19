Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340Ab2JSLxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 07:53:13 -0400
Received: from zmc.proxad.net ([212.27.53.206]:53906 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993Ab2JSLxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 07:53:12 -0400
From: Florian Fainelli <ffainelli@freebox.fr>
To: bigeasy@linutronix.de
Cc: linux-kernel@vger.kernel.org, x86@vger.kernel.org, mbizon@freebox.fr,
        Florian Fainelli <ffainelli@freebox.fr>
Subject: [PATCH 0/3] x86: ce4100: various fixes
Date: Fri, 19 Oct 2012 13:51:53 +0200
Message-Id: <1350647516-4842-1-git-send-email-ffainelli@freebox.fr>
X-Mailer: git-send-email 1.7.9.5
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
1.7.9.5

