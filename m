Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab1ELHnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 03:43:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51524 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab1ELHnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 03:43:03 -0400
Message-ID: <4DCB8F7A.90603@kernel.org>
Date: Thu, 12 May 2011 00:42:50 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
References: <20110510085623.GG2258@linux.vnet.ibm.com> <4DC97E49.7040401@kernel.org> <20110510193216.GN2258@linux.vnet.ibm.com> <4DC9A5A4.1050308@kernel.org> <20110511045443.GS2258@linux.vnet.ibm.com> <BANLkTi=r707A9yy5-7+dw3Hozt=G1HBQ-Q@mail.gmail.com> <20110511201852.GC2258@linux.vnet.ibm.com> <4DCAF894.7030707@kernel.org> <4DCAFFD8.2080605@kernel.org> <4DCB157F.20202@kernel.org> <20110512060344.GB3191@elte.hu> <4DCB8BCD.1080607@kernel.org>
In-Reply-To: <4DCB8BCD.1080607@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4DCB8F83.0061,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2011 12:27 AM, Yinghai Lu wrote:
> On 05/11/2011 11:03 PM, Ingo Molnar wrote:
>>
>> * Yinghai Lu <yinghai@kernel.org> wrote:
>>
>>> e59fb3120becfb36b22ddb8bd27d065d3cdca499 is the first bad commit
>>> commit e59fb3120becfb36b22ddb8bd27d065d3cdca499
>>> Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>>> Date:   Tue Sep 7 10:38:22 2010 -0700
>>>
>>>     rcu: Decrease memory-barrier usage based on semi-formal proof
>>
>> Find below an (untested!) attempt at reverting it for debugging purposes: could 
>> you please try it, does your system now boot up fine?
>>
>> Thanks,
>>
>> 	Ingo
>>
> 
> yes, reverted manually that commit fix the problem.

on system with 8 sockets westmere-ex

it seems other commits after that commit contribute some delay too.

[   32.240739] cpu_dev_init done
[   73.587288] memory_dev_init done

Thanks

Yinghai
