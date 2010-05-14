Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab0ENQak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:30:40 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:21721 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab0ENQai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:30:38 -0400
Message-ID: <4BED7B3E.5020308@oracle.com>
Date: Fri, 14 May 2010 09:33:02 -0700
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
Subject: Re: [PATCH 05/35] x86, lmb: Add lmb_find_area_size()
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>	 <1273796396-29649-6-git-send-email-yinghai@kernel.org>	 <1273803621.21352.368.camel@pasglop>  <4BECEDAA.9070009@oracle.com> <1273824809.21352.584.camel@pasglop>
In-Reply-To: <1273824809.21352.584.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4BED7A4E.015C:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2010 01:13 AM, Benjamin Herrenschmidt wrote:
> On Thu, 2010-05-13 at 23:28 -0700, Yinghai wrote:
>   
>> this just line by line translation from early_res version to lmb
>> changes
>>
>> please focus on lmb core at this point.
>>     
> Well, the problem is that you dig into the LMB core with those functions
> which means I -will- break your stuff if/when I change it, for example
> to use linked lists.
>
>   
then you should don't even struct lmb, and move the definition from
lmb.h to lmb.c

> Besides, the code lacks comments and explanation in the changeset. So
> please provide that, I'm sure Thomas and Peter also want to understand
> what's going on in the x86 side of things.
>
>   

