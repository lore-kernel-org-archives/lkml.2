Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab0EQGMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 02:12:54 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:23910 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab0EQGMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 02:12:53 -0400
Message-ID: <4BF0DE0C.2000905@oracle.com>
Date: Sun, 16 May 2010 23:11:24 -0700
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
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>	 <1273796396-29649-16-git-send-email-yinghai@kernel.org>	 <1273804337.21352.396.camel@pasglop> <4BECF158.5070200@oracle.com>	 <1273825807.21352.601.camel@pasglop> <4BED7CE3.1020507@oracle.com>	 <1273876234.21352.639.camel@pasglop>  <20100515073231.GB9877@elte.hu> <1274056773.21352.700.camel@pasglop>
In-Reply-To: <1274056773.21352.700.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4BF0DE52.0020:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2010 05:39 PM, Benjamin Herrenschmidt wrote:
> On Sat, 2010-05-15 at 09:32 +0200, Ingo Molnar wrote:
>>
>> Btw., it would be nice to ready the LMB core bits for 
>> upstream for 2.6.35 if there's agreement about them - 
>> that will make the subsequent x86 patches much easier 
>> to merge.
> 
> Well, 2.6.34 was released already. I think it's a bit premature. We need
> to fix a few more things (the result codes for example) and do more
> testing to ensure we didn't break other archs.
> 
so looks like your change will hit 2.6.35, and my x86 changes will hit 2.6.36?

that is too long.

YH
