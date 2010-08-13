Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761497Ab0HMLJJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 07:09:09 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39758 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab0HMLJG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 07:09:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B1psVEpkPUOezIV6LM82QJAxech0U75HbTIZythLebDRg8khrueFUYTbKm40SbrctC
         XWXxvsnWxPJQalJFk3xcYjiejYV9gNQ42sGc3baS/QgGfhR9PoyhGRNcujtsm+crFma0
         FPLoCJJsyrOpOXuFXUgkmOzqsQU5Qha8ronxY=
MIME-Version: 1.0
In-Reply-To: <20100812125712.48b7fc26@virtuousgeek.org>
References: <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
	<Pine.LNX.4.44L0.1008120733130.21006-100000@netrider.rowland.org>
	<AANLkTinMwt27wuDUh32F36wpoC54Syzp1_nK9UCxYmEK@mail.gmail.com>
	<20100812125248.GA2763@thunk.org>
	<AANLkTin4=qpDWEKLwes_af6mSCW+ED7v-fWzD34JywU1@mail.gmail.com>
	<20100812182128.GC2763@thunk.org>
	<AANLkTinZ_gViUjVmEbkmour3BC=PcchJDARs4GaCuQwO@mail.gmail.com>
	<AANLkTimjfU2zu4reEVdOwWwtFHPQ33_Gna6xS2XHRG-h@mail.gmail.com>
	<20100812125712.48b7fc26@virtuousgeek.org>
Date: Fri, 13 Aug 2010 14:09:03 +0300
Message-ID: <AANLkTinbsXEk7YL31Q2GHHjeVRHGgpm0mpLzDBY1Ob4z@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Brian Swetland <swetland@google.com>, "Ted Ts'o" <tytso@mit.edu>,
        Alan Stern <stern@rowland.harvard.edu>, paulmck@linux.vnet.ibm.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, david@lang.hm,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, peterz@infradead.org,
        tglx@linutronix.de, menage@google.com, david-b@pacbell.net,
        James.Bottomley@suse.de, arjan@infradead.org, swmike@swm.pp.se,
        galibert@pobox.com, dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 10:57 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Thu, 12 Aug 2010 12:19:34 -0700
> Brian Swetland <swetland@google.com> wrote:
>> Question though -- has every feature ever added to the kernel been a
>> feature that there's pre-existing usage of?  Seems like a chicken and
>> egg problem.  Also, some people seem to think there's value in being
>> able to build kernels "out of the box" that work with the Android
>> userspace -- given that there are a few devices out there that have
>> that userspace on 'em.
>
> We generally try to merge new features like this along with code that
> uses said feature, but there are always exceptions.  We've merged code
> one release or more before the new code gets used for example, which is
> fine IMO.  What we don't want to see is some new drop of code added and
> abandoned, but you already knew that.

If Android guys provided a bare minimal Debian system with suspend
blockers that people can take a look at and try, I think that would be
a good proof of concept. And a bare minimum to get the patches merged.

> At any rate, if Felipe is the only one arguing against including
> suspend blockers in the kernel, you're probably in good shape.  Based
> on my (rather cursory I admit) evaluation of this thread, it seems like
> reasonable people agree that there's a place for a suspend blocker like
> API in the kernel, and that dynamic power management is also highly
> desirable.  So where's the git pull request already? :)

I certainly have been the more vocal recently, but if that's confusing
you, I can shut up and let others do the argumentation. I remember at
least Alan Cox, Alan Stern, Thomas Gleixner, Kevin Hilman, Felipe
Balbi, Tony Lindgren, and Igor Stopa against them.

-- 
Felipe Contreras
