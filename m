Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab0CUHsZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 03:48:25 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:57686 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab0CUHsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 03:48:24 -0400
Message-ID: <4BA5CF44.5000102@in.ibm.com>
Date: Sun, 21 Mar 2010 13:18:20 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: 2.6.34-rc2: cpu hotplug test failure on x86_64
References: <4BA50319.3040301@in.ibm.com> <1269106149.9440.517.camel@laptop> <201003202153.16547.rjw@sisk.pl>
In-Reply-To: <201003202153.16547.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Saturday 20 March 2010, Peter Zijlstra wrote:
>   
>> On Sat, 2010-03-20 at 22:47 +0530, Sachin Sant wrote:
>>     
>>> Running cpu hotplug tests on a x86_64 box results in
>>> the following BUG.
>>>
>>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
>>> IP: [<ffffffff81037388>] amd_pmu_cpu_offline+0x38/0x67
>>>       
>> I guess something like the below might work.
>>     
>
> Not really.  Sachin, please try this patch instead:
> https://patchwork.kernel.org/patch/87189/
>   
Works for me. Thanks Rafael.

Regards
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

