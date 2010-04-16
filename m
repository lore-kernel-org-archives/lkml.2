Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276Ab0DPEPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 00:15:23 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41972 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750957Ab0DPEPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 00:15:21 -0400
Date: Fri, 16 Apr 2010 06:15:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Rees <drees76@gmail.com>
Cc: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Low-Level and Long-Term Battery Control
Message-ID: <20100416041509.GB1552@elf.ucw.cz>
References: <h2i45cc95261004120628kb38aabecr2552668f9e60d7c5@mail.gmail.com>
 <20100415180200.GA1443@ucw.cz>
 <q2p72dbd3151004151642p9c0b8a14yc9de251b134aec08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <q2p72dbd3151004151642p9c0b8a14yc9de251b134aec08@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2010-04-15 16:42:56, David Rees wrote:
> On Thu, Apr 15, 2010 at 11:02 AM, Pavel Machek <pavel@ucw.cz> wrote:
> >> For Laptops, it is better to extract the battery from the Laptop when
> >> the computer will be on power for a long period.
> >> I ask if the kernel can do such control without the user intention and
> >> in an automatic way.
> >>
> >> Some BIOS provide to the user to select whether to block the battery
> >> charging to 50% to make it stand for more time.
> >
> > Where have you seen that?
> 
> I do recall that some older ThinkPads had a utility that would let you
> determine what "empty" and "full" was by setting artificial limits.
> It's well known that by keeping batteries from being fully
> charged/discharged can significantly extend it's useful life although
> you will suffer from shorter run-times.  How sensitive a battery is to
> this depends on it's exact chemistry, but all are affected by this to
> some degree.
> 
> For example, by keeping your battery from charging above 85% and below
> 15% can increase the number of charge/discharge cycles a large
> amount

>From charging below 15%?

> often on the order of 5-10 times more charge/discharge cycles - much
> more than the 30% reduction in total capacity.  Limiting to 25-75%
> will help even more.

I believe I've seen "don't charge above 85%", but "don't charge above
50%" is quite excessive...

Anyway, this is done by smartbattery, not by OS.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
