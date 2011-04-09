Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab1DII3g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 04:29:36 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:3897 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753829Ab1DII3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 04:29:34 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host p398TEPg023093
Subject: Re: [PATCH 1/2] ARM: Differentiate SheevaPlugs and DockStars on
	the basis of the memory size.
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alexander Clouter <alex@digriz.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <4D9E42E1.1060902@ahsoftware.de>
References: <1302122121-3652-1-git-send-email-holler@ahsoftware.de>
	 <1302122121-3652-2-git-send-email-holler@ahsoftware.de>
	 <alpine.LFD.2.00.1104061739100.28032@xanadu.home>
	 <4D9CED15.2010806@ahsoftware.de>
	 <alpine.LFD.2.00.1104061850410.28032@xanadu.home>
	 <4D9CF5B3.9020007@ahsoftware.de> <toa078-0do.ln1@chipmunk.wormnet.eu>
	 <4D9E2D1C.7070102@ahsoftware.de>
	 <20110407220855.GD17049@n2100.arm.linux.org.uk>
	 <4D9E42E1.1060902@ahsoftware.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 09 Apr 2011 10:29:13 +0200
Message-ID: <1302337753.30783.24.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-DCC-Misty-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fre, 2011-04-08 at 01:04 +0200, Alexander Holler wrote:
[...] 
> I had a look at what's going on in the OMAP linux world for more than a 
> year now and I think I've seen a lot of the stuff you are referring to.

Others were far longer in in several of these "Linux worlds" ....

> And I think one of the reasons that the mess happened is the same I've 
> got trapped in. Why should anyone try to submit patches if he must fear 
> to get caught in some senseless endless discussion about one line.

Welcome to the world where software is actually really maintained - and
not longer in the easy world of "fork it, hack it up to ship it and be
done with it - except of bugs actually reported by customers who care
enough to get the bug report that far" like it is not uncommon in the
embedded world.

> E.g. requiring people to use NULL than 0 or that stupid discussion now 

You obviously where never forced to bugfix with source where you can
identify the writer of each be the style.

> about the simple patch I've posted. I'm writing whole (readable) C++ 

"readable" is quite subjective. And just because it is readable by you
doesn't imply it is readable for many others. Especially if you actually
wrote it .....

> applications (not crap!) in less time than what's is needed to submit 
> and discuss a small patch for some silly hw.

That's precisely the point: Writing the source is the easiest job.
Maintaining it over years and keeping it clear is hard.

> So for me it's fully understandable why companies don't try to work with 
> kernel people at first. They try to develop innovativ products they can 
> sell, and it doesn't help if their developers would have to fear that 

"Innovative products which actually sell" are neither necessary nor
sufficient to produce maintainable code.
IMHO it it quite the opposite - these companies just want to get their
products built as quickly as possible to minimize the time to market and
get it sold (as in "second place, first looser") and be done with it
(except the sales part of course).
And the vast majority of the software on these products is actually not
really maintained - they have just bugs fixed if they crop up and some
user works hard enough to get the bug report actually to someone who
might fix it.
Existing software is just patched to implement the "new features" far
enough to be usable on that one product - ignoring the big picture of
the upstream with all the features and possibilities.
For the next release/version/product, the old code is plain simply
forked and everyone moves on.

[...] 
> It's one thing to say such to someone you know and work with, but it's a 
> totally different thing to say such to someone you almost know nothing 
> about. And not everybody who hasn't the name of a big company in his 
> email address is a moron.

You have to read more mails on the LKML and you will see, that the
domain name in the mail address help in any direction - neither to avoid
being flamed nor that a patch goes faster in.
Of course, there *are* people out there where it looks like that a
well-known domain name helps - but most of them started to hack on the
kernel and (successfully) submit patches with other domains. Think about
it ...

> Sorry, I'm getting sick having to defend me here against people who like 
> to call others crap and abonimation writing ones just because they have 
> maintainer status or whatever.

The main reason was a pure technical one. Think about it ....

Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

