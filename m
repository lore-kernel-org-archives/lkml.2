Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab1KBXci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 19:32:38 -0400
Received: from avasout04.plus.net ([212.159.14.19]:33270 "EHLO
	avasout04.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab1KBXcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 19:32:35 -0400
X-CM-Score: 0.00
X-CNFS-Analysis: v=2.0 cv=PPKNCIWC c=1 sm=1 a=F8hxLa1Qgym6LBeQ3hiSHg==:17
 a=9GetC4Mfny8A:10 a=kj9zAlcOel0A:10 a=qInULYxRQa4Pb5VE604A:9
 a=CjuIK1q_8ugA:10 a=0kPLrQdw3YYA:10 a=F8hxLa1Qgym6LBeQ3hiSHg==:117
Date: Wed, 2 Nov 2011 23:32:33 +0000
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: Takashi Iwai <tiwai@suse.de>
Cc: Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-sound@vger.kernel.org
Subject: Re: HDA Intel microphone regression in 3.1.0
Message-ID: <20111102233233.2abb4038@laptop.homenet>
In-Reply-To: <s5hy5vyl5ia.wl%tiwai@suse.de>
References: <20111102102554.1f443b9c@laptop.homenet>
	<20111102105442.GA30355@gere.osrc.amd.com>
	<s5hd3da6asw.wl%tiwai@suse.de>
	<20111102170742.059f04ed@laptop.homenet>
	<s5hy5vyl5ia.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Nov 2011 19:54:21 +0100
Takashi Iwai <tiwai@suse.de> wrote:
[snip]
> > > Please give alsa-info.sh outputs taken from both 3.0 and 3.1
> > > kernels.
> > 
> > Attached as below (warning, this is long).
> 
> Thanks.  Could you try to pass model=auto option to snd-hda-intel
> module?

With that option applied to snd-hda-intel, the microphone now works
correctly again. I imagine that is not the permanent fix but it will do
for my netbook.

Thanks for your help.

Chris
