Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab2BINYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 08:24:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53744 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643Ab2BINYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 08:24:24 -0500
Date: Thu, 9 Feb 2012 14:23:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, jk@novozymes.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>
Subject: Re: Memory issues with Opteron 6220
Message-ID: <20120209132359.GA8830@elte.hu>
References: <20120208143741.GB28486@otto.nzcorp.net>
 <20120209083315.GA19380@elte.hu>
 <1328778529.2374.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1328778529.2374.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
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


* Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Le jeudi 09 février 2012 à 09:33 +0100, Ingo Molnar a écrit :
> > * Anders Ossowicki <aowi@novozymes.com> wrote:
> > 
> > > Hey,
> > > 
> > > We're seeing unexpected slowdowns and other memory issues with a new system.
> > > Enough to render it unusable. For example:
> > > 
> > > Error: open3: fork failed: Cannot allocate memory
> > > 
> > > at times where there's no real memory pressure:
> > >                    total       used       free     shared    buffers     cached
> > >       Mem:     132270720  131942388     328332          0     299768  103334420
> > >       -/+ buffers/cache:   28308200  103962520
> > >       Swap:      7811068      13760    7797308
> > >
> > > [...]
> > 
> > > The system is a Dell Poweredge R715, with two eight-core 
> > > Opteron 6220 processors and 128G of memory. We have several 
> > > similar systems, such as the one this should replace: R715, 
> > > 2x8 core Opteron 6140, 128G memory, and they do not exhibit 
> > > any similar symptoms.
> > 
> > 130 MB of RAM visible to Linux isn't the expected bootup default 
> > indeed. Around 130 *GB* would be expected ...
> 
> Not sure what you mean, I see 128GB in the "free" output, as 
> expected.

Erm, yes. I plead temporary blindness!

So all RAM is visible properly. This error:

> > > Error: open3: fork failed: Cannot allocate memory

suggests allocation failure. How is that possible with so much 
RAM?

Thanks,

	Ingo
