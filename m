Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab1CaPJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:09:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36076 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278Ab1CaPJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:09:40 -0400
Message-ID: <4D949918.8010109@zytor.com>
Date: Thu, 31 Mar 2011 08:09:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-1.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Len Brown <len.brown@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/9] x86 idle: remove NOP cpuinfo_x86.hlt_works_ok flag
References: <67e90d97e0a77df4acd0c75e1bacc7714e011f3e.1301550524.git.len.brown@intel.com>	<b048802b0285a5ff28e74a4309d833116174904a.1301550524.git.len.brown@intel.com>	<20110331061247.GA24786@elte.hu>	<alpine.LFD.2.02.1103310252160.8569@x980>	<20110331081800.GH5938@elte.hu>	<20110331102355.17d30a38@lxorguk.ukuu.org.uk>	<20110331092721.GA16570@elte.hu>	<20110331103320.5a72ff8c@lxorguk.ukuu.org.uk>	<20110331093528.GA19288@elte.hu>	<4D948D86.2050607@zytor.com> <20110331154103.70d88899@lxorguk.ukuu.org.uk>
In-Reply-To: <20110331154103.70d88899@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2011 07:41 AM, Alan Cox wrote:
>>
>> What it was was bad power supplies or low-capacitance, high-inductance
>> power distribution that happened to work with MS-DOS which always burned
>> the CPU at 100% and therefore left the power draw relatively consistent
>> current.  A proper OS putting the CPU in HLT produced a lot more high
>> frequency noise on the power busses, with disastrous results without
>> proper bypass.
> 
> And also chipset errata in some cases - eg some revisions of the CS5510
> hung the box solid if a CPU hlt occurred during an IDE transfer. I don't
> think any CS5510s are still around although I've had mail from someone
> with a CS5520 in use not that long ago so who knows!
> 
> The joy of ancient history.

Ah, yes, I guess there was a special cycle on the bus which the chipset
could misinterpret.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

