Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab2FQSwA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:52:00 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51976 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757795Ab2FQSv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:51:58 -0400
X-Sasl-enc: 9V/ehj5k33VBQ46iv3oUOGvCmjoLWyhhj7lIZtJrLN76 1339959117
Date: Sun, 17 Jun 2012 11:51:55 -0700
From: Greg KH <greg@kroah.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>,
        ksummit-2012-discuss@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2012-discuss] [ATTEND or not ATTEND] That's the
 question!
Message-ID: <20120617185155.GA9495@kroah.com>
References: <alpine.LFD.2.02.1206152313310.3086@ionos>
 <20120615233413.GB8894@kroah.com>
 <alpine.LFD.2.02.1206161103320.3086@ionos>
 <20120616072906.7469ec24@tpl.lwn.net>
 <alpine.LFD.2.02.1206171204540.3086@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1206171204540.3086@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2012 at 12:40:55PM +0200, Thomas Gleixner wrote:
> If you look at the stats of the last years, there is nothing really
> interesting happening. We already know who employs the most kernel
> developers and who of them is doing most of the work.

What is interesting, and is why I started collecting this information
years ago, is keeping track of our rate-of-change, the number of new
developers we have contributing, and the number of different companies
and how many of them are contributing.  All of those numbers are good to
watch to see how well as a community we are doing.

So far, all of those numbers are going up, which is good.  If they ever
stop dropping, I will get worried.

These numbers, and stats, are also good for getting other companies to
get involved in kernel development.  I've used them for many years to
point out that they need to get involved, and in one noticable case
(Intel), it has made a huge difference.  Other cases (Amazon and
Motorola), it hasn't helped out at all.

They also show what areas of the kernel are under major change and
churn, which is interesting to see for some people who don't pay that
much attention to our community (2 years ago the x86 rework was obvious,
and this year the ARM and SoC work is obvious).

> If companies really want to measure their "importance" or the
> "performance" of their employees they can create their own stats and
> abuse them for whatever they want.

Companies do do that.  You also see companies "hiding" their
contributions from the stats as they don't want to show up on the radar
for odd reasons (Qualcomm is one example of this, they spread their
contributions around 3 different companies for "misguided" legal
reasons.)

Microsoft was an interesting example of a company that ended up doing a
lot of work for just one set of drivers, and ended up showing high in
the stats because of that.  That provided a great example of a company
that no one had ever thought would contribute, was doing so (the local
Seattle paper's headline read, "Is Cancer Cured?" which was so funny to
me and pissed so many locals off.)

And yes, some companies try to "game" the numbers, but it's really hard
to do this given how much real work is being done by people, and how
obvious it is when it happens.  So far I haven't seen anyone succeed in
doing this, but they might have been so good that I didn't notice.

And as always, of course statistics lie, we all know this, but sometimes
they can be helpful for your cause :)

greg k-h
