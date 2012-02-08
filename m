Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab2BHKv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 05:51:58 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:37041 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639Ab2BHKv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 05:51:57 -0500
Message-ID: <4F32539D.8030402@linux.vnet.ibm.com>
Date: Wed, 08 Feb 2012 16:21:09 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu
Subject: Re: Use case for PERF_COUNT_HW_REF_CPU_CYCLES generic PMU event
References: <4F3243D4.4080907@linux.vnet.ibm.com> <CABPqkBR+okFaa2s1AbMHAgkBbW4QSwOceLuYvqE=6PQOvzksiw@mail.gmail.com>
In-Reply-To: <CABPqkBR+okFaa2s1AbMHAgkBbW4QSwOceLuYvqE=6PQOvzksiw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12020810-2674-0000-0000-00000344CE26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 February 2012 03:21 PM, Stephane Eranian wrote:
> On Wed, Feb 8, 2012 at 10:43 AM, Anshuman Khandual
> <khandual@linux.vnet.ibm.com> wrote:
>> Hello Stephane,
>>
>> I was going through the following discussion where we added the
>> new HW generic event PERF_COUNT_HW_REF_CPU_CYCLES.
>>
>> https://lkml.org/lkml/2011/12/10/103
>>
>> (Sorry, for asking this question bit late)
>>
>> I am trying to understand the use case for this. Would this new event
>> help us in generating (during a perf session) a CPU frequency invariant
>> time metric against which we would plot our other perf event's measurements ?
>> CPU frequency independent time measurement is it's primary purpose ? or we were
>> finding a way to expose the fixed counter 2 which was not getting used before
>> for not having an event encoding. I guess this would help us in finding equivalent
>> PMU events or mechanisms in other architecture / platforms.
>>
> The goal was to expose a cycle event that is not subject to frequency scaling
> nor turbo boost of any sort. An event that could be used to correlate with time.

> An event that could also be used to compute idle time by comparing its value
> with wall-clock time.

Why kernel computed idle time is not sufficient ? How much accuracy would it
improve in using PMU event computed idle time over kernel computed idle time. 


> 
> The fact that on Intel X86 this event is on fixed counter 2 is an
> implementation
> detail.
> 
>> --
>> Anshuman Khandual
>> Linux Technology Centre
>> IBM Systems and Technology Group
>>
> 

