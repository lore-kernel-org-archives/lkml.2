Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab0EQWWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:22:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58614 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab0EQWWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:22:20 -0400
Message-ID: <4BF1C0EA.5000705@oracle.com>
Date: Mon, 17 May 2010 15:19:22 -0700
From: Yinghai <yinghai.lu@Oracle.Com>
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
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>	 <1273796396-29649-16-git-send-email-yinghai@kernel.org>	 <1273804337.21352.396.camel@pasglop> <4BECF158.5070200@oracle.com>	 <1273825807.21352.601.camel@pasglop> <4BED7CE3.1020507@oracle.com>	 <1273876234.21352.639.camel@pasglop>  <20100515073231.GB9877@elte.hu>	 <1274056773.21352.700.camel@pasglop>  <4BF0DE0C.2000905@oracle.com>	 <1274081072.21352.718.camel@pasglop>  <4BF17A50.1050905@oracle.com> <1274133686.21352.755.camel@pasglop>
In-Reply-To: <1274133686.21352.755.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4BF1C144.00B1:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2010 03:01 PM, Benjamin Herrenschmidt wrote:
> On Mon, 2010-05-17 at 10:18 -0700, Yinghai wrote:
>>> No. Both will hit 2.6.36. It's way too late to queue up such changes
>> for
>>> the 2.6.35 merge window which has already opened.
>>
>> i have feeling that your new LMB code will hit 2.6.36. and
>> x86 patches that is using to lmb will hit 2.6.37.
>>
>> otherwise it will make more merge conflicts between tip and lmb.
>> unless put your lmb change to tip?
> 
> There is no reason not to, I'll have them in a separate branch that Ingo
> can pull. I think we can aim for 2.6.36 in one go provided that Peter
> and Thomas are happy with the x86 side of things.

great.

Thanks

Yinghai
