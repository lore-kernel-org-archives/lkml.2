Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab2E3KuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 06:50:20 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:36668 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab2E3KuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 06:50:18 -0400
MIME-Version: 1.0
In-Reply-To: <4FC5F90C.9070308@intel.com>
References: <1338195748-18934-1-git-send-email-alex.shi@intel.com>
 <4FC373D9.7040109@linux.vnet.ibm.com> <4FC38277.2030500@intel.com>
 <4FC39904.9080309@linux.vnet.ibm.com> <4FC4236F.309@intel.com> <4FC5F90C.9070308@intel.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Wed, 30 May 2012 06:49:57 -0400
X-Google-Sender-Auth: BzSw-4TdKD0XqjJNQRU91HiKd3c
Message-ID: <CAHGf_=p=6t7Heyuio2t1q6Qb8KWCfnWzFjuR3kCO0VRTjiUBdA@mail.gmail.com>
Subject: Re: [PATCH] cpumask: add a few comments of cpumask functions
To: Alex Shi <alex.shi@intel.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        rusty@rustcorp.com.au, akpm@linux-foundation.org,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 6:40 AM, Alex Shi <alex.shi@intel.com> wrote:
> On 05/29/2012 09:16 AM, Alex Shi wrote:
>
>>
>>>>> s/return/Returns
>>>>>
>>>>> What do you mean by "old" cpumask?
>>>>
>>>> Thanks for comments!
>>>> Should be "the old bitmap of cpumask"?
>>>>
>>>
>>>
>>> No, there is no "old" or "new" cpumask here because this function doesn't
>>> change the cpumask. It just checks if that bit is set.
>>> So something like:
>>> Returns 1 if 'cpu' is set in 'cpumask', else returns 0.
>>>
>>
>>
>>
>> Sure, thanks! and comments changed again following your style.
>> Is the following new update patch ok?
>
>
> Any further comments for this patch? :)

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
