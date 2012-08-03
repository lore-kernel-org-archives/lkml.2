Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272Ab2HCGfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 02:35:37 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48539 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab2HCGff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 02:35:35 -0400
Date: Fri, 3 Aug 2012 08:35:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] Was: Re: [GIT PULL] timer changes for v3.6, Is:
 Regression introduced by 1e75fa8be9fb61e1af46b5b3b176347a4c958ca1
Message-ID: <20120803063529.GA12424@gmail.com>
References: <20120722133441.GA6874@gmail.com>
 <20120723144917.GF793@phenom.dumpdata.com>
 <500D8CDD.3060309@linaro.org>
 <20120723182431.GD21870@phenom.dumpdata.com>
 <500D9EBC.204@linaro.org>
 <20120723195144.GA3454@phenom.dumpdata.com>
 <500DB2E2.6070703@linaro.org>
 <CA+55aFwK8y2p=m7fEQxiHj0L8BKEpiHDX=cKX80XgAT9DLs6Sg@mail.gmail.com>
 <501B1B38.3060808@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501B1B38.3060808@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stultz <john.stultz@linaro.org> wrote:

> On 08/02/2012 04:52 PM, Linus Torvalds wrote:
> >On Mon, Jul 23, 2012 at 1:24 PM, John Stultz <john.stultz@linaro.org> wrote:
> >> Great! Thanks again so much for the testing and quick 
> >> reporting!
> > Hmm. I'm just cutting 3.6-rc1, and noticing that apparently 
> > this patch never reached me. So now -rc1 is broken on 32 bit 
> > under Xen.
> >
> > I'm not going to delay rc1 for this, but I thought I'd point 
> > this out in the hope that we get it fixed soon. I'll be 
> > around for small fixes for another day and a half before I'm 
> > traveling for vacation.
> 
> Yea, the fix has been sitting in tip/timers/urgent.  I heard 
> Thomas was on vacation, so maybe that's why he's not sent the 
> pull request?
> 
> Ingo, could you make the pull request?  Sorry if the commit 
> log didn't make it clear this was more urgent.

Yeah, it's pending - I've got some other urgent bits pending as 
well, will send the timers/urgent bits with them later today.

Thanks,

	Ingo
