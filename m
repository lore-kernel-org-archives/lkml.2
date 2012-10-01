Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab2JAAcp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 20:32:45 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43768 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab2JAAco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 20:32:44 -0400
Date: Mon, 1 Oct 2012 09:32:33 +0900
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
Message-ID: <20121001003233.GL10383@mtj.dyndns.org>
References: <cover.1348736069.git.viresh.kumar@linaro.org>
 <7d5c2cac08134446583624cc124d46d9726bdb2d.1348736069.git.viresh.kumar@linaro.org>
 <20120930085455.GJ10383@mtj.dyndns.org>
 <CAKohpon2xQxSqeOCTb=noki=QUH=Cf9Aggsd_uAv34TNfyC0FA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpon2xQxSqeOCTb=noki=QUH=Cf9Aggsd_uAv34TNfyC0FA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Sep 30, 2012 at 05:46:45PM +0530, Viresh Kumar wrote:
> For the scheduler CPU is idle, if all below are true:
> - current task is idle task
> - nr_running == 0
> - wake_list is empty
> 
> And during these conditions, there can be a timer running in background.
> And when we reach its interrupt handler, then also these conditions hold true
> and local cpu is idle.

It isn't about the CPU being actually idle?  Also, if it's only about
timers, shouldn't it be enough to implement it for timer and
delayed_work?

It would be great if you explain what you're trying to achieve how.  I
can't tell what you're aiming for and why that would be beneficial
from these submissions.

Thanks.

-- 
tejun
