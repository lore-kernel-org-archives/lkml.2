Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab2EKANW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 20:13:22 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45705 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751676Ab2EKANU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 20:13:20 -0400
Message-ID: <1336695199.29763.28.camel@joe2Laptop>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kay Sievers <kay@vrfy.org>, "Ted Ts'o" <tytso@mit.edu>,
        Ingo Molnar <mingo@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartmann <greg@kroah.com>, linux-kernel@vger.kernel.org
Date: Thu, 10 May 2012 17:13:19 -0700
In-Reply-To: <CA+55aFygHfYd3O5-sBg32_Vcn6GOm7irr2R8jW6QVPuepXTeWw@mail.gmail.com>
References: <CA+1xoqcAjEh5LT42NpjoE0998KUecY6EWQp4FM0_CY8MPyLmbQ@mail.gmail.com>
	 <CA+55aFzVs0GLpNVUBHtLRuc8uQc=WKd8ajeVWsffbNvxSQvB4Q@mail.gmail.com>
	 <CA+55aFzgXzFs9z-5ViQ4=4hhtOtK=CBHGxNX_dsXQV9mn1qANg@mail.gmail.com>
	 <20120509070710.GA29981@gmail.com>
	 <CAPXgP11evyQQKNDaa00R7qsOFy5Xk-utN1w9OgB4y6NxLZG=UA@mail.gmail.com>
	 <1336611278.728.9.camel@mop>
	 <CA+55aFyrrH0jJV--L=ugt0YK7pT+jmhjvt_WRWyenyiroN97zg@mail.gmail.com>
	 <1336667984.947.24.camel@mop>
	 <CA+55aFxUaNC4SGEodrdddkDN6t=Sbx=P4XyaHkj7eTQBQOeLeA@mail.gmail.com>
	 <1336676986.947.47.camel@mop> <20120510201409.GA6467@thunk.org>
	 <1336682226.29763.2.camel@joe2Laptop>
	 <CAPXgP11T7vjBBFaE5jne0hntZ2J-MoVxwJ2C9TNsRzme9DmLuQ@mail.gmail.com>
	 <1336682772.29763.6.camel@joe2Laptop>
	 <CA+55aFwJgtVr9ZndEU-yhJW3wi-5Omga51pjun+J213awQwJZA@mail.gmail.com>
	 <1336684277.29763.12.camel@joe2Laptop>
	 <CA+55aFygHfYd3O5-sBg32_Vcn6GOm7irr2R8jW6QVPuepXTeWw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 14:58 -0700, Linus Torvalds wrote:
> On Thu, May 10, 2012 at 2:11 PM, Joe Perches <joe@perches.com> wrote:
> >
> > I think it's a distinction without a difference for,
> > as fas as I know, that's a case that doesn't exist
> > in the current kernel.
> 
> So? Even if we hadn't had this bug before (we have),

True.  I've fixed the ones you've introduced when you
changed printk semantics in the past.

> your argument is utter crap.

What happened to the pragmatic Linus Torvalds?
Did the dogmatic one replace him again temporarily?

> Even if we weren't to have that patter right *now*, that
> doesn't mean that it cannot happen.

Not what I said.

> Your grep is also not at all exhaustive.

I believe I know the printk subsystem and its uses
as well as anyone.  I don't think there is a case
today.

> We do need an escape model.

Or an agreement to not to emit "<[0-7cd]>"
as the first 3 bytes after a newline or as
the start of a new printk.  It could just
as easily be an escape is a required leading
non "<" character.

I think that's not onerous.

> The current KERN_CONT does that. Stop
> arguing for crap.

Correctness in all cases can be a good thing.
Simplicity may be better because complexity
is reduced.

cheers, Joe

