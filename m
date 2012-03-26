Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823Ab2CZWr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 18:47:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60852 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567Ab2CZWr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 18:47:58 -0400
Message-ID: <4F70F217.4060005@zytor.com>
Date: Mon, 26 Mar 2012 15:47:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, tlb: switch cr3 in leave_mm() only when needed
References: <1332459220.16101.144.camel@sbsiddha-desk.sc.intel.com>  <CA+55aFyf9RqAROx7t=CYUSGCDBXvv9z2c+LP1vRJjLU45_pD+Q@mail.gmail.com>  <1332460885.16101.147.camel@sbsiddha-desk.sc.intel.com>  <4F6BC1C4.6050502@zytor.com>  <CA+55aFygUGmL0iCKYn5DBitrPSm0GHZ8e5j0j2OzcBcAkUMiFw@mail.gmail.com>  <1332463899.16101.158.camel@sbsiddha-desk.sc.intel.com>  <20120323083751.GC2886@gmail.com> <1332802025.12381.2.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1332802025.12381.2.camel@sbsiddha-desk.sc.intel.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2012 03:47 PM, Suresh Siddha wrote:
> On Fri, 2012-03-23 at 09:37 +0100, Ingo Molnar wrote:
>> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
>>
>>> I was reviewing this code in some other context and thought 
>>> this optimization makes sense. Unless someone beats me, I can 
>>> collect some data on Monday.
>>
>> Would be really nice to get this data.
>>
> 
> On an idle system with 32logical cpu's (2 socket/8-core each) the
> original kernel did the unnecessary load_cr3 2988 times during an
> interval of 5 seconds.
> 
> With the fix, that count drops to 9 times.
> 

Nice.

	-hpa

