Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab0IIHij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 03:38:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47723 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab0IIHie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 03:38:34 -0400
Date: Thu, 9 Sep 2010 09:38:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Tom Zanussi <tzanussi@gmail.com>,
        =?us-ascii?B?PT9pc28tODg1OS0xP1E/RnI9RTlkPUU5cmljPz0=?= Weisbecker 
	<fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
Message-ID: <20100909073803.GB6829@elte.hu>
References: <4C84E265.1020402@redhat.com>
 <20100906125905.GA25414@elte.hu>
 <4C850147.8010908@redhat.com>
 <20100906154737.GA4332@elte.hu>
 <4C852B2A.2030103@redhat.com>
 <20100907034417.GA14046@elte.hu>
 <20100908014409.GA17010@brick.ozlabs.ibm.com>
 <AANLkTi=YdAxdGv1nEEZ4w0jM0K3ss0g5x7_5cU8xNEhj@mail.gmail.com>
 <20100908064427.GD3439@elte.hu>
 <y0m39tkdocs.fsf@fche.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0m39tkdocs.fsf@fche.csb>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0053]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frank Ch. Eigler <fche@redhat.com> wrote:

> mingo wrote:

 - slightly disparaging author quotation style: check

> > [...] Do you know some interesting usecase that would be excluded
> > via such address restrictions?
> 
> You could study tracing-oriented runtime systems such as those of
> dtrace, dprobes, or even systemtap, to help answer such questions.

 - slightly superior sounding style of discussion: check

> > Things like flexible arrays or more complex data structures such as
> > trees couldnt be used initially. More complex data structures would
> > need locking in any case. [...]  I.e. it would initially be
> > restricted roughly to code where halting can be proven. Still looks
> > interesting to me [...]
> 
> There are years of experience out there to learn from.  Note the sorts 
> of filtering expressions (never mind control logic) used in the prior 
> art, so that you can know what you're about to sacrifice by a 
> simple-sounding implementation.

 - offhanded, patronizing tone: check

 - widespread lack of specifics: check

 - dissing others while promoting systemtap: check

... so i dont really need to look at the 'From' field to see that this 
reply can only have come from 'fche'!

Thanks,

	Ingo
