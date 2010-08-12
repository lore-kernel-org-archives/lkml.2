Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418Ab0HLRdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 13:33:11 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21844 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab0HLRdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 13:33:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=yrFa8163JgFcyGdqop5vEoDIbB2QPCrtJo+wdYbYbVTBV+BwATvqFJrUR/rdxgxuD
	zZCF8whFIuLFIl8A3uCWA==
MIME-Version: 1.0
In-Reply-To: <AANLkTik=K2znpgiHVgA1oD5Znrmm0Gx45ajfoQ7AwG3F@mail.gmail.com>
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
	<20100812140903.GB11362@sirena.org.uk>
	<AANLkTik=K2znpgiHVgA1oD5Znrmm0Gx45ajfoQ7AwG3F@mail.gmail.com>
Date: Thu, 12 Aug 2010 10:33:01 -0700
Message-ID: <AANLkTi=9v0o5pQ6s=sjjnk0udmrBAiy4wD+h2vrn_h8=@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Brian Swetland <swetland@google.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Theodore Tso <tytso@mit.edu>, paulmck@linux.vnet.ibm.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, david@lang.hm,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 9:57 AM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
>
> Correct, but still a considerable amount of changes would need to be
> done, which _nobody_ has expressed any intention to do.
>
> Besides, IMO a good mobile platform would share as much as possible
> with desktop software. Say, the improvements Nokia has endorsed on the
> Telepathy IM framework can only help the people already using it on
> the desktop.
>
> However, personally, if I ever have to do './configure
> --enable-suspend-blockers', I would think that something that just
> doesn't belong has creped by to user-space. I don't see why there
> should something particularly different between mobile phones and
> laptops, and I think this has been already expressed over, and over.

So, because you feel that phones should be little laptops you oppose
providing (optional!) support for environments that take a different
view to that?

I'll echo Ted's question -- is this the opinion of the kernel
community at large?  If so, there's not much point in continuing to
have discussions around suspend blockers.

I think that we're still a ways away from a world where we can treat
mobile devices the same as laptops and get reasonable user
experiences.  I think it's unfortunate if the attitude here is "wait
and someday it won't matter", especially because I'm skeptical that
we're likely to hit that "someday" any time soon.

Brian
