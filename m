Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab0ELSq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 14:46:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36820 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab0ELSqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 14:46:55 -0400
X-Authority-Analysis: v=1.1 cv=MoOeBCR3UCSroT7bBzr0mtJUqJhHyBWzyNa37ex1qNU= c=1 sm=0 a=yiYnlo-UJTIA:10 a=ood2b7iyd8MA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=wE21LPGCCs9pggVcDPgA:9 a=N3mUugwsJqQtgOsTEYu1lcchxKUA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: Perf and ftrace [was Re: PyTimechart]
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Pierre Tardy <tardyp@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       ziga.mahkovec@gmail.com, davem <davem@davemloft.net>
In-Reply-To: <20100512183704.GD21432@Krystal>
References: <20100512144811.GA5405@nowhere>
	 <1273678596.27703.30.camel@gandalf.stny.rr.com>
	 <20100512164650.GH5405@nowhere> <1273683624.1626.127.camel@laptop>
	 <20100512170734.GA15953@Krystal> <1273686425.1626.142.camel@laptop>
	 <20100512175305.GB32496@Krystal> <1273687212.1626.147.camel@laptop>
	 <20100512180438.GE15953@Krystal> <1273687712.1626.151.camel@laptop>
	 <20100512183704.GD21432@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 12 May 2010 14:46:52 -0400
Message-ID: <1273690012.27703.38.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-12 at 14:37 -0400, Mathieu Desnoyers wrote:

> OK, I see. In LTTng, I dropped the mmap() support when I integrated splice(). In
> both case, I can share the pages between the "output" (mmap or splice) and the
> ring buffer because my ring buffer does not care about
> page->mapping/->index/etc, so I never have to swap them.

I'm curious, how do you handle the overwrite mode without swapping?

-- Steve


