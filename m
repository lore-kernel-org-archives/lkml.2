Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1F3Mte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 08:49:34 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56196 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1F3Mt3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 08:49:29 -0400
MIME-Version: 1.0
In-Reply-To: <20110630103432.GV21898@n2100.arm.linux.org.uk>
References: <1308940724-2099-1-git-send-email-vincent.guittot@linaro.org>
	<20110630103432.GV21898@n2100.arm.linux.org.uk>
Date: Thu, 30 Jun 2011 14:49:29 +0200
Message-ID: <BANLkTi=XA4Ny0x1U-wYu5DH4FuyY05g3Aw@mail.gmail.com>
Subject: Re: [PATCH v3] Add ARM cpu topology definition
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 June 2011 12:34, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> On Fri, Jun 24, 2011 at 08:38:44PM +0200, Vincent Guittot wrote:
>> +     printk(KERN_INFO "cpu %u : thread %d cpu %d, socket %d, mpidr %x\n",
>> +             cpuid, cpu_topology[cpuid].thread_id,
>> +             cpu_topology[cpuid].core_id,
>> +             cpu_topology[cpuid].socket_id, mpidr);
>> +
>> +}
>
> Please remove that empty blank line before the closing brace.
>

ok

> Also...
>
> cpu 0 : thread -1 cpu 0, socket 0, mpidr 80000000
> Calibrating local timer... 199.99MHz.
> hw perfevents: enabled with ARMv7 Cortex-A9 PMU driver, 7 counters available
> CPU1: Booted secondary processor
> cpu 1 : thread -1 cpu 1, socket 0, mpidr 80000001
> CPU2: Booted secondary processor
> cpu 2 : thread -1 cpu 2, socket 0, mpidr 80000002
> CPU3: Booted secondary processor
> cpu 3 : thread -1 cpu 3, socket 0, mpidr 80000003
> Brought up 4 CPUs
>
> It'd be better to have some consistency there - please change from
> "cpu %u :" to "CPU%u:".
>

ok
