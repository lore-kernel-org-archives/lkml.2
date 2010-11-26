Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab0KZHjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 02:39:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49819 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860Ab0KZHjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 02:39:04 -0500
Date: Fri, 26 Nov 2010 08:38:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Kyle Moffett <kyle@moffetthome.net>, Marcus Meissner <meissner@suse.de>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        tj@kernel.org, akpm@osdl.org, hpa@zytor.com, w@1wt.eu,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
Message-ID: <20101126073834.GC19589@elte.hu>
References: <20101116104600.GA24015@suse.de>
 <AANLkTi=F1vbwpOzyN9o0nuRtsEUTQx2j3==kLu9j7Ccb@mail.gmail.com>
 <20101118073126.GB32621@elte.hu>
 <20101123172437.GB8412@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101123172437.GB8412@ucw.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> > >   (2) Most of the arguments about introducing "uncertainty" into the
> > > hacking process are specious as well. [...]
> > 
> > It is only specious if you ignore the arguments i made in the previous
> > discussion. One argument i made was:
> 
> Well, but it has downsides, too.
> 
> If I know school server is vulnerable, I can get admin to fix it... if
> I can see dmesg without being root, I can help with problems. I have
> done both before...

Yeah, restricting information is always a double edged sword - and by locking down 
we are implicitly assuming that the number of people trying to do harm is larger 
than the number of people trying to help. It is probably true though - and the 
damage they can inflict is becoming more and more serious (financially, legally and 
socially - and, in some cases, physically) with every year of humanity moving their 
lives to the 'net.

So yes, the time has probably come to lock up "potentially harmful" information from 
the default unprivileged user on Linux - at least from a default kernel policies 
POV.

Thanks,

	Ingo
