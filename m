Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab0JYLCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 07:02:10 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:59085 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab0JYLCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 07:02:09 -0400
Message-ID: <4CC563A9.3020308@linux.vnet.ibm.com>
Date: Mon, 25 Oct 2010 16:32:01 +0530
From: divya <dipraksh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: Subrata Modak <subrata@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@samba.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: BUG with the kernel version 2.6.36-rc1 on power machine
References: <4CC13B2C.7090908@linux.vnet.ibm.com> <4CC13FFF.7040200@linux.vnet.ibm.com> <AANLkTikmpohofzO_dV_Dv8EfcEMsyy4cdhGMUD-PAFO3@mail.gmail.com> <1287774802.19497.1.camel@subratamodak.linux.ibm.com> <20101023093630.GA3036@zhy>
In-Reply-To: <20101023093630.GA3036@zhy>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 October 2010 03:06 PM, Yong Zhang wrote:
> On Sat, Oct 23, 2010 at 12:43:21AM +0530, Subrata Modak wrote:
>    
>> This is equally seen for both Power6 and Power7 machines.
>>      
> Seems resolved by part of http://lkml.org/lkml/2010/10/13/67
>
> Thanks,
> Yong
>
>    
>> Regards--
>> Subrata
>>
>> On Sat, 2010-10-23 at 00:37 +0530, Subrata Modak wrote:
>>      
>>>
>>> ---------- Forwarded message ----------
>>> From: divya<dipraksh@linux.vnet.ibm.com>
>>> Date: Fri, Oct 22, 2010 at 1:10 PM
>>> Subject: Re: BUG with the kernel version 2.6.36-rc1 on power machine
>>> To: LKML<linux-kernel@vger.kernel.org>, benh@kernel.crashing.org,
>>> linuxppc-dev@ozlabs.org
>>>
>>>
>>>
>>> On Friday 22 October 2010 12:50 PM, divya wrote:
>>>          Hi ,
>>>
>>>          With the latest version of kernel 2.6.36-rc1 running on the
>>>          power machine, came across the following call trace
>>>
>>>          BUG: looking up invalid subclass: 31
>>>          turning off the locking correctness validator.
>>>          Call Trace:
>>>          [c00000000e0bfb60] [c0000000000119a0] .show_stack+0x6c/0x16c
>>>          (unreliable)
>>>          [c00000000e0bfc10] [c0000000000c39b8] .lockdep_init_map
>>>          +0x194/0x630
>>>          [c00000000e0bfcf0] [c0000000005524f8] .mousedev_create
>>>          +0xcc/0x234
>>>          [c00000000e0bfda0] [c00000000093fb58] .mousedev_init+0x38/0xa0
>>>          [c00000000e0bfe30] [c0000000000097e4] .do_one_initcall
>>>          +0xd8/0x1c8
>>>          [c00000000e0bfee0] [c0000000009004ac] .kernel_init+0x23c/0x2f8
>>>          [c00000000e0bff90] [c00000000002ad30] .kernel_thread+0x54/0x70
>>>
>>>          The config file used for make oldconfig is being attached
>>>
>>>          Thanks
>>>          Divya
>>>
>>>
>>>
>>>
>>> I meant 2.6.36-git1(b5153163ed580e) , and not 2.6.36-rc1.
>>> Sorry for the confusion.
>>>
>>> Thanks
>>> Divya
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>>
>>>
>>>
>>> -- 
>>> Regards&  Thanks--
>>> Subrata
>>>        
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>      
The patch at
http://lkml.org/lkml/2010/10/13/67 resolves the issue.

But this is not a part of 2.6.36-git6 , when will it be pulled into the upstream?

Thanks
Divya

