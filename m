Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab0HCFvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 01:51:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33630 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820Ab0HCFvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 01:51:10 -0400
Date: Tue, 3 Aug 2010 07:51:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Scott Wood <scottwood@freescale.com>
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <peterz@infradead.org>,
        Kumar Gala <kumar.gala@freescale.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Please pull my perf.git urgent branch
Message-ID: <20100803055101.GC1130@elte.hu>
References: <20100727124019.GB14947@brick.ozlabs.ibm.com>
 <20100727112854.7bf97d48@schlenkerla.am.freescale.net>
 <20100728044731.GA2408@brick.ozlabs.ibm.com>
 <20100802171654.1776759c@schlenkerla.am.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802171654.1776759c@schlenkerla.am.freescale.net>
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


* Scott Wood <scottwood@freescale.com> wrote:

> On Wed, 28 Jul 2010 14:47:31 +1000
> Paul Mackerras <paulus@samba.org> wrote:
> 
> > On Tue, Jul 27, 2010 at 11:28:54AM -0500, Scott Wood wrote:
> > 
> > > Doesn't the setting of .period need to be maintained (it is in the other
> > > powerpc perf_event implementation that this is derived from)?
> > 
> > Gah, yes it does.
> 
> Well, looks like Linus pulled anyway...  I'll send a patch to
> add .period.

Yes, the original commit was already upstream when you reported this bug.

Paul added a -stable tag to the fix so it will get into the .35.1 pipeline 
this week.

Thanks,

	Ingo
