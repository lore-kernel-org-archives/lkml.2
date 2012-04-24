Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab2DXSDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 14:03:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56172 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab2DXSDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 14:03:03 -0400
MIME-Version: 1.0
In-Reply-To: <20120424173518.GB18799@linux.vnet.ibm.com>
References: <20120424165619.GA28701@linux.vnet.ibm.com>
	<1335286696.28150.206.camel@twins>
	<20120424170743.GA18799@linux.vnet.ibm.com>
	<1335287547.28150.210.camel@twins>
	<20120424173518.GB18799@linux.vnet.ibm.com>
Date: Wed, 25 Apr 2012 00:03:03 +0600
Message-ID: <CADZ9YHhmV-S1K7Y6wDezXCq2LsCb=n0_7POkaxnKKqXu4gBpLg@mail.gmail.com>
Subject: Re: [PATCH v1] sched: steer waking task to empty cfs_rq for better latencies
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 11:35 PM, Srivatsa Vaddagiri
<vatsa@linux.vnet.ibm.com> wrote:
> * Peter Zijlstra <peterz@infradead.org> [2012-04-24 19:12:27]:
>
>> > The workload I am up against does experience tons of wakeup (after very short
>> > (microsecond range) bursts of sleeps) and so am skeptical how the global
>> > vruntime would keep up with this kind of workload. I'd be happy to test patches
>> > and give feedback!
>>
>> Thing is, global vruntime might fix that flaw/property you're exploiting
>> to get that preemption.
>
> Am curious to see how global vruntime influences task placement (esp. on
> wakeup). Going back to the previous example:
>
IIUC, global vruntime don't influence task placement, perhaps it'll do
something related task's priority, as if wakeup task gets picked up by
scheduler quickly. I'm also curious to see how global vruntime
influences task placement. :-)

Thanks,
Rakib
