Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1H3WnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 18:43:13 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:59724 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752446Ab1H3WnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 18:43:12 -0400
X-Sasl-enc: XZyIN7fuRg1jPJBqsyv7szUxdOrLEcOs3xtZLisKFN9w 1314744191
Date: Tue, 30 Aug 2011 15:38:29 -0700
From: Greg KH <greg@kroah.com>
To: Faidon Liambotis <paravoid@debian.org>
Cc: linux-kernel@vger.kernel.org, seto.hidetoshi@jp.fujitsu.com,
        Peter Zijlstra <peterz@infradead.org>,
        MINOURA Makoto <minoura@valinux.co.jp>, Ingo Molnar <mingo@elte.hu>,
        stable@kernel.org,
        =?iso-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        john stultz <johnstul@us.ibm.com>, Rand@jasper.es,
        Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>
Subject: Re: [stable] 2.6.32.21 - uptime related crashes?
Message-ID: <20110830223829.GB17450@kroah.com>
References: <20110712041938.GO27254@1wt.eu>
 <1310690138.3367.61.camel@work-vm>
 <1310724097.2586.296.camel@twins>
 <1310752795.2945.4.camel@work-vm>
 <20110721072256.GE9216@elte.hu>
 <1311251098.29152.130.camel@twins>
 <20110721125008.GF11246@pcnci.linuxbox.cz>
 <1311252799.29152.147.camel@twins>
 <20110721184524.GB381@elte.hu>
 <20110825185616.GA17078@faidon.noc.grnet.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110825185616.GA17078@faidon.noc.grnet.gr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 09:56:16PM +0300, Faidon Liambotis wrote:
> On Thu, Jul 21, 2011 at 08:45:25PM +0200, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Thu, 2011-07-21 at 14:50 +0200, Nikola Ciprich wrote:
> > > > thanks for the patch! I'll put this on our testing boxes...
> > > 
> > > With a patch that frobs the starting value close to overflowing I hope,
> > > otherwise we'll not hear from you in like 7 months ;-)
> > > 
> > > > Are You going to push this upstream so we can ask Greg to push this to
> > > > -stable? 
> > > 
> > > Yeah, I think we want to commit this with a -stable tag, Ingo?
> > 
> > yeah - and we also want a Reported-by tag and an explanation of how 
> > it can crash and why it matters in practice. I can then stick it into 
> > the urgent branch for Linus. (probably will only hit upstream in the 
> > merge window though.)
> 
> Has this been pushed or has the problem been solved somehow? Time is
> against us on this bug as more boxes will crash as they reach 200 days
> of uptime...
> 
> In any case, feel free to use me as a Reported-by, my full report of the
> problem being <20110430173905.GA25641@tty.gr>.
> 
> FWIW and if I understand correctly, my symptoms were caused by *two*
> different bugs:
> a) the 54 bits wraparound at 208 days that Peter fixed above,
> b) a kernel crash at ~215 days related to RT tasks, fixed by
> 305e6835e05513406fa12820e40e4a8ecb63743c (already in -stable).

So, what do I do here as part of the .32-longterm kernel?  Is there a
fix that is in Linus's tree that I need to apply here?

confused,

greg k-h
