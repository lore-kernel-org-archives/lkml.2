Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab2KZXRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 18:17:16 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44147 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab2KZXRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 18:17:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAOtvUMckqfMhSwE6DsEzaEUEcDGw0uyYD9x0_XSo-1GM3HDy1g@mail.gmail.com>
References: <1351958983-31355-1-git-send-email-fweisbec@gmail.com>
	<1351958983-31355-2-git-send-email-fweisbec@gmail.com>
	<CAOtvUMckqfMhSwE6DsEzaEUEcDGw0uyYD9x0_XSo-1GM3HDy1g@mail.gmail.com>
Date: Tue, 27 Nov 2012 00:17:11 +0100
Message-ID: <CAFTL4hx_ntOgGttLdOZihQF6OUE21sCNXcXUip1t+hPTeBq0qQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] context_tracking: New context tracking susbsystem
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/6 Gilad Ben-Yossef <gilad@benyossef.com>:
> On Sat, Nov 3, 2012 at 6:09 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> diff --git a/arch/Kconfig b/arch/Kconfig
>> index 366ec06..3855e06 100644
>> --- a/arch/Kconfig
>> +++ b/arch/Kconfig
>> @@ -300,15 +300,15 @@ config SECCOMP_FILTER
>>
>>           See Documentation/prctl/seccomp_filter.txt for details.
>>
>> -config HAVE_RCU_USER_QS
>> +config HAVE_CONTEXT_TRACKING
>>         bool
>>         help
>> -         Provide kernel entry/exit hooks necessary for userspace
>> +         Provide kernel/user boundaries probes necessary for userspace
>>           RCU extended quiescent state. Syscalls need to be wrapped inside
>
> A minor nit pick: if whole point of the patch is to turn an RCU
> specific mechanism to a generic one
> that RCU happens to use, then the text needs to reflect that. How about:
>
> "Provide kernel/user boundaries probes necessary for subsystems that
> need it, such as userspace
> RCU extended quiescent state. "

Good point! I'm fixing this.

Thanks.
