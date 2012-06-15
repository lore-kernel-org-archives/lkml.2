Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749Ab2FOXeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 19:34:16 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53587 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758549Ab2FOXeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 19:34:15 -0400
X-Sasl-enc: /dknYRl55JIpPQPbhffFmdV8pv9UJjphiMyTJ4c9YiGq 1339803254
Date: Fri, 15 Jun 2012 16:34:13 -0700
From: Greg KH <greg@kroah.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: ksummit-2012-discuss@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2012-discuss] [ATTEND or not ATTEND] That's the
 question!
Message-ID: <20120615233413.GB8894@kroah.com>
References: <alpine.LFD.2.02.1206152313310.3086@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1206152313310.3086@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 12:56:36AM +0200, Thomas Gleixner wrote:
> So the main questions I want to raise on Kernel Summit are:
> 
>    - How do we cope with the need to review the increasing amount of
>      (insane) patches and their potential integration?

That's a very good question, and I've been wondering if someone is
trying to flood us with crap submissions just to try to DoS us and slow
us down.  If not, it's an interesting "attack" vector onto our
development process that we need to be able to handle better.

>    - How do we prevent further insanity to known problem spaces (like
>      cpu hotplug) without stopping progress?

Progress can slow, if we want it to, in some areas, just to let people
get the time to fix up the issues we currently have.  That saves time in
the long run, but requires that someone make it very clear as to what is
going on and how it will change in the future.

But, both of these are great things to talk about, I like it.

> A side question, but definitely related is:
> 
>    - How do we handle "established maintainers" who are mainly
>      interested in their own personal agenda and ignoring justified
>      criticism just because they can?

The wonderful, "how do we remove a maintainer who isn't working out"
problem.  It's a tough one, I don't think we really have any standard
way.  Luckily in the past, the insane ones went away on their own :)

greg k-h
