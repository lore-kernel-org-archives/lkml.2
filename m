Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab1LEQ4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 11:56:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41707 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932436Ab1LEQ4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 11:56:20 -0500
Date: Mon, 5 Dec 2011 17:53:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <greg@kroah.com>
Cc: john stultz <johnstul@us.ibm.com>, Willy Tarreau <w@1wt.eu>,
        Ruben Kerkhof <ruben@rubenkerkhof.com>, linux-kernel@vger.kernel.org,
        seto.hidetoshi@jp.fujitsu.com, Peter Zijlstra <peterz@infradead.org>,
        MINOURA Makoto <minoura@valinux.co.jp>, stable@vger.kernel.org,
        =?iso-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        Rand@jasper.es, Andrew Morton <akpm@linux-foundation.org>,
        Faidon Liambotis <paravoid@debian.org>
Subject: Re: [stable] 2.6.32.21 - uptime related crashes?
Message-ID: <20111205165338.GF25909@elte.hu>
References: <20110721184524.GB381@elte.hu>
 <20110825185616.GA17078@faidon.noc.grnet.gr>
 <20110830223829.GB17450@kroah.com>
 <20110904232657.GC6749@tty.gr>
 <CAPed3OHzO5usHfyeD_rK8dDhcGakZF+ByzEyZZb_Tdh3U00vOg@mail.gmail.com>
 <1319582670.17505.31.camel@work-vm>
 <20111025232545.GB14714@1wt.eu>
 <20111202234537.GB3818@kroah.com>
 <1322870543.21423.186.camel@work-vm>
 <20111203010232.GA4810@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111203010232.GA4810@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg KH <greg@kroah.com> wrote:

> On Fri, Dec 02, 2011 at 04:02:23PM -0800, john stultz wrote:
> > On Fri, 2011-12-02 at 15:45 -0800, Greg KH wrote:
> > > On Wed, Oct 26, 2011 at 01:25:45AM +0200, Willy Tarreau wrote:
> > > > Hi John,
> > > > 
> > > > On Tue, Oct 25, 2011 at 03:44:30PM -0700, john stultz wrote:
> > > > > The softlockup false positive issue should have been fixed by Peter's
> > > > > "x86, intel: Don't mark sched_clock() as stable" below. But I'm not
> > > > > seeing it upstream.  Peter, is this still the right fix?
> > > > 
> > > > I've not seen any other one proposed, and both you and Peter appeared
> > > > to like it. I understood that Ingo was waiting for the merge window to
> > > > submit it and I think that it simply got lost.
> > > > 
> > > > Ingo, can you confirm ?
> > > 
> > > I'm totally confused here, what's the status of this, and what exactly
> > > is the patch?
> > 
> > Ingo has the fix from Salman queued in -tip, but I'm not sure why its
> > not been pushed to Linus yet.
> > 
> > http://git.kernel.org/?p=linux/kernel/git/tip/tip.git;a=commit;h=4cecf6d401a01d054afc1e5f605bcbfe553cb9b9
> 
> Wonderful, thanks for pointing this out to me.
> 
> Ingo, any idea when this will go to Linus's tree?

today if everything goes fine.

Thanks,

	Ingo
