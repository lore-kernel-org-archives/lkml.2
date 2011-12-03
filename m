Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab1LCHMt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 02:12:49 -0500
Received: from 1wt.eu ([62.212.114.60]:36186 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649Ab1LCHMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 02:12:48 -0500
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Dec 2011 02:12:47 EST
Date: Sat, 3 Dec 2011 08:00:53 +0100
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>, Greg KH <greg@kroah.com>,
        Ruben Kerkhof <ruben@rubenkerkhof.com>, linux-kernel@vger.kernel.org,
        seto.hidetoshi@jp.fujitsu.com, Peter Zijlstra <peterz@infradead.org>,
        MINOURA Makoto <minoura@valinux.co.jp>, stable@vger.kernel.org,
        Rand@jasper.es, Andrew Morton <akpm@linux-foundation.org>,
        Faidon Liambotis <paravoid@debian.org>
Subject: Re: [stable] 2.6.32.21 - uptime related crashes?
Message-ID: <20111203070053.GH27965@1wt.eu>
References: <20110721184524.GB381@elte.hu> <20110825185616.GA17078@faidon.noc.grnet.gr> <20110830223829.GB17450@kroah.com> <20110904232657.GC6749@tty.gr> <CAPed3OHzO5usHfyeD_rK8dDhcGakZF+ByzEyZZb_Tdh3U00vOg@mail.gmail.com> <1319582670.17505.31.camel@work-vm> <20111025232545.GB14714@1wt.eu> <20111202234537.GB3818@kroah.com> <1322870543.21423.186.camel@work-vm> <20111203010232.GA4810@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111203010232.GA4810@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 05:02:32PM -0800, Greg KH wrote:
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

Yes please Ingo, do not delay it any further, this is becoming a real
problem, there are people who monitor their uptime to plan a reboot
before 200 days. We shouldn't need to wait for the next merge window,
the patch is already 15 days old and is a fix for a real-world stability
issue !

Thanks,
Willy

