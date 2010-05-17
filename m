Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab0EQRUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 13:20:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28372 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab0EQRUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 13:20:50 -0400
Message-ID: <4BF17A50.1050905@oracle.com>
Date: Mon, 17 May 2010 10:18:08 -0700
From: Yinghai <yinghai.lu@oracle.com>
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
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>	 <1273796396-29649-16-git-send-email-yinghai@kernel.org>	 <1273804337.21352.396.camel@pasglop> <4BECF158.5070200@oracle.com>	 <1273825807.21352.601.camel@pasglop> <4BED7CE3.1020507@oracle.com>	 <1273876234.21352.639.camel@pasglop>  <20100515073231.GB9877@elte.hu>	 <1274056773.21352.700.camel@pasglop>  <4BF0DE0C.2000905@oracle.com> <1274081072.21352.718.camel@pasglop>
In-Reply-To: <1274081072.21352.718.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090206.4BF17AC1.002C:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2010 12:24 AM, Benjamin Herrenschmidt wrote:
> On Sun, 2010-05-16 at 23:11 -0700, Yinghai wrote:
>> so looks like your change will hit 2.6.35, and my x86 changes will hit
>> 2.6.36?
>>
>> that is too long. 
> 
> No. Both will hit 2.6.36. It's way too late to queue up such changes for
> the 2.6.35 merge window which has already opened.

i have feeling that your new LMB code will hit 2.6.36. and
x86 patches that is using to lmb will hit 2.6.37.

otherwise it will make more merge conflicts between tip and lmb.
unless put your lmb change to tip?


> 
> Why would it be "too long" ? I keep asking what the heck is going on
> with having a time bomb on those patches and yet have to get a
> satisfactory answer.

why are you thinking that there is time bomb in the patches?
I even provide the option to use x86 own low to high allocation.
really don't know where is the time bomb.

my -v14 patches only touch several lines your core lmb code, and have near 0 affect
to original lmb users.

YH
