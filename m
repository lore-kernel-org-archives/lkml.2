Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab0IFO5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 10:57:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab0IFO5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 10:57:44 -0400
Message-ID: <4C850147.8010908@redhat.com>
Date: Mon, 06 Sep 2010 17:57:11 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Tom Zanussi <tzanussi@gmail.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
References: <4C84B088.5050003@redhat.com> <1283772256.1930.303.camel@laptop> <4C84D1CE.3070205@redhat.com> <1283774045.1930.341.camel@laptop> <4C84D77B.6040600@redhat.com> <20100906124330.GA22314@elte.hu> <4C84E265.1020402@redhat.com> <20100906125905.GA25414@elte.hu>
In-Reply-To: <20100906125905.GA25414@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/06/2010 03:59 PM, Ingo Molnar wrote:
>
>> Is this a roundabout way of saying "jit"?
> Partly. I'm not sure we want to actually upload programs in bytecode
> form. ASCII is just fine - just like a .gz Javascript is fine for web
> apps. (and in most cases compresses down better than the bytecode
> equivalent)
>
> So a clear language (the simpler initially the better) plus an in-kernel
> compiler.
>
> This could be used for far more than just instrumentation: IMO security
> policies could be expressed in such a way. (Simplified, they are quite
> similar to filters installed on syscall entry/exit, with the ability of
> the filter to influence whether the syscall is performed.)

For me the requirements are:
- turing complete (more than just filters)
- easy interface to kernel APIs (like hrtimers)
- safe to use by untrusted users

The actual language doesn't really matter.

-- 
error compiling committee.c: too many arguments to function

