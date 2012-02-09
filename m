Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab2BINbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 08:31:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59682 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab2BINbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 08:31:17 -0500
Date: Thu, 9 Feb 2012 14:31:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Anton Blanchard <anton@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, emunson@mgebm.net,
        imunsie@au1.ibm.com, eranian@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf annotate: Numeric assembly labels cause incorrect
 annotation
Message-ID: <20120209133101.GC8830@elte.hu>
References: <20120207145535.71b9f22d@kryten>
 <20120207144033.GB2172@infradead.org>
 <1328782223.9303.3.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328782223.9303.3.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> On Tue, 2012-02-07 at 12:40 -0200, Arnaldo Carvalho de Melo wrote: 
> > Em Tue, Feb 07, 2012 at 02:55:35PM +1100, Anton Blanchard escreveu:
> > > 
> > > A perf annotate of a kernel function written in assembly shows
> > > very strange percentages:
> > 
> > Thanks! I think this is the same problem Mike Galbraith noticed and
> > reported me (I guess that was in a private message), Mike, can you
> > please test it so that I can add more Foo-by stamps to this one?
> 
> Sorry for the slow response (bz bz).
> 
> I don't see that problem, but perf top annotation isn't 
> working properly in tip at least.  It seems to have forgotten 
> how to average, seems to be clearing hit counts at every 
> screen refresh or something.

hm, seems to work fine here. We used to have such a bug recently 
(as of a few weeks [days?] ago), but latest -tip does not show 
those symptoms.

Thanks,

	Ingo
