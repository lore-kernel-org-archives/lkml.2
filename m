Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab1KPK4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 05:56:10 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38316 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569Ab1KPK4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 05:56:08 -0500
From: Rene Bolldorf <xsecute@googlemail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Rene Bolldorf <xsecute@googlemail.com>
Subject: [PATCH 0/2] Summary
Date: Wed, 16 Nov 2011 11:55:38 +0100
Message-Id: <1321440940-20246-1-git-send-email-xsecute@googlemail.com>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this patchset adds initial PCI support for 724x Atheros SoCs and initial support for the Ubiquiti Networks XM board (Nanostation Mx, Nanobridge Mx, etc.).

Best Regards

Rene Bolldorf (2):
  Initial PCI support for Atheros 724x SoCs.
  Initial support for the Ubiquiti Networks XM board.

 arch/mips/ath79/Kconfig        |   12 ++++
 arch/mips/ath79/Makefile       |    1 +
 arch/mips/ath79/Platform       |    7 ++-
 arch/mips/ath79/mach-ubnt-xm.c |  110 ++++++++++++++++++++++++++++++++++++++++
 arch/mips/ath79/machtypes.h    |    1 +
 arch/mips/pci/Makefile         |    1 +
 arch/mips/pci/ops-ath724x.c    |  109 +++++++++++++++++++++++++++++++++++++++
 arch/mips/pci/pci-ath724x.c    |   45 ++++++++++++++++
 8 files changed, 283 insertions(+), 3 deletions(-)
 create mode 100644 arch/mips/ath79/mach-ubnt-xm.c
 create mode 100644 arch/mips/pci/ops-ath724x.c
 create mode 100644 arch/mips/pci/pci-ath724x.c

-- 
1.7.7.1

