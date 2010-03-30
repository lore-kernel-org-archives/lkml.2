Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab0C3Pbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 11:31:36 -0400
Received: from smtp-out.google.com ([74.125.121.35]:53507 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab0C3Pbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 11:31:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=vkmnLT2R8ZW1siQLHo2HzSl7TS4u3Sm+2OsMuG9jZiYoGAFNwS1n5x5X2ESsdRCHo
	om+kbNf5SPlgCi/QXArPw==
MIME-Version: 1.0
In-Reply-To: <20100330151133.GB5211@lenovo>
References: <1269880612-25800-1-git-send-email-robert.richter@amd.com>
	 <bd4cb8901003300311l4178891dvf1e63293a0ac51fe@mail.gmail.com>
	 <20100330134145.GI11907@erda.amd.com>
	 <bd4cb8901003300653lc8e414bp3930b03fee2fffbf@mail.gmail.com>
	 <1269961255.5258.221.camel@laptop> <20100330151133.GB5211@lenovo>
Date: Tue, 30 Mar 2010 17:31:29 +0200
Message-ID: <bd4cb8901003300831n48ed60c6l9fcd02393277ad32@mail.gmail.com>
Subject: Re: [PATCH 0/3] perf/core, x86: unify perfctr bitmasks
From: Stephane Eranian <eranian@google.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 5:11 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Tue, Mar 30, 2010 at 05:00:55PM +0200, Peter Zijlstra wrote:
>> On Tue, 2010-03-30 at 15:53 +0200, Stephane Eranian wrote:
>> > > So, there are some ARCH_PERFMON_EVENTSEL_* masks that are Intel only,
>> > > which is true for ARCH_PERFMON_EVENTSEL_ANY. And indead, the code
>> > > should be checked for this. ARCH_PERFMON_EVENTSEL_ANY is always
>> > > cleared on AMD cpus, so this code is ok. Actually the bit is cleared
>> >
>> > Until AMD uses that bit too and you won't notice this test. This is a security
>> > check specific to Intel and it should be in an Intel-specific function.
>> >
>> > > for *all* cpus in x86_pmu_raw_event(), the code was and is broken for
>> > > this.
>> > >
>> > Yes, needs to be authorized for any perfmon v3 and later revisions.
>>
>> So how about something like this on top of Robert's patches?
>>
> [...]
>
> Looks good for me! Thanks Peter!
>
Looks better. Thanks.

Acked-by: Stephane Eranian <eranian@google.com>
