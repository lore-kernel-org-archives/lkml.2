Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab1ASP4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 10:56:00 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:50730 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab1ASPz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 10:55:59 -0500
Message-ID: <4D37098A.8010706@linux.vnet.ibm.com>
Date: Wed, 19 Jan 2011 21:25:54 +0530
From: Ciju Rajan K <ciju@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 0/2 v1.0]sched: updating /proc/schedstat
References: <4D341ECD.3020503@linux.vnet.ibm.com> <1295283289.30950.172.camel@laptop> <4D352CA6.7010109@linux.vnet.ibm.com> <4D35416C.7020706@jp.fujitsu.com> <4D35462B.8010304@linux.vnet.ibm.com> <4D3687C1.4000909@jp.fujitsu.com>
In-Reply-To: <4D3687C1.4000909@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>
>> This patch set removes only those fields which are currently not in use.
>> If you observe the fields of /proc/schedstat the following fields are not
>> being updated.
> 
> Ah... I misunderstood the meaning of `unused' and complained based on too
> old kernel's source. Sorry.> 

> I confirmed that these fields are actually not treated by upstream kernel
> at all. So I think it's OK if any userland tools are updated synchronized
> with this change.

Thanks for verifying it.

 Does its benefit is more than its cost? In my
> understanding, its benefit is improving readability and reducing some memory
> footprint, and its cost is changing all userspace tools referring /proc/schedstat.

In my opinion we should go ahead with updating /proc/schedstat. 
As I mentioned earlier, we can have an updated script for 
http://eaglet.rain.com/rick/linux/schedstat/ 

> 
> # Unfortunately I don't know how much it costs.

The changes required in the userspace would be very small. 
Its just a matter of re-ordering the values. I also can't think
of much complicated scenario than this.

-Ciju
> 
