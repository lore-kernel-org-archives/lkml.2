Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab1ARGBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 01:01:17 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:39012 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab1ARGBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 01:01:15 -0500
Message-ID: <4D352CA6.7010109@linux.vnet.ibm.com>
Date: Tue, 18 Jan 2011 11:31:10 +0530
From: Ciju Rajan K <ciju@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 0/2 v1.0]sched: updating /proc/schedstat
References: <4D341ECD.3020503@linux.vnet.ibm.com> <1295283289.30950.172.camel@laptop>
In-Reply-To: <1295283289.30950.172.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,


On 01/17/2011 10:24 PM, Peter Zijlstra wrote:
> On Mon, 2011-01-17 at 16:19 +0530, Ciju Rajan K wrote:
>> Hi All,
>>
>> Here is the first version of the patch set, which updates
>> the /proc/schedstat statistics. Please review the patches and let me
>> know your thoughts.
> 
> Whats the impact on existing userspace, does the change warrant the
> effort of changing the userspace tools?

Since the fields are not at the end, there might be some changes required for the userspace scripts. But the benefits would be that we will have more relevant stats in /proc/schedstat.

Most of the userspace applications will be considering the version field of /proc/schedstat. Since we have an updated version for these changes, there should not be any breakage for the existing applications. One more advantage is that who ever looks at /proc/schedstat will see the actual numbers rather than seeing more zeros. Basically the readability improves. 

"http://eaglet.rain.com/rick/linux/schedstat/" admits that the format for /proc/schedstat can change depending upon the version. If you are ok with the /proc/schedstat updates, I can also send a patch to update "http://eaglet.rain.com/rick/linux/schedstat/v15/latency.c" program which parses some of the schedstat entries.


> 
> Also, attachment fail.

It should be ok now.

-Ciju
