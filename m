Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968Ab1CaOUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:20:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59997 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab1CaOUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:20:30 -0400
Message-ID: <4D948D86.2050607@zytor.com>
Date: Thu, 31 Mar 2011 07:19:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-1.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Len Brown <lenb@kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/9] x86 idle: remove NOP cpuinfo_x86.hlt_works_ok flag
References: <67e90d97e0a77df4acd0c75e1bacc7714e011f3e.1301550524.git.len.brown@intel.com> <b048802b0285a5ff28e74a4309d833116174904a.1301550524.git.len.brown@intel.com> <20110331061247.GA24786@elte.hu> <alpine.LFD.2.02.1103310252160.8569@x980> <20110331081800.GH5938@elte.hu> <20110331102355.17d30a38@lxorguk.ukuu.org.uk> <20110331092721.GA16570@elte.hu> <20110331103320.5a72ff8c@lxorguk.ukuu.org.uk> <20110331093528.GA19288@elte.hu>
In-Reply-To: <20110331093528.GA19288@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2011 02:35 AM, Ingo Molnar wrote:
> 
> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
>>> Btw., we used to auto-detect broken HLT systems IIRC - but that got lost 
>>> already. We should at least honor the boot parameter.
>>
>> I don't believe we ever auto detected them or found a way to do so. That
>> was why the HLT message was printed before hlt was executed.
> 
> Yeah - the CPU hang was unrecoverably deep so no auto-detection was possible.
> 
> That's seriously ancient stuff - still, keeping the boot option around (<10 
> lines of code) does not hurt anyone.
> 

What it was was bad power supplies or low-capacitance, high-inductance
power distribution that happened to work with MS-DOS which always burned
the CPU at 100% and therefore left the power draw relatively consistent
current.  A proper OS putting the CPU in HLT produced a lot more high
frequency noise on the power busses, with disastrous results without
proper bypass.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

