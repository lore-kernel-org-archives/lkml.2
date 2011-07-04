Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab1GDK0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 06:26:39 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53418 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab1GDK0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 06:26:36 -0400
Date: Mon, 4 Jul 2011 03:26:29 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALSA: hda-intel - add position_fix quirk for Gateway
 NV53A
Message-ID: <20110704102628.GF3723@core.coreip.homeip.net>
References: <20110629195509.GA18895@core.coreip.homeip.net>
 <s5hd3hvsx79.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hd3hvsx79.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 07:30:18AM +0200, Takashi Iwai wrote:
> At Wed, 29 Jun 2011 12:55:10 -0700,
> Dmitry Torokhov wrote:
> > 
> > Without this option internal microphone does not seem to be working.
> > 
> > $ lspci -vvnn | grep -A10 Audio
> > 00:14.2 Audio device [0403]: ATI Technologies Inc SBx00 Azalia (Intel HDA) [1002:4383] (rev 40)
> > 	Subsystem: Acer Incorporated [ALI] Device [1025:036e]
> > 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> > 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 	Latency: 64, Cache Line Size: 64 bytes
> > 	Interrupt: pin ? routed to IRQ 16
> > 	Region 0: Memory at d2300000 (64-bit, non-prefetchable) [size=16K]
> > 	Capabilities: [50] Power Management version 2
> > 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> > 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> > 	Kernel driver in use: HDA Intel
> > --
> > 01:05.1 Audio device [0403]: ATI Technologies Inc RS880 Audio Device [Radeon HD 4200] [1002:970f]
> > 	Subsystem: Acer Incorporated [ALI] Device [1025:036e]
> > 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> > 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 	Latency: 0, Cache Line Size: 64 bytes
> > 	Interrupt: pin B routed to IRQ 19
> > 	Region 0: Memory at d2210000 (32-bit, non-prefetchable) [size=16K]
> > 	Capabilities: [50] Power Management version 3
> > 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> > 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> > 	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
> > 
> > Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> 
> Is it with the latest 3.0 kernel?  We fixed recently the default
> posfix value to LPIB for ATI/AMD controllers.

Ah, I see. No, that was with an older kernel. Unfortunately I do not
have access to the box anymore so won't be able to test 3.0 ;(

Thanks.

-- 
Dmitry
