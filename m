Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab3AIHDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 02:03:19 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:38996 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756971Ab3AIHDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 02:03:17 -0500
MIME-Version: 1.0
In-Reply-To: <1357703565.7140.217.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
References: <CAMXyS3Mvc8SkJxu4fCcUn+XpNcHrzEQ=M5w2eenVr-YKwa3AEQ@mail.gmail.com>
	<CAMXyS3MRx3D__60xtt4G4CCyHSTW2iHd1x1AR1LCQkrZrOiJ2g@mail.gmail.com>
	<CAD9gYJL1GjZtPuEWozmgM37NzhJeAO1Oe69Tnzxi5bCPMijmcA@mail.gmail.com>
	<1357703565.7140.217.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
Date: Wed, 9 Jan 2013 08:03:17 +0100
Message-ID: <CAMXyS3PhStKo_xeiTRH+kbZXNUcwmMvrvTHrDOR-6qkuUCVH2A@mail.gmail.com>
Subject: Re: tg3 v3.123 in 100Mbps Full-Duplex mode with autoneg off
From: Marcin Miotk <marcinmiotk81@gmail.com>
To: Michael Chan <mchan@broadcom.com>
Cc: =?UTF-8?B?546L6YeR5rWm?= <jinpuwang@gmail.com>,
        Matt Carlson <mcarlson@broadcom.com>, Benjamin Li <benli@broadcom.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lspci output:

00:00.0 Host bridge: Intel Corporation 3200/3210 Chipset DRAM
Controller (rev 01)
00:01.0 PCI bridge: Intel Corporation 3200/3210 Chipset Host-Primary
PCI Express Bridge (rev 01)
00:06.0 PCI bridge: Intel Corporation 3210 Chipset Host-Secondary PCI
Express Bridge (rev 01)
00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 1 (rev 02)
00:1c.2 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 3 (rev 02)
00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 4 (rev 02)
00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 5 (rev 02)
00:1c.5 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 6 (rev 02)
00:1d.0 USB controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #1 (rev 02)
00:1d.1 USB controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #2 (rev 02)
00:1d.2 USB controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #3 (rev 02)
00:1d.3 USB controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #6 (rev 02)
00:1d.7 USB controller: Intel Corporation 82801I (ICH9 Family) USB2
EHCI Controller #1 (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
00:1f.0 ISA bridge: Intel Corporation 82801IR (ICH9R) LPC Interface
Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 4
port SATA Controller [IDE mode] (rev 02)
00:1f.5 IDE interface: Intel Corporation 82801I (ICH9 Family) 2 port
SATA Controller [IDE mode] (rev 02)
01:02.0 VGA compatible controller: Advanced Micro Devices [AMD] nee
ATI ES1000 (rev 02)
01:04.0 System peripheral: Compaq Computer Corporation Integrated
Lights Out Controller (rev 03)
01:04.2 System peripheral: Compaq Computer Corporation Integrated
Lights Out  Processor (rev 03)
01:04.4 USB controller: Hewlett-Packard Company Integrated Lights-Out
Standard Virtual USB Controller
01:04.6 IPMI SMIC interface: Hewlett-Packard Company Integrated
Lights-Out Standard KCS Interface
02:00.0 PCI bridge: Broadcom EPB PCI-Express to PCI-X Bridge (rev b5)
03:04.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5715
Gigabit Ethernet (rev a3)
03:04.1 Ethernet controller: Broadcom Corporation NetXtreme BCM5715
Gigabit Ethernet (rev a3)
15:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection

Regards,
Marcin
