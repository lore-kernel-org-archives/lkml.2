Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643Ab1CIRBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 12:01:33 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60860 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab1CIRBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 12:01:32 -0500
Message-ID: <4D77B267.3020307@monstr.eu>
Date: Wed, 09 Mar 2011 18:01:27 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Revert "irq: Add tracepoint to softirq_raise" - microblaze build
References: <4D77708F.1000800@monstr.eu> <1299689179.15854.255.camel@gandalf.stny.rr.com>
In-Reply-To: <1299689179.15854.255.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 2011-03-09 at 13:20 +0100, Michal Simek wrote:
>> Hi Frederic,
>>
>> I have compiled ftrace support for Microblaze and I have reached a compilation failure.
>>
>> I bisected it and I found that
>> "irq: Add tracepoint to softirq_raise"
>> (sha1:2bf2160d8805de64308e2e7c3cd97813cb58ed2f)
>> caused it.
>>
>> I also found one thread which could be related.
>> http://kerneltrap.org/mailarchive/linux-kernel/2010/9/8/4616941
>>
>> It is likely any missing header or so.
>>
>> Do you know what can be wrong?
>>
>> Thanks,
>> Michal
>>
>>
>> [ALL  ]   CC      kernel/trace/power-traces.o
>> [ALL  ] In file included from 
>> /mnt/projects/petalinux-v1.00-devel/software/linux-2.6.x/arch/microblaze/include/asm/irq.h:15,
> 
> Is there a reason that arch/microblaze/include/asm/irq.h includes
> "linux/interrupt.h"?

Yep, it is. I tried to add some headers not remove them.

Thanks,
Michal

P.S.: Do you want to create proper patch? If not, I will do it.

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
