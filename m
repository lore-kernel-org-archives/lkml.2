Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab2I3IzM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 04:55:12 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49848 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab2I3IzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 04:55:06 -0400
Date: Sun, 30 Sep 2012 17:54:55 +0900
From: Tejun Heo <tj@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-kernel@vger.kernel.org, pjt@google.com, paul.mckenney@linaro.org,
        tglx@linutronix.de, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Arvind.Chauhan@arm.com,
        amit.kucheria@linaro.org, vincent.guittot@linaro.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH V2 3/3] workqueue: Schedule work on non-idle cpu instead
 of current one
Message-ID: <20120930085455.GJ10383@mtj.dyndns.org>
References: <cover.1348736069.git.viresh.kumar@linaro.org>
 <7d5c2cac08134446583624cc124d46d9726bdb2d.1348736069.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d5c2cac08134446583624cc124d46d9726bdb2d.1348736069.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Viresh.

On Thu, Sep 27, 2012 at 02:34:05PM +0530, Viresh Kumar wrote:
> - A cpu has programmed a timer and is IDLE now.
> - CPU gets into interrupt handler due to timer and queues a work. As the CPU is
>   currently IDLE, we can queue this work to some other CPU.

I'm still a bit confused, if the CPU is already running the IRQ
handler, the CPU is not idle by definition.  What am I missing here?

Thanks.

-- 
tejun
