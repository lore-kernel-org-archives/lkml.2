Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab0ENQVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:21:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24469 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab0ENQVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:21:20 -0400
Message-ID: <4BED793C.3090403@oracle.com>
Date: Fri, 14 May 2010 09:24:28 -0700
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
Subject: Re: [PATCH 03/35] lmb: Add ARCH_DISCARD_LMB to put lmb code to .init
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>	 <1273796396-29649-4-git-send-email-yinghai@kernel.org>	 <1273803249.21352.357.camel@pasglop>  <4BECEBF4.7000402@oracle.com> <1273824623.21352.580.camel@pasglop>
In-Reply-To: <1273824623.21352.580.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090201.4BED784C.008F:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2010 01:10 AM, Benjamin Herrenschmidt wrote:
> On Thu, 2010-05-13 at 23:21 -0700, Yinghai wrote:
>   
>>> So you do not intend to use lmb after boot ? This will break the
>>>       
>> debugfs
>>     
>>> files unless you also remove those.
>>>       
>> no, x86 don't lmb after boot.
>>
>> yes 
>>     
> So you need some kind of CONFIG option to keep lmb after boot, at least
> the data structures, for debugfs, or when not set, disable the debugfs
> files.
>
>   
Just disable the debugfs for lmb if ARCH_DISCARD_LMB is defined in arch
lmb.h

Thanks

Yinghai Lu
