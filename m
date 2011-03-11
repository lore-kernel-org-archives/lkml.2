Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab1CKJnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 04:43:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37552 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab1CKJno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 04:43:44 -0500
Date: Fri, 11 Mar 2011 10:43:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        jan.kratochvil@redhat.com, Denys Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110311094313.GA4870@elte.hu>
References: <20110301152457.GE26074@htj.dyndns.org>
 <20110307204346.19557183C29@magilla.sf.frob.com>
 <20110309102855.GC27010@htj.dyndns.org>
 <20110310183305.GD12521@home.goodmis.org>
 <20110311082240.GA7624@elte.hu>
 <20110311093512.GA1815@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110311093512.GA1815@linux.vnet.ibm.com>
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


* Srikar Dronamraju <srikar@linux.vnet.ibm.com> wrote:

> > 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > I don't think perf has a good way to trace userspace yet.
> > 
> > uprobes are being worked on (and that comes integrated with perf), and that will 
> > give a good mechanism - and it (of course) wont be doing any context-switching.
> > 
> 
> > Peter might be able to fill us in on the details of the review progress of the 
> > uprobes patches.
> 
> Just an update on uprobes.
> I am currently testing my next version of uprobes and I should be
> sending it out for review next monday.

Great, thanks!

	Ingo
