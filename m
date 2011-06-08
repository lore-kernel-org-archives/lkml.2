Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab1FHHYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 03:24:23 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:55211 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287Ab1FHHYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 03:24:22 -0400
Date: Wed, 8 Jun 2011 09:24:16 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Nicolas Palix <Nicolas.Palix@inria.fr>
Cc: Greg Dietsche <gregory.dietsche@cuw.edu>, Gilles.Muller@lip6.fr,
        cocci@diku.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coccinelle: if(ret)return ret; return ret; semantic
 patch
In-Reply-To: <BANLkTim-x02kkpcRpPhZEKoJv3YMmQRNOg@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1106080923060.10548@ask.diku.dk>
References: <1307320012-31292-1-git-send-email-Gregory.Dietsche@cuw.edu>
 <Pine.LNX.4.64.1106060651320.7113@ask.diku.dk> <4DEE482D.7020505@cuw.edu>
 <Pine.LNX.4.64.1106071855540.4074@ask.diku.dk> <BANLkTimMvG332_c4TUPefOJDDE8obowVdQ@mail.gmail.com>
 <4DEEAD5D.2090406@cuw.edu> <BANLkTim-x02kkpcRpPhZEKoJv3YMmQRNOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jun 2011, Nicolas Palix wrote:

> Hi,
> 
> On Wed, Jun 8, 2011 at 12:59 AM, Greg Dietsche <gregory.dietsche@cuw.edu> wrote:
> > On 06/07/2011 04:54 PM, Nicolas Palix wrote:
> >>
> >> I remember me having worked on that but I cannot find any patch
> >> about it so your patch is more that welcome. Some users have requested it
> >> some months ago.
> >>
> >> As far as I can remember, with "M=" you can not use $srctree only but
> >> still
> >> need it for the -I for instance. I think I then run into a situation where
> >> I
> >> have an ambiguity about how to setup the flags for coccinelle, but I am
> >> sure
> >> about the reason I dropped my patch. Maybe I don't know well enough the
> >> build
> >> system and options...
> >>
> >> So, don't hesitate to submit your patch.
> >>
> >
> > I'll submit what I have done as a new thread / patch series. I've not done
> > much testing with it and am certainly not any kind of build system expert,
> > but it has worked well for me so far :) A few more people trying it out /
> > testing it would be a great idea.
> 
> I finally found the thread where we discuss this feature.
> http://lkml.org/lkml/2010/7/2/279
> 
> I haven't the time to test your patch right now but at the time
> the problem was in the patch mode which produces erroneous file names
> (in the lines with ---/+++).
> As far as I can remember, using the -dir and -patch options of
> coccinelle doesn't work with external modules.

Can you give a concrete example?  -patch is supposed to address the 
problem of undesired path elements, but perhaps it is not sufficient in 
this case.  There could be a problem of knowing what the argument to 
-patch should be?

julia 
