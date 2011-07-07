Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab1GGSyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:54:20 -0400
Received: from mail.candelatech.com ([208.74.158.172]:38324 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab1GGSyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:54:19 -0400
Message-ID: <4E1600D3.8050105@candelatech.com>
Date: Thu, 07 Jul 2011 11:54:11 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@kernel.org>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
        rientjes@google.com, linux-mm@kvack.org
Subject: Re: [PATCH] slub: reduce overhead of slub_debug
References: <20110626193918.GA3339@joi.lan> <alpine.DEB.2.00.1107072106560.6693@tiger> <alpine.DEB.2.00.1107071314320.21719@router.home> <4E15FB3E.9050108@candelatech.com> <alpine.DEB.2.00.1107071341120.21719@router.home>
In-Reply-To: <alpine.DEB.2.00.1107071341120.21719@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2011 11:42 AM, Christoph Lameter wrote:
> On Thu, 7 Jul 2011, Ben Greear wrote:
>
>> The more painful you make it, the less likely folks are to use it
>> in environments that actually reproduce bugs, so I think it's quite
>> short-sighted to reject such performance improvements out of hand.
>>
>> And what if some production machine has funny crashes in a specific
>> work-load....wouldn't it be nice if it could enable debugging and
>> still perform well enough to do it's job?
>
> Sure if there would be significant improvements that accomplish what
> you claim above then that would be certainly worthwhile. Come up with
> patches like that please.

The patch appears to make some work loads twice as fast ('make clean'),
and it had a reasonable speedup to the 'make -j12'.  What do you
consider 'significant'?

I'm willing to do some other network-related benchmarks with his patch if
that would give it better chance of being accepted.  (I end up running
with SLUB debug quite a bit on big, heavy, workloads...so any speedup
in that would be a big help for us...)

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

