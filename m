Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab1LBXr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 18:47:29 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:48881 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752533Ab1LBXrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 18:47:04 -0500
X-Sasl-enc: /SoHNoX7tjA80DLbXok6g7AC8sef4PZy9R7iIzqC1G99 1322869623
Date: Fri, 2 Dec 2011 15:45:37 -0800
From: Greg KH <greg@kroah.com>
To: Willy Tarreau <w@1wt.eu>
Cc: john stultz <johnstul@us.ibm.com>, Ruben Kerkhof <ruben@rubenkerkhof.com>,
        linux-kernel@vger.kernel.org, seto.hidetoshi@jp.fujitsu.com,
        Peter Zijlstra <peterz@infradead.org>,
        MINOURA Makoto <minoura@valinux.co.jp>, Ingo Molnar <mingo@elte.hu>,
        stable@kernel.org,
        =?iso-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        Rand@jasper.es, Andrew Morton <akpm@linux-foundation.org>,
        Faidon Liambotis <paravoid@debian.org>
Subject: Re: [stable] 2.6.32.21 - uptime related crashes?
Message-ID: <20111202234537.GB3818@kroah.com>
References: <1311251098.29152.130.camel@twins>
 <20110721125008.GF11246@pcnci.linuxbox.cz>
 <1311252799.29152.147.camel@twins>
 <20110721184524.GB381@elte.hu>
 <20110825185616.GA17078@faidon.noc.grnet.gr>
 <20110830223829.GB17450@kroah.com>
 <20110904232657.GC6749@tty.gr>
 <CAPed3OHzO5usHfyeD_rK8dDhcGakZF+ByzEyZZb_Tdh3U00vOg@mail.gmail.com>
 <1319582670.17505.31.camel@work-vm>
 <20111025232545.GB14714@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111025232545.GB14714@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 01:25:45AM +0200, Willy Tarreau wrote:
> Hi John,
> 
> On Tue, Oct 25, 2011 at 03:44:30PM -0700, john stultz wrote:
> > The softlockup false positive issue should have been fixed by Peter's
> > "x86, intel: Don't mark sched_clock() as stable" below. But I'm not
> > seeing it upstream.  Peter, is this still the right fix?
> 
> I've not seen any other one proposed, and both you and Peter appeared
> to like it. I understood that Ingo was waiting for the merge window to
> submit it and I think that it simply got lost.
> 
> Ingo, can you confirm ?

I'm totally confused here, what's the status of this, and what exactly
is the patch?

greg k-h
