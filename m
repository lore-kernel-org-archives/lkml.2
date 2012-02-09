Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686Ab2BIKKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 05:10:37 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:51095 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752268Ab2BIKKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 05:10:36 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/4VuxXwUP4hpPd4fanXRhRBQ2sWkBzt3Uqi5793U
	CdPzROCqc35Za4
Message-ID: <1328782223.9303.3.camel@marge.simpson.net>
Subject: Re: [PATCH] perf annotate: Numeric assembly labels cause incorrect
 annotation
From: Mike Galbraith <efault@gmx.de>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Anton Blanchard <anton@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, emunson@mgebm.net,
        imunsie@au1.ibm.com, eranian@google.com, linux-kernel@vger.kernel.org
Date: Thu, 09 Feb 2012 11:10:23 +0100
In-Reply-To: <20120207144033.GB2172@infradead.org>
References: <20120207145535.71b9f22d@kryten>
	 <20120207144033.GB2172@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-07 at 12:40 -0200, Arnaldo Carvalho de Melo wrote: 
> Em Tue, Feb 07, 2012 at 02:55:35PM +1100, Anton Blanchard escreveu:
> > 
> > A perf annotate of a kernel function written in assembly shows
> > very strange percentages:
> 
> Thanks! I think this is the same problem Mike Galbraith noticed and
> reported me (I guess that was in a private message), Mike, can you
> please test it so that I can add more Foo-by stamps to this one?

Sorry for the slow response (bz bz).

I don't see that problem, but perf top annotation isn't working properly
in tip at least.  It seems to have forgotten how to average, seems to be
clearing hit counts at every screen refresh or something.

-Mike

