Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab0ENQiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:38:04 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59044 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985Ab0ENQh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:37:58 -0400
Message-ID: <4BED7D50.5070004@oracle.com>
Date: Fri, 14 May 2010 09:41:52 -0700
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
Subject: Re: [PATCH 17/35] x86, lmb: Add x86 version of __lmb_find_area()
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>	 <1273796396-29649-18-git-send-email-yinghai@kernel.org>	 <1273804466.21352.400.camel@pasglop>  <4BECF21C.7030006@oracle.com> <1273825884.21352.603.camel@pasglop>
In-Reply-To: <1273825884.21352.603.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090202.4BED7C38.0058:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2010 01:31 AM, Benjamin Herrenschmidt wrote:
> On Thu, 2010-05-13 at 23:47 -0700, Yinghai wrote:
>
>   
>> for safe, and there is any problem with top to down allocation, we can
>> ask user to check if low to high works...
>>
>> not just make user to get broken kernel.
>>     
> Hrm. That's a bit gross. But ok, I don't care that much as long as your
> x86 variant doesn't differ in semantics with the core lmb one and I'll
> let Peter and/or Thomas to scream at you if they think it's gross
> (hint: the code is)
>
>
>   
those bits are line by line translation from current early_res code, and
have been used for a while.

so should be good as a fallback.

YH

