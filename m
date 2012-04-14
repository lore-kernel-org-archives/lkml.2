Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab2DNP6J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 11:58:09 -0400
Received: from 1wt.eu ([62.212.114.60]:65151 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438Ab2DNP6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 11:58:07 -0400
Date: Sat, 14 Apr 2012 17:57:33 +0200
From: Willy Tarreau <w@1wt.eu>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Adrian Chadd <adrian@freebsd.org>,
        Greg KH <gregkh@linuxfoundation.org>, Sergio Correia <lists@uece.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 00/78] 3.3.2-stable review
Message-ID: <20120414155733.GF19802@1wt.eu>
References: <20120412144626.GA14868@kroah.com> <CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com> <CAJ-VmonhwvnXPKa=LNOR4W0ZTXZqWmzw4UrsKLoE0YN_Bu0FzQ@mail.gmail.com> <CAMP44s2JPvhEB6Eb049Z_bToAFncHKMEheuyaxyhC=bnh2GJVg@mail.gmail.com> <20120413105746.10ffb120@stein> <CAMP44s0RohH9tPiM5qCDT57XBV=iO66PZkSjYVxA6Usg1qJPtw@mail.gmail.com> <20120413154216.476a02ac@stein> <CAMP44s10KVwL5pY=Q5hWfyUtU6CvvZZ4Bcg-fEY9dAhSL306aQ@mail.gmail.com> <20120414094137.54a7f213@stein> <CAMP44s2Un-M2OCmuRQGpGsHR21gH=S7oJKx4Ci8tvYVCCSitUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s2Un-M2OCmuRQGpGsHR21gH=S7oJKx4Ci8tvYVCCSitUw@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 06:29:54PM +0300, Felipe Contreras wrote:
> So, the hypothetical patch that was dropped in the stable review queue
> yesterday has to be fixed in mainline too, just like the hypothetical
> patch that made it to stable and was found problematic today has to be
> fixed in mainline.

Patches are not always dropped from the stable queue if we know they're
causing issues, sometimes they're left pending in the queue. This is how
Greg is able to ping developers from time to time.

> Again, what makes a released patch undroppable?

Being applied, in other words, having a commit ID in the branch.

(...)
> Just by going through the stable review process the patch already
> received more eyes to make the bugs more shallow. There might be a lot
> of trees out there where people pick patches from mainline, and they
> don't *need* to follow the "upstream first" rule, by reviewing the
> patch, and maybe even testing it, and then reporting the problem, they
> are helping getting it fixed for v3.4.

They do what they want with their trees. I have a number of patches in my
trees that are not worth pushing to mainline and that's fine. However the
rule is that the official stable tree has to hold patches that come from
mainline.

> You don't *need* to keep the patch in the stable review queue, you
> don't *need* to make a stable release with it in order to ensure that
> it will fixed in mainline, the information about the patch problems is
> not lost.

It's lost since nobody cares once their kernel is fixed. For instance, I
have an issue with 3.0.x on my netbook which I haven't had time to bisect
(no resume from s2r). But 3.2 works. If I find that the issue was introduced
in any stable backport, we'll have to ensure that mainline has the fix,
because the bug might simply be hidden in 3.2 but still present. If we'd
just revert the fix from 3.0, what would motivate anyone to fix mainline
if it appears to work ?

> Seems to me you are abusing the 'stable' branch as a bug tracking
> system for certain patches for the next release.

The most reliable bug tracking system are the end users. They're the only
one who remind you to get their fix merged. And you did this yourself,
quite louder than the average I'd say, but it worked perfectly again.

Willy

