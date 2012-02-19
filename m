Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab2BSMv5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 07:51:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38147 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389Ab2BSMv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 07:51:56 -0500
Date: Sun, 19 Feb 2012 13:51:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Stultz <johnstul@us.ibm.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Jack Steiner <steiner@sgi.com>
Subject: Re: [PATCH] x86 uv: lower UV rtc clocksource rating
Message-ID: <20120219125132.GC25900@elte.hu>
References: <20120216201042.GA10260@sgi.com>
 <20120217120242.GC25601@elte.hu>
 <20120217141641.GA28063@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217141641.GA28063@sgi.com>
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

* Dimitri Sivanich <sivanich@sgi.com> wrote:

> On Fri, Feb 17, 2012 at 01:02:42PM +0100, Ingo Molnar wrote:
> > 
> > * Dimitri Sivanich <sivanich@sgi.com> wrote:
> > 
> > > Lower the rating of the UV rtc clocksource to just below that of the tsc.
> > 
> > This changelog is deficient for obvious reasons, mind updating 
> > it?
> >
> OK.  Is this sufficient?
> 
> 
> Lower the rating of the UV rtc clocksource to just below that of the tsc.
> 
> Reading the tsc clocksource has lower latency than reading the rtc, so favor
> it in situations where it is synchronized and stable.  When the tsc is
> unsynchronized, the rtc needs to be the chosen clocksource.

Yeah, perfect, thanks.

	Ingo
