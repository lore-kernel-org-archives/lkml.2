Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760818Ab0HLTPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 15:15:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754452Ab0HLTPo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 15:15:44 -0400
MIME-Version: 1.0
In-Reply-To: <s5hlj8dwrd7.wl%tiwai@suse.de>
References: <s5hlj8dwrd7.wl%tiwai@suse.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Aug 2010 12:15:17 -0700
Message-ID: <AANLkTi=2N_P=zAM73a=dOBX6w0OzsgJi3TqRDu0LyZtB@mail.gmail.com>
Subject: Re: [GIT PULL] sound update (#2) for 2.6.36
To: Takashi Iwai <tiwai@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 12:17 AM, Takashi Iwai <tiwai@suse.de> wrote:
>
> please pull sound updates for v2.6.36 from:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git for-linus
>
> Most of patches are trivial fixes.  A few of them are just to add the
> missing device ids.  One behavior change is the sticky stream setup for
> HD-audio, which is good especially for digital receivers.

Hmm. I seem to have lost sound lately. I'm not sure the problem came
in with this pull (it might have been the previous one - I don't do
that much audio, so I might have missed it before too).

Any ideas?

                    Linus
---
  HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
  HDA Intel 0000:00:1b.0: irq 58 for MSI/MSI-X
  HDA Intel 0000:00:1b.0: setting latency timer to 64
  hda_codec: ALC889: BIOS auto-probing.
  ALSA device list:
    #0: HDA Intel at 0xfb9f4000 irq 58


00:1b.0 Audio device: Intel Corporation Ibex Peak High Definition Audio (rev 06)
	Subsystem: ASUSTeK Computer Inc. Device 840f
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 58
	Region 0: Memory at fb9f4000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: HDA Intel
00: 86 80 56 3b 06 05 10 00 06 00 03 04 08 00 00 00
10: 04 40 9f fb 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 0f 84
30: 00 00 00 00 50 00 00 00 00 00 00 00 03 01 00 00
