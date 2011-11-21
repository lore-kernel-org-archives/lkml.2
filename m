Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab1KUQFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 11:05:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab1KUQFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 11:05:44 -0500
Message-ID: <4ECA76C9.2080209@redhat.com>
Date: Mon, 21 Nov 2011 11:05:29 -0500
From: William Cohen <wcohen@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111104 Red Hat/3.1.16-2.el6_1 Thunderbird/3.1.16
MIME-Version: 1.0
To: Vince Weaver <vince@deater.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu,
        Stephane Eranian <eranian@google.com>, Arun Sharma <asharma@fb.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/6] perf: x86 RDPMC and RDTSC support
References: <20111121145114.049265181@chello.nl> <alpine.DEB.2.02.1111210959460.2903@pianoman.cluster.toy>
In-Reply-To: <alpine.DEB.2.02.1111210959460.2903@pianoman.cluster.toy>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2011 10:02 AM, Vince Weaver wrote:
> On Mon, 21 Nov 2011, Peter Zijlstra wrote:
> 
>> These few patches implement x86 RDPMC support and add an extention to the self
>> monitoring data to also allow additional time updates using userspace TSC reads.
>>
>> There's a few loose ends, but it mostly seems to work.
> 
> I'll have to test these out.  
> 
> I have some low-level benchmarks I've been working on, you can see some 
> preliminary results here:
>    http://web.eecs.utk.edu/~vweaver1/projects/perf-events/benchmarks/
> 
> perf_events was lagging behind perfmon2 and perfctr in self-monitoring 
> overhead, but maybe these changes will help that.
> 
> perf_event overhead got a lot worse between 2.6.32 and 3.0, I'm mid-bisect 
> on that trying to isolate the cause.
> 
> Vince
> 

Hi Vince,

Any improvements in performance of self-monitoring would be welcomed. International Symposium on computer Architecture (ISCA 2011) has paper about a low overhead mechanism to read out the performance counters, LiMiT (http://castl.cs.columbia.edu/limit/index.php/LiMiT) that avoids using system calls to read the performance counter data. That paper shows a fair amount of overhead for PAPI.

-Will
