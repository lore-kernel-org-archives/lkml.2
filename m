Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab0LPG35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 01:29:57 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:41607 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab0LPG3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 01:29:55 -0500
Date: Thu, 16 Dec 2010 07:29:54 +0100
From: Andreas Mohr <andi@lisas.de>
To: Ben Gamari <bgamari@gmail.com>
Cc: ltuikov@yahoo.com, Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] [USB] UASP: USB Attached SCSI (UAS) protocol driver
Message-ID: <20101216062953.GA7427@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fwu05imn.fsf@gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I had preferred to subsequently calmly stay on the sidelines
after trying to argue for a beneficial compromise,
but given this lack of realism I'm choosing to reply again:

> On Tue, 14 Dec 2010 09:25:12 -0800 (PST), Luben Tuikov
> <ltuikov@yahoo.com> wrote:
> > --- On Mon, 12/13/10, Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
> > wrote:> > Your driver may be the best on the planet - who knows - 
> > Obviously he didn't review it.
> 
> This is may be true, perhaps he didn't look at the code. This is not
> because he doesn't have confidence that your driver is well-written or
> holds a grudge against you. The reason for this NAK is policy: a driver
> already exists. In the kernel we work with what already exists, even if
> it may be more difficult than the alternative.

One word: HOG-WASH. At least the e100 vs. eepro100 case is a clear
counter-example to that. That was an eepro100 driver which has been in active
mainline service for years and had many diagnostic features,
to then be replaced (one could argue that it _may_ be better indeed
to replace a possibly less-maintained driver with a better-maintained one
by the original hardware manufacturer).

The result, even from my tiny involvement (one card where I had lots
of trouble getting a make-it-work-again kind of patch into e100 - one
YEAR to have mainline actually support the hardware again),
is known as several hardware variants failing to work with the new driver
(and I just found another hardware example in the very first semi-related
Google search I did, so there must have been many more).
Not sure about current status, but I'm nevertheless very positive that it's much better now.

Witness this very problematic case as opposed to the current conflict case
where there's a _new_ hardware/driver which has been hardly even used by anyone,
to potentially be replaced by a (supposedly?) much better driver
which has almost identical amount of history (read: _weeks_ or at most months,
and both have not even ever been released yet).


Guys, please argue healthily and don't keep making up straw-man
arguments (as I'm tending to believe when reading some parts of the
discussion).


The way I see it there is this (likely incomplete) list of reasons to
prefer the "old", "challenged"(?) new driver:
. there's the "old", "timely submitted" 
  driver, and the entire thing may be an understandably much-less-than-positive situation for its author
. the author of the new one is a d**k to argue with
  (may easily be true given several cases of his awfully "personal" arguing,
   but in his position facing such often unbased opposition
   other people might have lost some temper, too),
  causing uncertainty about proper continued maintenance of the driver
. for some certain reason, it's had "more testing", its situation is "better", ...
. suddenly accepting an entirely different driver after another can
  legitimately be seen as some kind of unhealthy disruption of the
development advancement
. at this point in time we've lost enough additional time arguing
  that a change of drivers might now really be inconvenient
  from a kernel release continuity/planning POV.
  Let me tell you that I'm somewhat unconvinced of this, though.

Perhaps at this time the only thing to be said is that due to "policy" (yeah, whatever)
a more timely submitted driver will remain in and the supposedly better
driver will stay out, but given the history of Linux kernel drivers this
is more than a bit unconvincing, as outlined above.
Of course one could argue that this policy simply is quite _new_
and didn't exist yet at the time of the other conflicts (e100, 8139, RAID adapters),
and possibly has been established exactly _due_ to the many difficulties that turned
up in these cases.
However it's still questionable whether it's appropriate
to apply such a policy _in this case_
given that _both_ candidates aren't entrenched (in active service) at all.


Still, I hope that even with a "negative" decision the best elements of the
drivers will eventually find their way into a combined driver,
with appropriate amounts of maintenance.

Andreas Mohr
