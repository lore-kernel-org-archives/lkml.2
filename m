Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab0IHTb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 15:31:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549Ab0IHTby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 15:31:54 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Tom Zanussi <tzanussi@gmail.com>,
        =?us-ascii?Q?=3D=3Fiso-8859-1=3FQ=3FFr=3DE9d=3DE9ric=3F=3D?=
	 Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
References: <4C84D77B.6040600@redhat.com> <20100906124330.GA22314@elte.hu>
	<4C84E265.1020402@redhat.com> <20100906125905.GA25414@elte.hu>
	<4C850147.8010908@redhat.com> <20100906154737.GA4332@elte.hu>
	<4C852B2A.2030103@redhat.com> <20100907034417.GA14046@elte.hu>
	<20100908014409.GA17010@brick.ozlabs.ibm.com>
	<AANLkTi=YdAxdGv1nEEZ4w0jM0K3ss0g5x7_5cU8xNEhj@mail.gmail.com>
	<20100908064427.GD3439@elte.hu>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Wed, 08 Sep 2010 15:30:59 -0400
In-Reply-To: <20100908064427.GD3439@elte.hu> (Ingo Molnar's message of "Wed, 8 Sep 2010 08:44:27 +0200")
Message-ID: <y0m39tkdocs.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mingo wrote:

> [...] Do you know some interesting usecase that would be excluded
> via such address restrictions?

You could study tracing-oriented runtime systems such as those of
dtrace, dprobes, or even systemtap, to help answer such questions.


> Things like flexible arrays or more complex data structures such as
> trees couldnt be used initially. More complex data structures would
> need locking in any case. [...]  I.e. it would initially be
> restricted roughly to code where halting can be proven. Still looks
> interesting to me [...]

There are years of experience out there to learn from.  Note the sorts
of filtering expressions (never mind control logic) used in the prior
art, so that you can know what you're about to sacrifice by a
simple-sounding implementation.


- FChE
