Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab0EQWed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:34:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39164 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756380Ab0EQWe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:34:29 -0400
Message-ID: <4BF1C2B0.6040700@zytor.com>
Date: Mon, 17 May 2010 15:26:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Yinghai <yinghai.lu@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
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
> 

Yes, that's the sane thing to do at this point.

	-hpa
