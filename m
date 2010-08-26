Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab0HZGqO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 02:46:14 -0400
Received: from toccata.ens-lyon.fr ([140.77.166.68]:50996 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab0HZGqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 02:46:12 -0400
Date: Thu, 26 Aug 2010 08:45:49 +0200
From: Sebastien Hinderer <Sebastien.Hinderer@ens-lyon.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Samuel Thibault <Samuel.Thibault@ens-lyon.org>,
        Andreas Mohr <andi@lisas.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: EuroBraille/Iris power off
Message-ID: <20100826064549.GA3353@pema>
References: <20100825094925.GA3632@pema>
 <20100825161214.GA15087@rhlx01.hs-esslingen.de>
 <20100825211257.GA636@pema>
 <4C7588FB.4050001@zytor.com>
 <20100825225036.GV4762@const.famille.thibault.fr>
 <4C75AFFC.5090601@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C75AFFC.5090601@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> What other forms of enumerable hardware is on this machine?  PCI?

Yes, just PCI I think.

Below is the output of lspci -v if that helps.

Best wishes,
Shérab.

00:00.0 Host bridge: Cyrix Corporation PCI Master
	Flags: bus master, medium devsel, latency 0

00:02.0 Ethernet controller: Davicom Semiconductor, Inc. 21x4x DEC-Tulip compatible 10/100 Ethernet (rev 40)
	Subsystem: Davicom Semiconductor, Inc. DM9102A (DM9102AE, SM9102AF) Ethernet 100/10 MBit
	Flags: bus master, medium devsel, latency 165, IRQ 11
	I/O ports at 1000 [size=256]
	Memory at fedfe000 (32-bit, non-prefetchable) [size=256]
	[virtual] Expansion ROM at 08000000 [disabled] [size=256K]
	Capabilities: [50] Power Management version 2
	Kernel driver in use: dmfe

00:12.0 ISA bridge: Cyrix Corporation 5530 Legacy [Kahlua] (rev 30)
	Flags: bus master, medium devsel, latency 64

00:12.1 Bridge: Cyrix Corporation 5530 SMI [Kahlua]
	Flags: medium devsel
	Memory at 40012000 (32-bit, non-prefetchable) [size=256]

00:12.2 IDE interface: Cyrix Corporation 5530 IDE [Kahlua] (prog-if 80 [Master])
	Flags: bus master, medium devsel, latency 0
	[virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
	[virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
	[virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
	[virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
	I/O ports at 1400 [size=16]
	Kernel driver in use: CS5530 IDE

00:12.3 Multimedia audio controller: Cyrix Corporation 5530 Audio [Kahlua]
	Flags: bus master, medium devsel, latency 0
	Memory at 40011000 (32-bit, non-prefetchable) [size=128]
	Kernel driver in use: CS5530_Audio

00:12.4 VGA compatible controller: Cyrix Corporation 5530 Video [Kahlua] (prog-if 00 [VGA controller])
	Subsystem: Cyrix Corporation Device 0001
	Flags: medium devsel
	Memory at 40800000 (32-bit, non-prefetchable) [size=8M]
	Expansion ROM at <unassigned> [disabled]

00:13.0 USB Controller: Compaq Computer Corporation ZFMicro Chipset USB (rev 06) (prog-if 10 [OHCI])
	Subsystem: Compaq Computer Corporation ZFMicro Chipset USB
	Flags: bus master, medium devsel, latency 64, IRQ 9
	Memory at fedff000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

