Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab0LWHfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 02:35:44 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55545 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab0LWHfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 02:35:43 -0500
Message-ID: <3164a8edfdf8816a1b73200245684f57.squirrel@www.firstfloor.org>
In-Reply-To: <20101222101443.GA1640@elte.hu>
References: <1293005543.2565.156.camel@minggr.sh.intel.com>
    <1293006808.2170.42.camel@laptop> <1293008656.2170.67.camel@laptop>
    <20101222101443.GA1640@elte.hu>
Date: Thu, 23 Dec 2010 08:35:39 +0100
Subject: Re: [RFC PATCH] perf: Add load latency monitoring on Intel
 Nehalem/Westmere
From: "Andi Kleen" <andi@firstfloor.org>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Peter Zijlstra" <peterz@infradead.org>, "Lin Ming" <ming.m.lin@intel.com>,
        "Andi Kleen" <andi@firstfloor.org>,
        "Stephane Eranian" <eranian@google.com>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Arjan van de Ven" <arjan@infradead.org>,
        "lkml" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> * Peter Zijlstra <peterz@infradead.org> wrote:
>
>> On Wed, 2010-12-22 at 09:33 +0100, Peter Zijlstra wrote:
>> > On Wed, 2010-12-22 at 16:12 +0800, Lin Ming wrote:
>> > > It's applied on top of tip/master(3ea1f4f89) and Andi's offcore
>> > > patchsets are needed.
>> >
>> > I still haven't gotten a version of that I'm willing to apply.
>>
>> That is, maybe you could pick up his patches and finish them, Andi
>> doesn't seem interested in getting them sorted.
>
> FYI, this one of Peter's reviews that went unaddressed:
>
>   https://lkml.org/lkml/2010/12/1/213
>
> and he got no reply to that feedback in the past 3 weeks. (There may be
> other issues
> outstanding, i have not checked.)

Sorry didn't see that email. I dropped the variable intentionally
to simplify the code; there is no fastpath overhead for the other
CPUs and allocating a few bytes per core didn't seem worth having a
special variable to guard it. I can readd it if people really
want it.

-Andi

