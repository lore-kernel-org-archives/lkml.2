Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab2BVROv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 12:14:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255Ab2BVROr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 12:14:47 -0500
Message-ID: <4F45226B.50606@redhat.com>
Date: Wed, 22 Feb 2012 09:14:19 -0800
From: Richard Henderson <rth@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
        mathieu.desnoyers@efficios.com, davem@davemloft.net,
        ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups
 + docs
References: <cover.1329851692.git.jbaron@redhat.com>  <4F43F9F0.4000605@zytor.com> <20120222065016.GA16923@elte.hu>  <4F44934B.2000808@zytor.com> <20120222072538.GA17291@elte.hu>  <4F449ACF.3040807@zytor.com> <20120222074839.GA24890@elte.hu>  <efc1cd8f-7114-460b-a704-a3e533d48d02@email.android.com>  <20120222080659.GA25318@elte.hu>  <1329916920.25686.79.camel@gandalf.stny.rr.com>  <20120222133404.GA14085@elte.hu>  <1329918881.25686.92.camel@gandalf.stny.rr.com>  <1329923583.24994.21.camel@twins> <1329924752.24994.25.camel@twins>
In-Reply-To: <1329924752.24994.25.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/12 07:32, Peter Zijlstra wrote:
> So I clicked the link Jason provided in his 10/10 Documentation patch
> and stumbled upon:
> 
>   http://gcc.gnu.org/ml/gcc-patches/2009-07/msg01558.html
> 
> Where rth suggests that __attribute__((hot,cold)) might work on the
> destination labels. Trying this my compiler (4.6.1+crap) pukes all over
> me suggesting this isn't (yet) implemented.
> 
> Richard, is something like that still on the table?

It's still a possibility.  I gave Jason a patch for that quite some time
ago; I don't recall hearing whether it turned out to actually be useful.


r~
