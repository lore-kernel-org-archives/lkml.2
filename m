Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998Ab1KCLqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 07:46:38 -0400
Received: from avasout08.plus.net ([212.159.14.20]:54833 "EHLO
	avasout08.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932637Ab1KCLqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 07:46:36 -0400
X-CM-Score: 0.00
X-CNFS-Analysis: v=2.0 cv=K/yg7lqI c=1 sm=1 a=F8hxLa1Qgym6LBeQ3hiSHg==:17
 a=9GetC4Mfny8A:10 a=kj9zAlcOel0A:10 a=KbnEudbPjHVZVjttp9UA:9
 a=CjuIK1q_8ugA:10 a=0kPLrQdw3YYA:10 a=F8hxLa1Qgym6LBeQ3hiSHg==:117
Date: Thu, 3 Nov 2011 11:46:34 +0000
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: Takashi Iwai <tiwai@suse.de>
Cc: Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-sound@vger.kernel.org
Subject: Re: HDA Intel microphone regression in 3.1.0
Message-ID: <20111103114634.642fb658@laptop.homenet>
In-Reply-To: <s5hehxpbk76.wl%tiwai@suse.de>
References: <20111102102554.1f443b9c@laptop.homenet>
	<20111102105442.GA30355@gere.osrc.amd.com>
	<s5hd3da6asw.wl%tiwai@suse.de>
	<20111102170742.059f04ed@laptop.homenet>
	<s5hy5vyl5ia.wl%tiwai@suse.de>
	<s5hsjm6l1b0.wl%tiwai@suse.de>
	<20111103093901.54f2d1fc@laptop.homenet>
	<s5hehxpbk76.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Nov 2011 10:59:25 +0100
Takashi Iwai <tiwai@suse.de> wrote:
> At Thu, 3 Nov 2011 09:39:01 +0000,
> Chris Vine wrote:
> > 
> > On Wed, 02 Nov 2011 21:25:07 +0100
> > Takashi Iwai <tiwai@suse.de> wrote:
> > [snip]
> > > > Thanks.  Could you try to pass model=auto option to
> > > > snd-hda-intel module?
> > > 
> > > Also, try the patch below without model option.  This should fix
> > > the problem.
> > 
> > Yes that fixes it, thanks.
> > 
> > I'm impressed - a working patch 12 hours after reporting it on lkml.
> 
> Thanks for a quick check.  May I take you to a testd-by tag in the
> stable patch?

I am happy for you to add me.  It is obviously only tested for my
particular flavour of hardware, which with Intel HDA tends to be a
movable feast.

Chris
