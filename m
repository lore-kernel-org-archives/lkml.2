Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210Ab0E1OW3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 10:22:29 -0400
Received: from 64.mail-out.ovh.net ([91.121.185.65]:57227 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756647Ab0E1OW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 10:22:27 -0400
Message-ID: <4BFFD19F.5020601@example.com>
Date: Fri, 28 May 2010 16:22:23 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: piotr@hosowicz.com
CC: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Divyesh Shah <dpshah@google.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched_clock: Provide local_clock() and improve documentation
References: <4BF9EC69.5030709@example.com> <1274777422.5882.591.camel@twins>	 <20100526160252.325f8357.akpm@linux-foundation.org>	 <1274942798.27810.3584.camel@twins>	 <20100526235107.77e66ce0.akpm@linux-foundation.org>	 <1274945751.27810.3765.camel@twins>	 <20100527113340.d4afb8fc.akpm@linux-foundation.org> <1275052414.1645.52.camel@laptop> <4BFFD008.4070909@example.com>
In-Reply-To: <4BFFD008.4070909@example.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 15105073150374080882
X-Ovh-Remote: 83.24.90.132 (dni132.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.05.2010 16:15, Piotr Hosowicz wrote:
> On 28.05.2010 15:13, Peter Zijlstra wrote:
>> On Thu, 2010-05-27 at 11:33 -0700, Andrew Morton wrote:
>>
>>> Cool, thanks. You didn't Cc a mailing list :(
>>
>> Oops, must have managed to wreck the CC list somewhere, restored LKML.
>>
>> How does the below look?
>
> Earlier someone (you? I didn't write down) has published such a patch:

(cut patch)

> Should I apply it first and then your today's patch or only the today's
> patch?

Sorry, no question, today's patch must have been incorporated in the git 
repo, I see it fails to apply again. And the earlier one also.

But what about commit f4b87dee9 - should I revert it before build?

Regards and sorry for the noise.

Piotr Hosowicz

-- 
- No wiesz, pijany i o trzeciej nad ranem wracasz do domu!?
- A kto powiedzia³, ¿e wracam? Po gitarê tylko przyszed³em.
NP: Mark Knopfler - Before Gas & TV
NB: 2.6.34-20100527-2020-gitt-revtd
