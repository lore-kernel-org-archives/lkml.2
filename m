Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab0HZJ3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 05:29:43 -0400
Received: from toccata.ens-lyon.org ([140.77.166.68]:35613 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab0HZJ3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 05:29:40 -0400
Date: Thu, 26 Aug 2010 11:29:12 +0200
From: Sebastien Hinderer <Sebastien.Hinderer@ens-lyon.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Samuel Thibault <Samuel.Thibault@ens-lyon.org>,
        Andreas Mohr <andi@lisas.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: EuroBraille/Iris power off
Message-ID: <20100826092912.GA3336@pema>
References: <20100825094925.GA3632@pema>
 <20100825161214.GA15087@rhlx01.hs-esslingen.de>
 <20100825211257.GA636@pema>
 <4C7588FB.4050001@zytor.com>
 <20100825225036.GV4762@const.famille.thibault.fr>
 <4C75AFFC.5090601@zytor.com>
 <20100826064549.GA3353@pema>
 <4C760FEE.1000309@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C760FEE.1000309@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

H. Peter Anvin (2010/08/25 23:55 -0700):
> > 00:00.0 Host bridge: Cyrix Corporation PCI Master
> > 	Flags: bus master, medium devsel, latency 0
> > 
> 
> Good grief ... these clowns didn't even program the subsystem ID?  Could
> you verify with lspci -vv -n?

It's included below.

Shérab.

00:00.0 0600: 1078:0001
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:02.0 0200: 1282:9102 (rev 40)
	Subsystem: 0291:8212
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 165 (5000ns min, 10000ns max)
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at 1000 [size=256]
	Region 1: Memory at fedfe000 (32-bit, non-prefetchable) [size=256]
	[virtual] Expansion ROM at 08000000 [disabled] [size=256K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=160mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: dmfe

00:12.0 0601: 1078:0100 (rev 30)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 16 bytes

00:12.1 0680: 1078:0101
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Region 0: Memory at 40012000 (32-bit, non-prefetchable) [size=256]

00:12.2 0101: 1078:0102 (prog-if 80 [Master])
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
	Region 4: I/O ports at 1400 [size=16]
	Kernel driver in use: CS5530 IDE

00:12.3 0401: 1078:0103
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: Memory at 40011000 (32-bit, non-prefetchable) [size=128]
	Kernel driver in use: CS5530_Audio

00:12.4 0300: 1078:0104 (prog-if 00 [VGA controller])
	Subsystem: 1078:0001
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Region 0: Memory at 40800000 (32-bit, non-prefetchable) [size=8M]
	Expansion ROM at <unassigned> [disabled]

00:13.0 0c03: 0e11:a0f8 (rev 06) (prog-if 10 [OHCI])
	Subsystem: 0e11:a0f8
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (20000ns max)
	Interrupt: pin A routed to IRQ 9
	Region 0: Memory at fedff000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

