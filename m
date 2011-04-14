Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797Ab1DNRjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:39:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54119 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab1DNRjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:39:48 -0400
Message-ID: <4DA730F9.4030803@mvista.com>
Date: Thu, 14 Apr 2011 21:38:01 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Mike Frysinger <vapier@gentoo.org>, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
        x86@kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [Kgdb-bugreport] [PATCH 3/5] x86: convert to asm-generic ptrace.h
References: <1302760895-13459-1-git-send-email-vapier@gentoo.org> <1302760895-13459-4-git-send-email-vapier@gentoo.org> <4DA701D5.5050205@mvista.com> <4DA72965.20907@zytor.com>
In-Reply-To: <4DA72965.20907@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

H. Peter Anvin wrote:

>>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>>> ---
>>> arch/x86/include/asm/ptrace.h | 18 +++++-------------
>>> 1 files changed, 5 insertions(+), 13 deletions(-)

>>> diff --git a/arch/x86/include/asm/ptrace.h
>>> b/arch/x86/include/asm/ptrace.h
>>> index 78cd1ea..98a5e97 100644
>>> --- a/arch/x86/include/asm/ptrace.h
>>> +++ b/arch/x86/include/asm/ptrace.h
>>> @@ -136,6 +136,7 @@ struct cpuinfo_x86;
>>> struct task_struct;
>>>
>>> extern unsigned long profile_pc(struct pt_regs *regs);
>>> +#define profile_pc profile_pc

>> Er, won't this lead to infinite recursion in preprocessor? :-)

>> WBR, Sergei

> No.

    Strange, I thought the macro expansion is the subject to other macro expansions.

>     -hpa

WBR, Sergei
