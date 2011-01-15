Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab1AOUbp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 15:31:45 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49617 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab1AOUbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 15:31:44 -0500
Date: Sat, 15 Jan 2011 20:30:55 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Christer Weinigel <christer@weinigel.se>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API
Message-ID: <20110115203055.GA15283@n2100.arm.linux.org.uk>
References: <201101111016.42819.jeremy.kerr@canonical.com> <20110111091607.GI12552@n2100.arm.linux.org.uk> <4D2D184A.8020405@codeaurora.org> <20110112090301.GS11039@n2100.arm.linux.org.uk> <4D31A8F1.4080301@weinigel.se> <20110115145358.GC15996@n2100.arm.linux.org.uk> <4D31D45A.8080509@weinigel.se> <20110115172033.GM15996@n2100.arm.linux.org.uk> <4D31DCF6.7090805@weinigel.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D31DCF6.7090805@weinigel.se>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 06:44:22PM +0100, Christer Weinigel wrote:
> On 01/15/2011 06:20 PM, Russell King - ARM Linux wrote:
> > You really need to read the entire thread - I've already said that yet
>
>> discussion continues about how to solve the problem.  This thread which
>> has been running for a number of days now has been entirely about how
>> to solve this.
>
>
> Sigh, the always oh so polite Russell.  I have read the thread before; I  
> reread the whole thread one more time before posting.

Look, the clk API unification issue has been rattling around for six months
or more not making very much progress.  Should it continue to be discussed
for another six months while nothing happens because agreement can't be
reached?

Do you not realise what you suggested has already been proposed?

Does it help the discussion to have more people coming into the discussion
saying "we should do X" when we've already had people suggesting that we
should already do X - and we've had people saying afterwards "we should
do Y"?

Do you really think that you saying "we should do X" means that we'll have
lots of people suddenly saying "oh yes, you're right" when they didn't
before?

It's covering old ground over and over again.  Raising the same points
over and over again is just a pointless waste of time - it just sends the
discussion around the same loops time and time again.  Nothing actually
ever gets resolved but lots of time gets wasted discussing it.

>> Consider this: is it better to continue talking about this for the next
>> six months, while still having N spinlock based implementations, and M
>> mutex based implementations.
>>
>> Or is it better to consolidate the N spinlock based implementations
>> down to one spinlock implementation, and M mutex based implementations
>> down to one mutex implementation, and then discuss how to resolve the
>> differences between the two implementations?
>
>
> Going that way might very well mean that you will be stuck with two  
> implementations forever.  But yes, it might be better with two working  
> ones than one which takes a bit longer to finish.
>
> But my impression is that the different suggestions in the thread aren't  
> that far apart.  Except for the discussion if clk_enable/disable should  
> be able to sleep or not, people seem to agree on most of the rest of the  
> API.

As I said, at this point I _really_ don't care what happens provided
it doesn't end up screwing the facilities enjoyed by the existing
implementations.

I'm tired of reading this discussion.
