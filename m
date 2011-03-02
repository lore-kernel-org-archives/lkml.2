Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab1CBJ65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 04:58:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60687 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756432Ab1CBJ6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 04:58:55 -0500
Date: Wed, 2 Mar 2011 10:58:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org,
        linux-hotplug@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        amit.kucheria@linaro.org, rusty@rustcorp.com.au
Subject: Re: [PATCH V6 2/2] tracing, perf: add cpu hotplug trace events
Message-ID: <20110302095847.GA24111@elte.hu>
References: <AANLkTi=WRo41JprvcEH0Lgc_-j_bTX1MULgJFShV6W9g@mail.gmail.com>
 <alpine.LFD.2.00.1103021033260.2701@localhost6.localdomain6>
 <AANLkTikzfNsB=9jQSYrWDEYd3Kd1-d8cVMO79ZqDNt4n@mail.gmail.com>
 <alpine.LFD.2.00.1103021053480.2701@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1103021053480.2701@localhost6.localdomain6>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Wed, 2 Mar 2011, Vincent Guittot wrote:
> 
> > On 2 March 2011 10:38, Thomas Gleixner <tglx@linutronix.de> wrote:
> > > On Tue, 1 Mar 2011, Vincent Guittot wrote:
> > >
> > >> Trace the cpu state and the time spent in core and arch code
> > >
> > > So you completely ignored my review comments, except for fixing up the
> > > changelog.
> > >
> > >        https://lkml.org/lkml/2011/2/24/297
> > >
> > > All of the comments in the code still apply and either you fix it or
> > > at least have the courtesy to explain why you think that those
> > > comments do not need to be addressed.
> > >
> > 
> > I thought that I have answered to your comments :
> > https://lkml.org/lkml/2011/2/28/203
> > 
> > Do I miss something ?
> 
> Oops, my bad. I missed that reply somehow. It's not in my inbox. Will
> dig into my lkml archive then.

Hm, same here, i only got that reply from lkml, never via direct mail delivery. So 
something ate the straight path of that mail.

Thanks,

	Ingo
