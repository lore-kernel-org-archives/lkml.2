Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab0L3Bxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 20:53:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38086 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131Ab0L3Bxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 20:53:45 -0500
Message-ID: <4D1BE615.4000700@zytor.com>
Date: Wed, 29 Dec 2010 17:53:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2 3/6] x86, 64bit, numa: Put pgtable to local node memory
References: <4D0C072D.1040201@kernel.org> <4D19320B.7030007@kernel.org> <4D1933D1.9020609@kernel.org> <4D1BC856.4010202@kernel.org> <4D1BC94C.5040100@zytor.com> <AANLkTikknHfA4TQw+SMH-EyJBHoNHXk8Rheq4=K4jNWA@mail.gmail.com> <alpine.DEB.2.00.1012291637270.6040@chino.kir.corp.google.com> <4D1BD928.50701@zytor.com> <alpine.DEB.2.00.1012291702180.7374@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1012291702180.7374@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2010 05:07 PM, David Rientjes wrote:
> On Wed, 29 Dec 2010, H. Peter Anvin wrote:
> 
>>> That's from f51bf3073a1 (x86, numa: Fake apicid and pxm mappings for NUMA 
>>> emulation) and c1c3443c9c (x86, numa: Fake node-to-cpumask for NUMA 
>>> emulation) in x86/numa.  Given the subject line, I think your patchset is 
>>> targeted to the same branch so I'm not sure what's concerning?
>>
>> No, it's part of a much bigger patchset which doesn't have anything to
>> do with NUMA.  That's the problem.
>>
>> In other words, I need a sane way to merge them and resolve the conflict.
>
> The two patches above from x86/numa that create the conflict should be 
> dependent only on 4e76f4e67a (x86, numa: Avoid compiling NUMA emulation 
> functions without CONFIG_NUMA_EMU), so cherry-pick them into x86/bootmem?

That would hurt more, I think.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

