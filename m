Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab1ACLtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 06:49:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293Ab1ACLt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 06:49:28 -0500
Message-ID: <4D21B7B1.6000608@redhat.com>
Date: Mon, 03 Jan 2011 09:49:05 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: LMML <linux-media@vger.kernel.org>, Manu Abraham <abraham.manu@gmail.com>,
        Patrick Boettcher <pboettcher@kernellabs.com>,
        Hendrik Skarpeid <skarp@online.no>, stoth@kernellabs.com,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Summary of REGRESSIONS which are being ignored?! (Re: Summary
 of the pending patches up to Dec, 31 (26 patches))
References: <4D1DCF6A.2090505@redhat.com> <1293996645.2409.89.camel@localhost>
In-Reply-To: <1293996645.2409.89.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 02-01-2011 17:30, Andy Walls escreveu:
> I don't see this patch on it's way upstream:
> 
> https://patchwork.kernel.org/patch/376612/   (Sent on 5 Dec 2010)
> http://www.spinics.net/lists/linux-media/msg26649.html (Resent on 19 Dec 2010)
> 
> It fixes a regression in IR and Analog video for cx23885 based cards and
> an intermittent analog video regression in ivtv based cards in 2.6.36
> and soon in 2.6.37.

Not sure what happened here. I'm sure I've applied on my fixes tree.
Anyway, I'm re-applying it.

> I emailed the LMML, you, and the author, as soon as I verified the root
> cause on 31 Dec, and haven't heard from from anyone:
> 
> http://www.spinics.net/lists/linux-media/msg27261.html 

Here, Dec, 31 is a national holiday. People work only half of the day.
Yet, I was finishing some things and preparing patches for the incoming 
window, until afternoon.

I only noticed your email today, and I'm promptly sending it upstream,
together with a patch revert for wm8775 regression.

> Please revert it before the merge window closes.

I'm sending it right now.

> <rant>
> I have no time to make improvements that I want to make, much less waste
> my *VOLUNTEER* time on *REGRESSIONS* that *I DID NOT INTRODUCE*.
> 
> It bothers me enough, that as a volunteer, I have to clean up other
> people's untested cr*pware.  AND, that as the lucky individual who finds
> the bugs, I have to do additional work to get fixes back into stable
> kernels.

Shit happens. A patch adding support for one board might cause regression on
other boards, as it is not likely that the author of the patch have all
boards that could potentially be affected. That's why we have a long rc
period, where people with different hardware are expected to test the -rc
kernels and point for regressions.

Mauro.
