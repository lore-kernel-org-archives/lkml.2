Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab1AGNFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 08:05:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46155 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab1AGNFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 08:05:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EZfK9fu6rT71YQWjK2odcVLEHzWLnFhl67hADLq8DCuIbrI5yt0t1rzblCZJZ/rt0D
         MG/qXFIPE514YzxG+ujskQDvb9Uxf2DSdTizzvq2aKCS4qUA5hbAeOr56sL5RVi/OOeS
         flQj7/IEA80bD4UIe2Pz/gQM3xe3mE+2qqv9Q=
Message-ID: <4D270F85.9070705@gmail.com>
Date: Fri, 07 Jan 2011 08:05:09 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [058/152] tcp: protect sysctl_tcp_cookie_size reads
References: <20110106002302.141581701@clark.site>	 <4D2691D4.3060304@gmail.com> <1294389025.2704.95.camel@edumazet-laptop>
In-Reply-To: <1294389025.2704.95.camel@edumazet-laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/7/11 3:30 AM, Eric Dumazet wrote:
> Are you telling us somebody else added bug to your code ?
> This is not the case, obviously.
>
As I noted, "There's been quite a few changes" -- one of which was a major
change to sysctls.  As one of the reviewers of this code, you didn't mention
this ACCESS_ONCE() function, so I'm assuming it didn't exist at that time.


> After bug fix and cleanup code

As I noted, "most of the patch has nothing to do with the purported fix."
That makes the patch hard to read and evaluate.

Moreover, I remember being castigated (by you and others) for combining bug
fixes with cleanup code.  And I'm not sure this counts as "cleanup" code.

> looks good,

As the saying goes, beauty is in the eye of the beholder.  Trading a blank
line for a trailing brace is neither here nor there.  Screen space used
remains the same.

> and even checkpatch.pl is
> fine with it. No need for useless brackets around "return XXX;"

My instructors would have flunked me for not including braces around
multi-line sequences; it was one of the great no-no's of the '70s.  Perhaps
that's not the case anymore with modern colorful visual syntax checkers?


> If I remember well, I did the cleanup so that my patch could not trigger
> checkpatch.pl errors/warnings. Not that I am a particular checkpatch
> fan, but I know some people are.
>
As a relative Linux kernel newbie, I scrupulously followed patch
instructions.  Those instructions mandated running checkpatch.

If there are now "checkpatch.pl errors/warnings" on that code, checkpatch
must have changed.  At the time, all multi-line sequences were required to
be enclosed in braces.

I still think that's a better idea, looks better, and makes maintenance
easier in the long term.  YMMV.


> By the way, you were CCed when I sent one month ago the mail to
> David/netdev. And no reaction from you at that time.
>
Amazingly enough, my life is not centered around Linux on a day-to-day
basis.  Young folks like you are trying to make a name for yourselves in
the Linux world -- apparently, by being exceptionally abrasive.

Your helpful comments are/were appreciated.
