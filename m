Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758470Ab2CWMaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 08:30:09 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756702Ab2CWMaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 08:30:07 -0400
Message-ID: <4F6C6D3F.3010403@nod.at>
Date: Fri, 23 Mar 2012 13:31:59 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, josh@joshtriplett.org,
        tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: Merge x86_32 and x86_64 cpu_idle()
References: <4F63AF10.9030101@zytor.com> <1331934010-24740-1-git-send-email-richard@nod.at> <20120323122556.GE13920@gmail.com>
In-Reply-To: <20120323122556.GE13920@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.03.2012 13:25, schrieb Ingo Molnar:
>
> * Richard Weinberger<richard@nod.at>  wrote:
>
>> Both functions are mostly identical, so we can merge them.
>>
>> Signed-off-by: Richard Weinberger<richard@nod.at>
>> ---
>>   arch/x86/include/asm/idle.h  |    1 +
>>   arch/x86/kernel/process.c    |  114 ++++++++++++++++++++++++++++++++++++++++++
>>   arch/x86/kernel/process_32.c |   60 ----------------------
>>   arch/x86/kernel/process_64.c |  109 ----------------------------------------
>>   4 files changed, 115 insertions(+), 169 deletions(-)
>
> Doesn't apply on latest -tip:
>
> patching file arch/x86/include/asm/idle.h
> patching file arch/x86/kernel/process.c
> Hunk #2 succeeded at 26 with fuzz 2 (offset 1 line).
> Hunk #3 succeeded at 392 (offset 1 line).
> patching file arch/x86/kernel/process_32.c
> Hunk #3 succeeded at 55 (offset 1 line).
> Hunk #4 FAILED at 65.
> 1 out of 4 hunks FAILED -- rejects in file arch/x86/kernel/process_32.c
> patching file arch/x86/kernel/process_64.c
> Hunk #3 FAILED at 48.
> 1 out of 3 hunks FAILED -- rejects in file arch/x86/kernel/process_64.c
>

It was based on Linus' tree.
I'll rebase it on -tip.

Thanks,
//richard
