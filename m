Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab2E1P0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 11:26:45 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:57410 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab2E1P0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 11:26:44 -0400
Message-ID: <4FC39904.9080309@linux.vnet.ibm.com>
Date: Mon, 28 May 2012 20:55:56 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: rusty@rustcorp.com.au, akpm@linux-foundation.org,
        paul.gortmaker@windriver.com, kosaki.motohiro@jp.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpumask: add a few comments of cpumask functions
References: <1338195748-18934-1-git-send-email-alex.shi@intel.com> <4FC373D9.7040109@linux.vnet.ibm.com> <4FC38277.2030500@intel.com>
In-Reply-To: <4FC38277.2030500@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12052805-0260-0000-0000-0000013DF3FD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2012 07:19 PM, Alex Shi wrote:

> On 05/28/2012 08:47 PM, Srivatsa S. Bhat wrote:
> 
>> On 05/28/2012 02:32 PM, Alex Shi wrote:
>>
>>> Current few cpumask function purpose are not quite clear. Stupid
>>> user like myself need to dig into details for clear function
>>> purpose and return value.
>>
>>
>> You can just see how it is used elsewhere and figure it out ;-)
>> Anyway, in principle, I don't have any objections to adding comments
>> that are actually helpful. But I don't think all the comments this
>> patch adds fall into that category..
>>
>>> Add few explanation for them is helpful.
>>>
>>> Signed-off-by: Alex Shi <alex.shi@intel.com>
>>> ---
>>>  include/linux/cpumask.h |    6 ++++++
>>>  1 files changed, 6 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
>>> index a2c819d..8436e61 100644
>>> --- a/include/linux/cpumask.h
>>> +++ b/include/linux/cpumask.h
>>> @@ -271,6 +271,7 @@ static inline void cpumask_clear_cpu(int cpu, struct cpumask *dstp)
>>>   * cpumask_test_cpu - test for a cpu in a cpumask
>>>   * @cpu: cpu number (< nr_cpu_ids)
>>>   * @cpumask: the cpumask pointer
>>> + * return 1 if the 'cpu' is in the old 'cpumask', otherwise return 0
>>>   *
>>
>>
>> s/return/Returns
>>
>> What do you mean by "old" cpumask?
> 
> Thanks for comments!
> Should be "the old bitmap of cpumask"?
> 


No, there is no "old" or "new" cpumask here because this function doesn't
change the cpumask. It just checks if that bit is set.
So something like:
Returns 1 if 'cpu' is set in 'cpumask', else returns 0.

Regards,
Srivatsa S. Bhat

