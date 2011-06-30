Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab1F3Kew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 06:34:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39393 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab1F3Keq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 06:34:46 -0400
Date: Thu, 30 Jun 2011 11:34:32 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH v3] Add ARM cpu topology definition
Message-ID: <20110630103432.GV21898@n2100.arm.linux.org.uk>
References: <1308940724-2099-1-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308940724-2099-1-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 08:38:44PM +0200, Vincent Guittot wrote:
> +	printk(KERN_INFO "cpu %u : thread %d cpu %d, socket %d, mpidr %x\n",
> +		cpuid, cpu_topology[cpuid].thread_id,
> +		cpu_topology[cpuid].core_id,
> +		cpu_topology[cpuid].socket_id, mpidr);
> +
> +}

Please remove that empty blank line before the closing brace.

Also...

cpu 0 : thread -1 cpu 0, socket 0, mpidr 80000000
Calibrating local timer... 199.99MHz.
hw perfevents: enabled with ARMv7 Cortex-A9 PMU driver, 7 counters available
CPU1: Booted secondary processor
cpu 1 : thread -1 cpu 1, socket 0, mpidr 80000001
CPU2: Booted secondary processor
cpu 2 : thread -1 cpu 2, socket 0, mpidr 80000002
CPU3: Booted secondary processor
cpu 3 : thread -1 cpu 3, socket 0, mpidr 80000003
Brought up 4 CPUs

It'd be better to have some consistency there - please change from
"cpu %u :" to "CPU%u:".
