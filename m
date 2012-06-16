Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab2FPQnK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 12:43:10 -0400
Received: from mx2.netapp.com ([216.240.18.37]:54985 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016Ab2FPQnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 12:43:09 -0400
X-IronPort-AV: E=Sophos;i="4.75,783,1330934400"; 
   d="scan'208";a="655849870"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
        "ksummit-2012-discuss@lists.linux-foundation.org" 
	<ksummit-2012-discuss@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2012-discuss] [ATTEND or not ATTEND] That's the
 question!
Thread-Topic: [Ksummit-2012-discuss] [ATTEND or not ATTEND] That's the
 question!
Thread-Index: AQHNS98a9PRPm3rdz0ytq3c/N5FQAQ==
Date: Sat, 16 Jun 2012 16:43:05 +0000
Message-ID: <1339864979.8267.55.camel@lade.trondhjem.org>
References: <alpine.LFD.2.02.1206152313310.3086@ionos>
	 <20120615233413.GB8894@kroah.com>
	 <20120616123032.251dd101@pyramind.ukuu.org.uk>
In-Reply-To: <20120616123032.251dd101@pyramind.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <234F939D875C8A4EA36AC9E9FC403110@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5GGi3R3012625

On Sat, 2012-06-16 at 12:30 +0100, Alan Cox wrote:
> On Fri, 15 Jun 2012 16:34:13 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> > On Sat, Jun 16, 2012 at 12:56:36AM +0200, Thomas Gleixner wrote:
> > > So the main questions I want to raise on Kernel Summit are:
> > > 
> > >    - How do we cope with the need to review the increasing amount of
> > >      (insane) patches and their potential integration?

> There are a small number of very large businesses that generate a lot of
> the money in the server space. They have individual needs and the money
> tends to drive chunks of kernel development. Thats both a bad and a good.
> The bad is they are trying to get it to do what they need, now and
> without planning for the long term properly. The good is that they are
> paying developers who otherwise might be working on other stuff.

I don't think that is necessarily true. Most of the large businesses are
interested in long term solutions: that's why they hire people rather
then farming the work out to consultants.

The problem is that the internal cultures of those businesses isn't
necessarily adapted to an open development model. Their focus is on a
limited set of features that they can sell to customers, and so they get
confused when you tell them "no, I don't want to have to implement 10
different variants of read/write to satisfy 10 different workloads, even
if each one can be shown to produce a 2% performance increase".

The people who are aware of the Linux culture, tend to be the
developers, since they are immersed in that culture and since we have
programs for educating them (via workshops, conference tutorials,
mailing lists, Linus's shouting...). It should be the responsibility of
those developers to educate their program managers etc, and usually that
will happen once the program managers realise that their projects are
going nowhere with the maintainers...

> We also have a large consumer electronics and now android ecosystem much
> of which is made up of companies and people whose business history and
> business model for all products has always been
> 
> - make it boot
> - make it usable
> - ship it
> - run 
> 
> they have little incentive to share, they have no interest in the longer
> term, and it's often not rational economics for them to clean up their
> code and upstream it because it just helps their rivals, and besides the
> part is now 6 months old so obsolete in their world.
> 
> For a lot of hardware the only way that is going to get fixed is if
> 
> a) it is easier to do the job right than hack it up
> b) when the hardware vendors are more involved and have longer term plans
> c) their customers start to demand it in order to be up and running very
> fast (ie there is heavy consolidation in the platform)
> 
> It's not in these little "hack it/ship it" houses interest to care about
> making a part work well long term, because they have no particular loyalty
> to any component or supplier, and can charge twice if they do the work
> twice anyway.

Right, but that is a different problem: that's about getting people to
contribute in the first place, rather than the review issue that Thomas
raised.

> > The wonderful, "how do we remove a maintainer who isn't working out"
> > problem.  It's a tough one, I don't think we really have any standard
> > way.  Luckily in the past, the insane ones went away on their own :)
> 
> We have current problems and they are often caused by the maintainer in
> question having other commitments that they consider more important (and
> probably are in some cases).
> 
> One thing that seems to be working well are all the areas that have two
> or more maintainers. As a simple statistical fault tolerance they don't
> generally both have newborns, get the flu, change job or get yanked into
> a critical customer problem by their employer on the same week.
>
> Right now we are doing it for real in some areas, and via the "screw
> this, mail Andrew Morton" process for others, plus Linus fields some of
> the really dumb ones. We could formalise some of that a bit more and
> encourage more maintainers to actual team up with one of the other
> contributors they trust.

If by "maintainer" you mean "patch reviewer", then I agree. Teaming up
for the review process is the right thing to do, and is (as far as I
know) what we were trying to resolve with the "Reviewed-by" tag.
Formalising the review process and raising the status of developers that
commit to reviewing patches is entirely the right thing to do. Actually
maintaining trees of reviewed patches is the trivial part of the
operation.

Perhaps the right thing to do is to start demanding that all patches
that are submitted to the maintainer contain at least one "Reviewed-by:"
tag?

> (And we probably need to clone DaveM or get him to delegate more 8))
> 
> And we need about ten extra GregKH's if anyone has spares
> 
> Alan
> --
> 'Go go go Gregzilla'

ACK! :-)

Cheers
  Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
