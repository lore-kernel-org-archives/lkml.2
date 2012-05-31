Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab2EaIRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 04:17:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:20062 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab2EaIRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 04:17:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="150707804"
Message-ID: <4FC7289D.2080009@intel.com>
Date: Thu, 31 May 2012 16:15:25 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        rusty@rustcorp.com.au, akpm@linux-foundation.org,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpumask: add a few comments of cpumask functions
References: <1338195748-18934-1-git-send-email-alex.shi@intel.com> <4FC373D9.7040109@linux.vnet.ibm.com> <4FC38277.2030500@intel.com> <4FC39904.9080309@linux.vnet.ibm.com> <4FC4236F.309@intel.com> <4FC5F90C.9070308@intel.com> <CAHGf_=p=6t7Heyuio2t1q6Qb8KWCfnWzFjuR3kCO0VRTjiUBdA@mail.gmail.com>
In-Reply-To: <CAHGf_=p=6t7Heyuio2t1q6Qb8KWCfnWzFjuR3kCO0VRTjiUBdA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 06:49 PM, KOSAKI Motohiro wrote:

> On Wed, May 30, 2012 at 6:40 AM, Alex Shi <alex.shi@intel.com> wrote:
>> On 05/29/2012 09:16 AM, Alex Shi wrote:
>>
>>>
>>>>>> s/return/Returns
>>>>>>
>>>>>> What do you mean by "old" cpumask?
>>>>>
>>>>> Thanks for comments!
>>>>> Should be "the old bitmap of cpumask"?
>>>>>
>>>>
>>>>
>>>> No, there is no "old" or "new" cpumask here because this function doesn't
>>>> change the cpumask. It just checks if that bit is set.
>>>> So something like:
>>>> Returns 1 if 'cpu' is set in 'cpumask', else returns 0.
>>>>
>>>
>>>
>>>
>>> Sure, thanks! and comments changed again following your style.
>>> Is the following new update patch ok?
>>
>>
>> Any further comments for this patch? :)
> 
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


Thanks!
Does someone like to pick up this patch? :)
