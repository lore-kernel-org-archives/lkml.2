Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759190Ab1DPKO1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 06:14:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56349 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759127Ab1DPKOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 06:14:22 -0400
Date: Sat, 16 Apr 2011 12:14:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 4/4] perf, x86: Fix event scheduler to solve complex
 scheduling problems
Message-ID: <20110416101406.GA11534@elte.hu>
References: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
 <1302913676-14352-5-git-send-email-robert.richter@amd.com>
 <1302943877.32491.9.camel@twins>
 <20110416094348.GA24711@elte.hu>
 <1302948520.32491.10.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302948520.32491.10.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Sat, 2011-04-16 at 11:43 +0200, Ingo Molnar wrote:
> > I'd also prefer if we first had actual testcases in 'perf test' for all these 
> > failures - it took an *awfully* long time to find these regressions (the event 
> > scheduler code has been committed for months), while with proper testcases it 
> > would only take a second to run 'perf test'. 
> 
> These cases only exist on AMD F15, I don't think there's many people
> with such systems around.

Well, if the trend continues we'll have more twisted constraints and more bugs 
of this sort, so having a testsuite sure cannot hurt, right?

Thanks,

	Ingo
