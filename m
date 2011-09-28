Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab1I1Q61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 12:58:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52929 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737Ab1I1Q60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 12:58:26 -0400
Date: Wed, 28 Sep 2011 18:56:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jiri Olsa <jolsa@redhat.com>,
        acme@redhat.com, eric.dumazet@gmail.com, a.p.zijlstra@chello.nl,
        paulus@samba.org, linux-kernel@vger.kernel.org, nhorman@tuxdriver.com
Subject: Re: [PATCHv2 1/2] perf tools: Collect tracing event data files
 directly
Message-ID: <20110928165639.GA10084@elte.hu>
References: <20110925133406.GB2702@jolsa.brq.redhat.com>
 <1317028312-5156-1-git-send-email-jolsa@redhat.com>
 <1317028312-5156-2-git-send-email-jolsa@redhat.com>
 <1317044192.26514.1.camel@gandalf.stny.rr.com>
 <20110926145606.GA8886@jolsa.brq.redhat.com>
 <20110928135525.GS18553@somewhere>
 <1317218589.4588.4.camel@gandalf.stny.rr.com>
 <20110928141754.GT18553@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110928141754.GT18553@somewhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > > But it seems Steve's patches are not completely uncontroversial 
> > > because of some crazy disagreements on where the 
> > > libparsevent.so should lay (tools generic or tied to perf).
> > 
> > Which to me seems to be a silly road block, in which I never got 
> > a clear answer for.
> 
> Yeah we need to sort that out with Ingo.

Basically, since it's not at all clear to me where these things (and 
APIs) will go, I'd be much more comfortable with this starting out as 
tools/perf/lib/ - we can still split it out later on. Merging it in 
will be a lot harder.

Thanks,

	Ingo
