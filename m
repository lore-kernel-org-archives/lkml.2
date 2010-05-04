Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab0EDGvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 02:51:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39023 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754696Ab0EDGvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 02:51:08 -0400
Date: Tue, 4 May 2010 08:50:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <peterz@infradead.org>,
       Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_event: Use UTF-8 copyright symbol instead of \251
Message-ID: <20100504065050.GD10464@elte.hu>
References: <20100501002811.GA2610@brick.ozlabs.ibm.com>
 <alpine.LNX.2.00.1005031541390.9849@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1005031541390.9849@pobox.suse.cz>
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


* Jiri Kosina <jkosina@suse.cz> wrote:

> On Sat, 1 May 2010, Paul Mackerras wrote:
> 
> > As noted by Tejun Heo, the latin-1 copyright character \251 is invalid
> > in ASCII or UTF-8.  This changes the character to its UTF-8 encoding
> > in order to avoid problems with editors and other tools.
> > 
> > Signed-off-by: Paul Mackerras <paulus@samba.org>
> > ---
> > diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> > index 9dbe8cd..d46a277 100644
> > --- a/kernel/perf_event.c
> > +++ b/kernel/perf_event.c
> > @@ -4,7 +4,7 @@
> >   *  Copyright (C) 2008 Thomas Gleixner <tglx@linutronix.de>
> >   *  Copyright (C) 2008-2009 Red Hat, Inc., Ingo Molnar
> >   *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
> > - *  Copyright  ???  2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
> 
> Umm ... this looks odd.

Yeah, and it didnt apply when i tried to.

> > + *  Copyright  ??  2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
> 
> This seems to add \251 again :) Maybe some of your tools got confused 
> enough?
> 
> Anyway, I have dropped the patch from Tejun for now.

Alternatively you could pick up Paul's patch on top of Tejun's if you have 
already pushed the commit ID out and want to avoid a rebase.

Thanks,

	Ingo
