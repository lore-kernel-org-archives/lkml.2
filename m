Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab1D0GxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 02:53:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42240 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594Ab1D0GxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 02:53:07 -0400
Date: Wed, 27 Apr 2011 08:52:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
Message-ID: <20110427065241.GF17079@elte.hu>
References: <1303407662-15564-1-git-send-email-acme@infradead.org>
 <1303407662-15564-2-git-send-email-acme@infradead.org>
 <20110422063429.GA16643@elte.hu>
 <20110422080604.GA22611@elte.hu>
 <alpine.DEB.2.00.1104251307010.12389@cl320.eecs.utk.edu>
 <20110425175444.GC28239@elte.hu>
 <alpine.DEB.2.00.1104251736220.12389@cl320.eecs.utk.edu>
 <20110426073847.GB30630@elte.hu>
 <alpine.DEB.2.00.1104261648400.32482@cl320.eecs.utk.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1104261648400.32482@cl320.eecs.utk.edu>
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


* Vince Weaver <vweaver1@eecs.utk.edu> wrote:

> On Tue, 26 Apr 2011, Ingo Molnar wrote:
> 
> > The kernel development process is in essence an abstraction engine, and if 
> > you expect something else you'll probably be facing a lot of frustrating 
> > episodes in the future as well where others try to abstract out meaningful 
> > generalizations.
> 
> yes, but you are taking abstraction to the extreme.

Firstly, that claim is a far cry from your original claim:

   ' How do you "generalize" a functionality like writing a value to an auxiliary
     MSR register? '

... so i guess you conceded the point at least partially, without actually 
openly and honestly conceding the point?

Secondly, you are still quite wrong even with your revised opinion. Being able 
to type '-e cycles' and '-e instructions' in perf and get ... cycles and 
instructions counts/events, and the kernel helping that kind of approach is not 
'abstraction to the extreme', it's called 'common sense'.

The fact that perfmon and oprofile works via magic vendor-specific event string 
incantations is one of the many design failures of those projects - not a 
virtue.

Thanks,

	Ingo
