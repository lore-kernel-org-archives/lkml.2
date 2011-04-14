Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583Ab1DNRHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:07:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48898 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758438Ab1DNRHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:07:48 -0400
Message-ID: <4DA72965.20907@zytor.com>
Date: Thu, 14 Apr 2011 10:05:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: Mike Frysinger <vapier@gentoo.org>, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
        x86@kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [Kgdb-bugreport] [PATCH 3/5] x86: convert to asm-generic ptrace.h
References: <1302760895-13459-1-git-send-email-vapier@gentoo.org> <1302760895-13459-4-git-send-email-vapier@gentoo.org> <4DA701D5.5050205@mvista.com>
In-Reply-To: <4DA701D5.5050205@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2011 07:16 AM, Sergei Shtylyov wrote:
> Hello.
>
> Mike Frysinger wrote:
>
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> ---
>> arch/x86/include/asm/ptrace.h | 18 +++++-------------
>> 1 files changed, 5 insertions(+), 13 deletions(-)
>
>> diff --git a/arch/x86/include/asm/ptrace.h
>> b/arch/x86/include/asm/ptrace.h
>> index 78cd1ea..98a5e97 100644
>> --- a/arch/x86/include/asm/ptrace.h
>> +++ b/arch/x86/include/asm/ptrace.h
>> @@ -136,6 +136,7 @@ struct cpuinfo_x86;
>> struct task_struct;
>>
>> extern unsigned long profile_pc(struct pt_regs *regs);
>> +#define profile_pc profile_pc
>
> Er, won't this lead to infinite recursion in preprocessor? :-)
>
> WBR, Sergei
>

No.

	-hpa
