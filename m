Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab0EGFZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 01:25:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:35582 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab0EGFZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 01:25:02 -0400
Message-ID: <4BE3A3F0.3000906@kernel.org>
Date: Fri, 07 May 2010 07:24:00 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Josh Triplett <josh@freedesktop.org>, Oleg Nesterov <oleg@redhat.com>,
       Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH 3/4 UPDATED] scheduler: replace migration_thread with
 cpu_stop
References: <1272980864-27235-1-git-send-email-tj@kernel.org> <1272980864-27235-4-git-send-email-tj@kernel.org> <20100505013351.GN2639@linux.vnet.ibm.com> <4BE11E29.6040106@kernel.org> <20100505174725.GA6783@linux.vnet.ibm.com> <4BE1B49F.2020404@kernel.org> <20100505203149.GA2439@linux.vnet.ibm.com> <4BE2EEB0.6020402@kernel.org> <20100506184252.GC2325@linux.vnet.ibm.com>
In-Reply-To: <20100506184252.GC2325@linux.vnet.ibm.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 May 2010 05:24:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And of course, I overdid it in my patch when I removed smp_mb() from
> the !SMP version of synchronize_sched_expedited().  :-/
> 
> If synchronize_sched_expedited() is ever to be invoked from within
> kernel/sched.c in a UP kernel, there needs to be a "barrier()" in the
> !SMP version.  So please see the following patch.

Thanks.  Pushed.

-- 
tejun
