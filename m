Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab0GBLKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 07:10:35 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:33055 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181Ab0GBLKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 07:10:33 -0400
Date: Fri, 2 Jul 2010 13:10:29 +0200
From: Luc Verhaegen <libv@skynet.be>
To: Dave Airlie <airlied@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: Closed source userspace graphics drivers with an open source
	kernel component
Message-ID: <20100702111029.GB6802@skynet.be>
References: <AANLkTikfYwkxF5CXgt-fGMIYTlcmt99lOz_VyA3Kr-4R@mail.gmail.com> <20100702095815.GA6802@skynet.be> <AANLkTimNgjtvDYY42dm-6akRjQfkHayagQWwHSS3AQs7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimNgjtvDYY42dm-6akRjQfkHayagQWwHSS3AQs7@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 08:23:27PM +1000, Dave Airlie wrote:
> >
> 
> They own quite a lot of the IP in the 3D core, having bought it from
> AMD, you can see the CP packets and PM4 stuff just like in radeon.

Aha, imageon indeed, cool!

I doubt that you know the conditions of this sale. This might just be about waiting for 
Qualcomm to sort things out, or it might be about a licensing issue still. We just 
cannot know this.

> I know who Jordan is well from AMD, and I've stated this isn't a
> Qualcomm only thing, but companies need to understand that putting
> stuff into the kernel is part of a bargain, where you get the benefits
> of all the work everyone has done on the kernel and they get the
> benefits of being able to do stuff with the code you provide, only
> giving us a half arsed interface to the hw and hiding all the good
> stuff in userspace isn't accepting this bargain. You can say what you
> like about liceneses and legalese but Linus picked the GPL for this
> sort of everyone gives what they get.

Sure, but you still slammed, and this affected in first order mostly Qualcomm, instead 
of stating that you simply do not want to be involved.

> They'll keep shipping closed stuff, just like they are now. Are you
> going to reverse engineer the userspace drivers, so people who care
> about open and free software platforms can use these drivers? (or have
> you already signed NDAs saying you can't). Why should we maintain a
> bunch of kernel code, when they are hiding away all the really useful
> stuff that people could improve.

Maintaining this exact code is not _your_ job, and you should've stated just that.

> I would, some points
> (a) Red Hat is the company I work for.
> (b) Red Hat doesn't really care about this stuff at all.
> (c) I'm the kernel maintainer for far longer that I worked for Red
> Hat, I also work a lot with Intel at Red Hat and I've told them the
> same thing, and VIA and now I'm stating it so I don't have to restate
> individually to every company again.

You will need to restate this every time anyway, unless you somehow manage to get your 
rather daunting and loud statement to be the first thing such corporations management 
people at linux.com, which is what people type in their browser first.

But maybe you might want to adjust your message.

> You don't understand what being a kernel maintainer is do you? at all?

Heh, i could make a really nasty statement here, but i wont.

> Wierd I'm still seeing new docs being produced and old docs being
> updated, not as fast as I'd like but I understand how many people
> there is working on it and I'd rather we also got fixes for all the
> current stuff done as well.

Hrm, i only see _very_ old docs getting updated, and none produced.

I still have docs which are pretty ready to be shipped (from 2007), under uncertain 
legal status (the ati game was fun!), which were never made public. I am sure that 
bridgman, gave you these docs too, but under even more shady circumstances.

> The code doesn't exist, there is no userspace code to be the
> documents, if you read what I said, documents would be a good start in
> lieu of code, but code is perfectly fine.

> Imagintaion technologies seriously? they've never ever taken one step
> towards opening anything, I don't think this statement is suddenly
> going to jumpstart them.

> Maybe you should disclose what NDAs you currently are under and who
> pays your bills, since you accuse me of Red Hat mind-control.

Oh, i now work for basysKom, a contractor for, amongst others, nokia, which i'm sure
you knew.

> I'm not sure how the ARM market would benefit from having no userspace
> 3D drivers just like the x86 market, if you actually were normal you'd
> realise the ARM people are trying to screw the market just like the
> desktop people, to save themselves some money, but maybe working on
> closed drivers has twisted you.

Ah, so you did know.

As a free software graphics driver developer there is little option left but to go 
straight to the ARM world, at least things have potential to move there still.

Well, unless the efforts there, like the one that triggered your mail, are thwarted 
too, like with your mail.

Luc Verhaegen.
