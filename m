Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab2JPF2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 01:28:46 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:37692 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab2JPF2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 01:28:44 -0400
Message-ID: <507CF098.9080703@linux.vnet.ibm.com>
Date: Tue, 16 Oct 2012 10:58:56 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Arun Sharma <asharma@fb.com>
CC: Robert Richter <robert.richter@amd.com>, peterz@infradead.org,
        Anton Blanchard <anton@au1.ibm.com>, linux-kernel@vger.kernel.org,
        eranian@google.com, acme@redhat.com, linuxppc-dev@ozlabs.org,
        paulus@samba.org, mpjohn@us.ibm.com,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, mingo@kernel.org
Subject: Re: [RFC][PATCH] perf: Add a few generic stalled-cycles events
References: <20121012012839.GA15348@us.ibm.com> <20121015155534.GR8285@erda.amd.com> <507C467E.8010205@fb.com>
In-Reply-To: <507C467E.8010205@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12101605-3568-0000-0000-0000029A9592
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2012 10:53 PM, Arun Sharma wrote:
> On 10/15/12 8:55 AM, Robert Richter wrote:
> 
> [..]
>> Perf tool works then out-of-the-box with:
>>
>>   $ perf record -e cpu/stalled-cycles-fixed-point/ ...
>>
>> The event string can easily be reused by other architectures as a
>> quasi standard.
> 
> I like Robert's proposal better. It's hard to model all the stall events
> (eg: instruction decoder related stalls on x86) in a hardware
> independent way.
> 
> Another area to think about: software engineers are generally busy and
> have a limited amount of time to devote to hardware event based
> optimizations. The most common question I hear is: what is the expected
> perf gain if I fix this? It's hard to answer that with just the stall
> events.
> 

Hardware event based optimization is a very important aspect of real world application
tuning. CPI stack analysis is a good reason why perf should have stall events as generic
ones. But I am not clear on situations where we consider adding these new generic events
into linux/perf_event.h and the situations where we should go with the sys fs interface.
Could you please elaborate on this ?

Regards
Anshuman

