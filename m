Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab0LVQWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 11:22:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:28790 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391Ab0LVQWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 11:22:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,214,1291622400"; 
   d="scan'208";a="689800712"
Message-ID: <4D1225D8.9080408@linux.intel.com>
Date: Wed, 22 Dec 2010 08:22:48 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Peter Zijlstra <peterz@infradead.org>, John Kacur <jkacur@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@elte.hu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/4 V3 ] futex,plist: pass the real head of the priority
 list to plist_del()
References: <4D107979.2020405@cn.fujitsu.com> <4D10FC40.6070808@linux.intel.com> <4D11984A.5030203@cn.fujitsu.com> <4D119FA6.4070807@linux.intel.com> <4D11BE9A.3020609@cn.fujitsu.com>
In-Reply-To: <4D11BE9A.3020609@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2010 01:02 AM, Lai Jiangshan wrote:
> On 12/22/2010 02:50 PM, Darren Hart wrote:
>> On 12/21/2010 10:18 PM, Lai Jiangshan wrote:
>>> On 12/22/2010 03:13 AM, Darren Hart wrote:
>>>> On 12/21/2010 01:55 AM, Lai Jiangshan wrote:
>>>>
>>>> Hi Lai,
>>>>
>>>> Looks about ready to me, only a couple of more nitpics from me.
>>>>
>>>
>>> Fixed, thanks.
>>
>> Looks good to me. How did the futextest runs go?
>>
>
> It's OK, the result are almost the same.
>
> kernel version: 2.6.37-rc6-tip
> Intel(R) Pentium(R) D CPU 2.80GHz
> MemTotal:         961208 kB
>

This is futex_wait.c I presume? Delta looks to be in the realm of 
statistical noise to me. I'll ack the two patches.

--
Darren

> # diff result result.applied -u | grep '^[+-]'
> --- result	2010-12-22 16:57:45.000000000 +0800
> +++ result.applied	2010-12-22 16:56:39.000000000 +0800
> -Result: 12048 Kiter/s
> +Result: 12210 Kiter/s
> -Result: 4037 Kiter/s
> +Result: 3554 Kiter/s
> -Result: 3331 Kiter/s
> +Result: 3347 Kiter/s
> -Result: 2996 Kiter/s
> +Result: 3124 Kiter/s
> -Result: 2998 Kiter/s
> +Result: 3087 Kiter/s
> -Result: 2894 Kiter/s
> +Result: 3008 Kiter/s
> -Result: 2863 Kiter/s
> +Result: 2882 Kiter/s
> -Result: 3098 Kiter/s
> +Result: 3265 Kiter/s
> -Result: 2888 Kiter/s
> +Result: 2811 Kiter/s
> -Result: 2876 Kiter/s
> +Result: 2995 Kiter/s
> -Result: 2893 Kiter/s
> +Result: 2980 Kiter/s
> -Result: 3100 Kiter/s
> +Result: 2860 Kiter/s
> -Result: 2915 Kiter/s
> +Result: 2964 Kiter/s
> -Result: 2940 Kiter/s
> +Result: 3035 Kiter/s
> -Result: 2671 Kiter/s
> +Result: 2939 Kiter/s


-- 
Darren Hart
Yocto Linux Kernel
