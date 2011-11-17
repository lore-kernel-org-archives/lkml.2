Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab1KQODR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 09:03:17 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45372 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345Ab1KQODQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 09:03:16 -0500
From: Rene Bolldorf <xsecute@googlemail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Rene Bolldorf <xsecute@googlemail.com>
Subject: [PATCH 0/2] Summary
Date: Thu, 17 Nov 2011 15:02:55 +0100
Message-Id: <1321538577-548-1-git-send-email-xsecute@googlemail.com>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <CAEWqx59k97AMU6hH0NCC2TMEY2mu8d5ytxO68oEsa=7uvLBA4A@mail.gmail.com>
References: <CAEWqx59k97AMU6hH0NCC2TMEY2mu8d5ytxO68oEsa=7uvLBA4A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is patchset v2 with coding style fixes and code improvements.

Rene Bolldorf (2):
  Initial PCI support for Atheros 724x SoCs. (v2)
  Initial support for the Ubiquiti Networks XM board (rev 1.0). (patch
    v2)

 arch/mips/ath79/Kconfig                        |   11 ++
 arch/mips/ath79/Makefile                       |    1 +
 arch/mips/ath79/mach-ubnt-xm.c                 |  119 ++++++++++++++++
 arch/mips/ath79/machtypes.h                    |    1 +
 arch/mips/include/asm/mach-ath79/pci-ath724x.h |   21 +++
 arch/mips/pci/Makefile                         |    1 +
 arch/mips/pci/pci-ath724x.c                    |  174 ++++++++++++++++++++++++
 7 files changed, 328 insertions(+), 0 deletions(-)
 create mode 100644 arch/mips/ath79/mach-ubnt-xm.c
 create mode 100644 arch/mips/include/asm/mach-ath79/pci-ath724x.h
 create mode 100644 arch/mips/pci/pci-ath724x.c

-- 
1.7.7.1

