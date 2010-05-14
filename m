Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab0ENQgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:36:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56515 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349Ab0ENQgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:36:33 -0400
Message-ID: <4BED7CE3.1020507@oracle.com>
Date: Fri, 14 May 2010 09:40:03 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 15/35] x86, lmb: Add lmb_reserve_area_overlap_ok()
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>	 <1273796396-29649-16-git-send-email-yinghai@kernel.org>	 <1273804337.21352.396.camel@pasglop>  <4BECF158.5070200@oracle.com> <1273825807.21352.601.camel@pasglop>
In-Reply-To: <1273825807.21352.601.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090204.4BED7BE8.005E:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2010 01:30 AM, Benjamin Herrenschmidt wrote:
> On Thu, 2010-05-13 at 23:44 -0700, Yinghai wrote:
>   
>> On 05/13/2010 07:32 PM, Benjamin Herrenschmidt wrote:
>>     
>>> On Thu, 2010-05-13 at 17:19 -0700, Yinghai Lu wrote:
>>>       
>>>> Some areas from firmware could be reserved several times from different callers.
>>>>
>>>> If these area are overlapped, We may have overlapped entries in lmb.reserved.
>>>>
>>>> Try to free the area at first, before rerserve them again.
>>>>         
>>> I have already told you to make this a property of lmb_reserve() instead
>>> of adding that function with a terrible name.
>>>       
>> make every lmb_reserve() call lmb_free at first?
>>     
> Either that, or make it check for collisions first, and if there's
> one, call free and try again. A little bit more work but I plan toq
> make it smarter at some stage, ie, directly adjust surrounding ranges
> instead which is not -that- hard to do.
>
>   
later, after this patchset. this patchset is hanging around too long
already.

YH
