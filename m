Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab1LIBY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 20:24:56 -0500
Received: from cpanel23.proisp.no ([88.87.44.74]:40202 "EHLO
	cpanel23.proisp.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab1LIBYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 20:24:53 -0500
Message-ID: <4EE1635E.9000302@numascale.com>
Date: Fri, 09 Dec 2011 02:24:46 +0100
From: Steffen Persvold <sp@numascale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Kevin Winchester <kjwinchester@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        tglx@linutronix.de, daniel@numascale-asia.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/apic] x86: Add NumaChip support
References: <1323101246-2400-1-git-send-email-daniel@numascale-asia.com> <tip-44b111b519160e33fdc41eadb39af86a24707edf@git.kernel.org> <20111205203130.GA12364@elte.hu> <4EDD5D77.3030101@numascale.com> <20111206055023.GB1580@elte.hu> <CAELBVzBqNHsnRP=dt7nwFWoigfX4FF6nQio+P+Fz71xQY0qK4Q@mail.gmail.com>
In-Reply-To: <CAELBVzBqNHsnRP=dt7nwFWoigfX4FF6nQio+P+Fz71xQY0qK4Q@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel23.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/8/2011 23:35, Kevin Winchester wrote:
> On 6 December 2011 01:50, Ingo Molnar<mingo@elte.hu>  wrote:
[]
>> Ideally i think c->phys_proc_id should should be available
>> regardless of CONFIG_SMP or CONFIG_NUMA considerations - but
>> that would be a wider change. (feel free to have a shot at it
>> though, in addition to the fix above)
>>
>
> If Steffen does not plan to do this additional cleanup, I would give
> it a try.  You would likely prefer the changes against -tip, correct?
>

Hi Kevin,

I didn't want to mess around with it too much in this round (I'm more of 
a "if it ain't broke, don't fix it" kinda guy), but if the consensus is 
that this should be done, please feel free to give it a try :)

Kind regards,
-- 
Steffen Persvold, Chief Architect NumaChip
Numascale AS - www.numascale.com
Tel: +47 92 49 25 54 Skype: spersvold
