Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab1JYHDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:03:37 -0400
Received: from mail.anarazel.de ([217.115.131.40]:56378 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092Ab1JYHDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:03:36 -0400
From: Andres Freund <andres@anarazel.de>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [GIT PULL] sound fix for 3.1
Date: Tue, 25 Oct 2011 09:02:46 +0200
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc10-andres-00050-g7d802d7; KDE/4.6.5; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <s5hmxdjscs8.wl%tiwai@suse.de>
In-Reply-To: <s5hmxdjscs8.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110250902.47120.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday, October 02, 2011 04:12:23 PM Takashi Iwai wrote:
> The only commit to pull is 798cb7e897210dbf827f69a302c0967e0380ebac,
> a fix for a regression introduced in 3.1-rc.
Unfortunately that fix causes problems in audio playback for me. The audio 
seems to play faster and have rather large skips.

Reverting that commit ontop of v3.1-rc10-2-gfb630b9 fixes that problem for me.

05:00.0 Audio device: Creative Labs [SB X-Fi Xtreme Audio] CA0110-IBG
        Subsystem: Creative Labs SB1040
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (500ns min, 5000ns max)
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fb9fc000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: [dc] Power Management version 3
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: snd_hda_intel

Anything more you need?

Greetings, 

Andres
