Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636Ab0LXH7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 02:59:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64433 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab0LXH7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 02:59:10 -0500
Message-ID: <4D145339.1080205@cn.fujitsu.com>
Date: Fri, 24 Dec 2010 16:00:57 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 01/15] nohz_task: New mask for cpus having nohz task
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com> <1292858662-5650-2-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1292858662-5650-2-git-send-email-fweisbec@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-24 15:58:58,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-24 15:58:59,
	Serialize complete at 2010-12-24 15:58:59
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2010 11:24 PM, Frederic Weisbecker wrote:
>  
> +config NO_HZ_TASK
> +       bool "Tickless task"
> +       depends on HAVE_NO_HZ_TASK && NO_HZ && SMP && HIGH_RES_TIMERS
> +       help
> +         When a task runs alone on a CPU and switches into this mode,
> +         the timer interrupt will only trigger when it is strictly
> +         needed.

Why it depends on SMP?

