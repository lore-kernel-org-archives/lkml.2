Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934210Ab0HMK6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 06:58:16 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44117 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934193Ab0HMK6O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 06:58:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=s5RLWCuF0USZS5ZyZhPifZYXJXihacLLe6Lt8QqnK1qGlkgDz96Hz5WnGGgFQbjYiW
         zQXopKPTBYQo2XzvOj4Ir9ODNTyEecyag62tINh9el/PyB05tyam5ZaZbpUZbYIavEV8
         c1Xu7F7zeQCGjs+5AHPiX1EHxHfUBYQQsew/I=
MIME-Version: 1.0
In-Reply-To: <AANLkTinNxZoMab=tG9KXJ9n_nxB1dXHkfk-7xUMWXACW@mail.gmail.com>
References: <20100809181638.GI3026@linux.vnet.ibm.com>
	<AANLkTikwHaKpLdRdxmZj6JDJnsZ+o-jzbVcXhRW3Jmd9@mail.gmail.com>
	<20100811222854.GJ2516@linux.vnet.ibm.com>
	<AANLkTimahmGikeai8QnAxCy45deT00-6T7h-eA-NqL4G@mail.gmail.com>
	<20100812010612.GL2516@linux.vnet.ibm.com>
	<AANLkTinVV1NVHFPeO0p_e2pCtNwTNB932q9tbu9MMD3_@mail.gmail.com>
	<20100812034435.GA7403@linux.vnet.ibm.com>
	<AANLkTi=RD=eM_gpc7FfRq0923sUbARmZ2+4-m+fLibYC@mail.gmail.com>
	<E3F3D3E1-4DF7-47E3-895D-95F6BC22CCC4@mit.edu>
	<AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
	<20100812174303.GD2524@linux.vnet.ibm.com>
	<AANLkTim1U6QpRyfwYCq2uRA=7-a8ryfDrzv5VCqmHnyB@mail.gmail.com>
	<AANLkTinNxZoMab=tG9KXJ9n_nxB1dXHkfk-7xUMWXACW@mail.gmail.com>
Date: Fri, 13 Aug 2010 13:58:12 +0300
Message-ID: <AANLkTin3H0o+WQocUYjUcPGRpkRqK9H2LJ0OwHXFNBdj@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Brian Swetland <swetland@google.com>
Cc: paulmck@linux.vnet.ibm.com, Theodore Tso <tytso@mit.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, david@lang.hm,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 10:48 PM, Brian Swetland <swetland@google.com> wrote:
> On Thu, Aug 12, 2010 at 12:34 PM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
>>
>> Not Ubuntu, not Fedora, not MeeGo, not anyone with a typical
>> user-space seems to be having this problem. I can argue to you that
>> this problem can be solved in easier ways, but instead I will argue
>> that perhaps we should wait for somebody besides Android to complain
>> about it before providing a "solution". Because after all, what good
>> is a "solution" provided by the kernel, if the user-space is not going
>> to use it, ever.
>
> I'm curious, when does Android count as a user of the kernel?  I
> gather that volume of sales or users doesn't count.  Do we have to
> include some percentage of "desktop" Linux?

You are *one* user of the kernel. Let's suppose Android wasn't using
suspend-blockers, and there was another equally successful linux
mobile platform, Foobingo, and they were using them, and they were the
only ones interested on implementing them.

What does that change? Nothing. They still need to convince the
community that what they are proposing to be merged is actually
useful, and somebody will use it. If not, they can just keep the patch
for themselves until they do. I don't see the big deal.

> If we're an undesirable second-class citizen, why do people care that
> "android is forking the kernel"?

Nobody has expressed anything remotely like that (that you are a
second-class citizen). Why makes you think so? Lots of people get
patches denied. Like Nokia's u_char driver, which is *way* less
controversial than this one.

-- 
Felipe Contreras
