Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab1B1SaD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 13:30:03 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:36786 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752695Ab1B1SaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 13:30:00 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX192WQAsiIV2OQ+oahZc/3BjVCDsRI5FAr8T24Hshs
	xaj8rSqRHiai5r
Subject: Re: [patch] Re: autogroup: sched_setscheduler() fails
From: Mike Galbraith <efault@gmx.de>
To: torbenh <torbenh@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Yong Zhang <yong.zhang0@gmail.com>, bharata@linux.vnet.ibm.com,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, linux-audio-dev@music.columbia.edu,
        linux-audio-user@music.columbia.edu
In-Reply-To: <20110228175303.GG2977@siel.b>
References: <1294810842.8370.7.camel@marge.simson.net>
	 <AANLkTimtwt+OGohMxGRC7L4Dm-h4wvCWYi-=13efqFtr@mail.gmail.com>
	 <1294890890.8089.39.camel@marge.simson.net>
	 <1295270160.30950.96.camel@laptop> <20110215154612.GI3055@siel.b>
	 <1297788210.15382.51.camel@marge.simson.net> <20110218110955.GA3124@siel.b>
	 <1298033412.8735.30.camel@marge.simson.net> <20110222122449.GC11548@siel.b>
	 <1298386073.8036.49.camel@marge.simson.net>  <20110228175303.GG2977@siel.b>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Feb 2011 19:29:54 +0100
Message-ID: <1298917794.9387.31.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-28 at 18:53 +0100, torbenh wrote:
> 
> On Tue, Feb 22, 2011 at 03:47:53PM +0100, Mike Galbraith wrote:
> > On Tue, 2011-02-22 at 13:24 +0100, torbenh wrote:
> > > On Fri, Feb 18, 2011 at 01:50:12PM +0100, Mike Galbraith wrote:
>  
> > > > Sounds like you just want to turn CONFIG_RT_GROUP_SCHED off.
> > > 
> > > but distros turn it on.
> > > we could prevent debian from turning it on. 
> > > now opensuse 11.4 has turned it on.
> > 
> > If you or anyone else turns on RT_GROUP_SCHED, you will count your
> > beans, and pay up front, or you will not play.  That's a very sensible
> > policy for realtime.
> 
> this probably means that generic computer distros should not turn this
> option on ?

Yeah, agreed, not for a great default config, but only because
newfangled automation thingies can't (possibly?) deal with it sanely.
 
> > If systemd deals with it at all, seems to me it can only make a mess of
> > it.  But who knows, maybe they made a clever allocator.  If they didn't,
> > they'll need an escape hatch methinks.
> 
> the problem is that audio applications can not really pre allocate their
> cpu needs. user can add processing plugins until he pushes his machine
> to the limit. (or the cgroup where his process is running in)
> 
> we dont really have a mechanism for plugins to publish their needed
> cycles.

I can't see how it could matter what any individual group of arbitrary
groups N (who can appear/disappear in the blink of an eye) advertises as
it's wish of the instant.  "Hard" + "Arbitrary" doesn't compute for me.

	-Mike

