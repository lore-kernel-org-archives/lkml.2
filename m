Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab0LPMLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 07:11:18 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:56051 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab0LPMLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 07:11:17 -0500
Date: Thu, 16 Dec 2010 13:11:15 +0100
From: Andreas Mohr <andi@lisas.de>
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Ben Gamari <bgamari@gmail.com>, Andreas Mohr <andi@lisas.de>,
        Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] [USB] UASP: USB Attached SCSI (UAS) protocol driver
Message-ID: <20101216121115.GA9212@rhlx01.hs-esslingen.de>
References: <20101216062953.GA7427@rhlx01.hs-esslingen.de>
 <566988.16939.qm@web31803.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <566988.16939.qm@web31803.mail.mud.yahoo.com>
X-Priority: none
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 01:46:50AM -0800, Luben Tuikov wrote:
> Andreas, the way you've cut out the quote above, it seems that you're replying to something I've written, when in fact you're replying to Ben Gamari.

Indeed, I had already realized that; that was a victim of me
_manually_ replying to external archive content in the case of LKML
(while preserving proper In-Reply-To ID).

> Hmm... Interesting and insightful stuff. So who are those people that can rewrite whole drivers and get theirs in and the old ones out?

<rhetorical question> :-P

I....
would like to say that I'm not really certain about this ;)

> Within the last two months, I've submitted more patches to uasp.c (4-5) than the original author to uas.c (none). As well as I've submitted patches to uas.c itself (three, first two accepted, third rejected since it changed 86% of the uas.c code), lsusb, sd.c, block/blk-tag.c, etc.

"two months". So it's probably a longer time than what I thought ("weeks"),
which probably is a large part of the reason why it got rejected
outright without its fair share of chance of review,
within the current kernel release interval.

Still, it's then not entirely PC if some people - admittedly people
other than the ones whose actual business it is/was to reject drivers :)) -
then claim that the reason the driver got rejected is firm "policy"
to always reject conflicting drivers.

> Also, uasp.c is a protocol driver.  The protocol will change a bit but not by that much.  When this happens I'll submit new patches to update it, unless someone submits them before that. Even if no patches are submitted to support latter version of the protocol, UAS devices will be backward compatible.
> 
> In effect, this driver doesn't warrant much maintenance by virtue of its nature, but support is there if need be.

*noted*

> > . for some certain reason, it's had "more testing", its
> > situation is "better", ...
> 
> "more testing" -- do you mean uasp.c or uas.c?  If you have a UAS device, try both drivers (do I/O) and see for yourself. uas.c also doesn't support the UAS protocol by definition as it doesn't support TMF and other features present in uasp.c.

Since I indicated this compiled list to be about the "original" submission, it's hopefully obvious.

> uasp.c wouldn't even make it in the kernel alongside uas.c, to give people a choice at least. (and we've heard the excuse for that one before, while there had been two drivers for the same device in the kernel before)

The situation of two drivers in direct conflict can get messy indeed
(especially if people don't know which they are using),
thus I can easily understand that.


> In the immediate future distros may include uasp.c since it provides UAS support. Independent Linux vendors may do the same for the same reason. HDD/ASIC manufacturers may use uasp.c to test their UAS devices (an alternative to the Windows tools).

And that's one thing that I'm worrying about.

Let's say one does the "proper", "good" way to achieve driver
improvements:
have the earlier submission get into released kernels
and then submit patches to it in (let's say) third-steps
to have it get to what a driver with combined
features/functionality/stability would provide.

This would mean to have an original driver implementation in kernels,
which would not last long, get updated significantly ("third-steps" above),
then re-released until we ultimately hit the full combined and
full-featured driver in further kernel releases.

Depending on how important API / user space stability/architecture
effects may become, we could IMNSUTVHO see a situation where it can get
moderately problematic on which distribution / version is using which
driver development version.

All this as opposed to doing a (admittedly not really painless) emergency-yank now
and cleanly releasing with UASP as the _first_ driver version (which probably
is much less likely to change drastically) to ever hit a kernel release.

> If you have a UAS device and would like to play with it, uasp.c is available on github: http://marc.info/?t=129227496000002&r=1&w=2

Given current mass-market unavailability of hardware (as indicated in
the discussion): sorry, nope.

Andreas Mohr
