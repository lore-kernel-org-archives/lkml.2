Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab1KCJjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 05:39:06 -0400
Received: from avasout04.plus.net ([212.159.14.19]:47645 "EHLO
	avasout04.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab1KCJjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 05:39:03 -0400
X-CM-Score: 0.00
X-CNFS-Analysis: v=2.0 cv=PPKNCIWC c=1 sm=1 a=F8hxLa1Qgym6LBeQ3hiSHg==:17
 a=9GetC4Mfny8A:10 a=kj9zAlcOel0A:10 a=LEdtUdy26RYgc7uc4Z0A:9
 a=CjuIK1q_8ugA:10 a=0kPLrQdw3YYA:10 a=F8hxLa1Qgym6LBeQ3hiSHg==:117
Date: Thu, 3 Nov 2011 09:39:01 +0000
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: Takashi Iwai <tiwai@suse.de>
Cc: Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-sound@vger.kernel.org
Subject: Re: HDA Intel microphone regression in 3.1.0
Message-ID: <20111103093901.54f2d1fc@laptop.homenet>
In-Reply-To: <s5hsjm6l1b0.wl%tiwai@suse.de>
References: <20111102102554.1f443b9c@laptop.homenet>
	<20111102105442.GA30355@gere.osrc.amd.com>
	<s5hd3da6asw.wl%tiwai@suse.de>
	<20111102170742.059f04ed@laptop.homenet>
	<s5hy5vyl5ia.wl%tiwai@suse.de>
	<s5hsjm6l1b0.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Nov 2011 21:25:07 +0100
Takashi Iwai <tiwai@suse.de> wrote:
[snip]
> > Thanks.  Could you try to pass model=auto option to snd-hda-intel
> > module?
> 
> Also, try the patch below without model option.  This should fix the
> problem.

Yes that fixes it, thanks.

I'm impressed - a working patch 12 hours after reporting it on lkml.

Chris
