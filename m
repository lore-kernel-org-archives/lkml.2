Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab1LKPth (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 10:49:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45962 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036Ab1LKPtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 10:49:36 -0500
Date: Sun, 11 Dec 2011 16:47:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        acme@infradead.org, robert.richter@amd.com, ming.m.lin@intel.com,
        andi@firstfloor.org, asharma@fb.com
Subject: Re: [PATCH 2/4] perf_event: add PERF_COUNT_HW_REF_CPU_CYCLES generic
 PMU event
Message-ID: <20111211154742.GA1213@elte.hu>
References: <1323559734-3488-1-git-send-email-eranian@google.com>
 <1323559734-3488-3-git-send-email-eranian@google.com>
 <20111211080138.GB20790@elte.hu>
 <1323608131.16764.19.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323608131.16764.19.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Sun, 2011-12-11 at 09:01 +0100, Ingo Molnar wrote:
> > > +     PERF_COUNT_HW_REF_CPU_CYCLES            = 9,
> > 
> > Btw., that was what 'bus cycles' tried to do a long time ago: 
> > the constant, non-variable baseline heartbeat of the system. 
> 
> This isn't about that. Its about exposing the third fixed 
> purpose counter. Intel, in their infinite wisdom, created a 
> fixed purpose counter for which there is no equivalent in the 
> general purpose events.
> 
> Our fixed purpose counter support is predicated on the 
> assumption that there is, and simply maps any event code to 
> also include the fixed purpose counter if appropriate.
> 
> There not being an event to map from has thus far avoided 
> exposing this third fixed purpose event.
> 
> The problem with remapping BUS_CYCLES is that BUS_CYCLES (now) 
> is something you can program on the {2,4,8} general purpose 
> counters, whereas this new thing can only ever be ran from the 
> 1 fixed purpose counter.

Okay - if we want/need 3 variants then i have no objections.

Thanks,

	Ingo
