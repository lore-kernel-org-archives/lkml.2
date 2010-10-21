Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab0JUIsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 04:48:47 -0400
Received: from [120.204.251.227] ([120.204.251.227]:39574 "EHLO
	LC-SHMAIL-01.SHANGHAI.LEADCORETECH.COM" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754932Ab0JUIsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 04:48:46 -0400
Subject: Re: Ftrace: can trace kthread?
From: "Figo.zhang" <zhangtianfei@leadcoretech.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <AANLkTikzSZNtTGfOcP-87u+pMZyW8WrdxwV52ZV3f=nX@mail.gmail.com>
References: <1287647732.2237.7.camel@myhost>
	 <AANLkTim7g+8_rQSyewC6n_5WmC04kU-rj1g9k61=O2Vm@mail.gmail.com>
	 <1287649283.2237.8.camel@myhost>
	 <AANLkTikzSZNtTGfOcP-87u+pMZyW8WrdxwV52ZV3f=nX@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Oct 2010 16:44:28 +0800
Message-ID: <1287650668.2237.12.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Oct 2010 08:48:29.0869 (UTC) FILETIME=[BC04C5D0:01CB70FC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > i try by set_ftrace_pid, it also can't ftrace the kswapd.
> 
> Are you sure kswapd got chance to run on your system?
> 
> BTW, I can successfully trace bdi_writeback_thread,
> # tracer: function
> #
> #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> #              | |       |          |         |
>        flush-8:0-374   [000] 600743.828496: finish_task_switch <-schedule
>        flush-8:0-374   [000] 600743.828498: perf_event_task_sched_in
> <-finish_task_switch
>        flush-8:0-374   [000] 600743.828498: del_timer_sync <-schedule_timeout
>        flush-8:0-374   [000] 600743.828499: try_to_del_timer_sync
> <-del_timer_sync
>        flush-8:0-374   [000] 600743.828499: lock_timer_base
> <-try_to_del_timer_sync
>        flush-8:0-374   [000] 600743.828499: _spin_lock_irqsave <-lock_timer_base
>        flush-8:0-374   [000] 600743.828500: _spin_unlock_irqrestore
> <-try_to_del_timer_sync
>        flush-8:0-374   [000] 600743.828500: kthread_should_stop
> <-bdi_writeback_task

are you use my scprit to trace the bdi_writeback_thread ?

