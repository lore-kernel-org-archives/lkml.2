Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1LCACh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 19:02:37 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48607 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459Ab1LCACf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 19:02:35 -0500
Message-ID: <1322870543.21423.186.camel@work-vm>
Subject: Re: [stable] 2.6.32.21 - uptime related crashes?
From: john stultz <johnstul@us.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: Willy Tarreau <w@1wt.eu>, Ruben Kerkhof <ruben@rubenkerkhof.com>,
        linux-kernel@vger.kernel.org, seto.hidetoshi@jp.fujitsu.com,
        Peter Zijlstra <peterz@infradead.org>,
        MINOURA Makoto <minoura@valinux.co.jp>, Ingo Molnar <mingo@elte.hu>,
        stable@kernel.org,
        =?ISO-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        Rand@jasper.es, Andrew Morton <akpm@linux-foundation.org>,
        Faidon Liambotis <paravoid@debian.org>
Date: Fri, 02 Dec 2011 16:02:23 -0800
In-Reply-To: <20111202234537.GB3818@kroah.com>
References: <1311251098.29152.130.camel@twins>
	 <20110721125008.GF11246@pcnci.linuxbox.cz>
	 <1311252799.29152.147.camel@twins> <20110721184524.GB381@elte.hu>
	 <20110825185616.GA17078@faidon.noc.grnet.gr>
	 <20110830223829.GB17450@kroah.com> <20110904232657.GC6749@tty.gr>
	 <CAPed3OHzO5usHfyeD_rK8dDhcGakZF+ByzEyZZb_Tdh3U00vOg@mail.gmail.com>
	 <1319582670.17505.31.camel@work-vm> <20111025232545.GB14714@1wt.eu>
	 <20111202234537.GB3818@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11120300-8974-0000-0000-000003DF241C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-02 at 15:45 -0800, Greg KH wrote:
> On Wed, Oct 26, 2011 at 01:25:45AM +0200, Willy Tarreau wrote:
> > Hi John,
> > 
> > On Tue, Oct 25, 2011 at 03:44:30PM -0700, john stultz wrote:
> > > The softlockup false positive issue should have been fixed by Peter's
> > > "x86, intel: Don't mark sched_clock() as stable" below. But I'm not
> > > seeing it upstream.  Peter, is this still the right fix?
> > 
> > I've not seen any other one proposed, and both you and Peter appeared
> > to like it. I understood that Ingo was waiting for the merge window to
> > submit it and I think that it simply got lost.
> > 
> > Ingo, can you confirm ?
> 
> I'm totally confused here, what's the status of this, and what exactly
> is the patch?

Ingo has the fix from Salman queued in -tip, but I'm not sure why its
not been pushed to Linus yet.

http://git.kernel.org/?p=linux/kernel/git/tip/tip.git;a=commit;h=4cecf6d401a01d054afc1e5f605bcbfe553cb9b9

thanks
-john

