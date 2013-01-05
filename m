Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab3AERV0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 12:21:26 -0500
Received: from mail.digium.com ([216.207.245.2]:39551 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755802Ab3AERVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 12:21:23 -0500
Date: Sat, 5 Jan 2013 11:21:16 -0600
From: Shaun Ruffell <sruffell@digium.com>
To: Sadasivan Shaiju <sshaiju@mvista.com>
Cc: linux-kernel@vger.kernel.org, venki@google.com, a.p.zijlstra@chello.nl
Subject: Re: Incorrect accounting of irq into the running task
Message-ID: <20130105172116.GA65150@digium.com>
References: <aba006370d1e788a3ff0612afca6d3e7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aba006370d1e788a3ff0612afca6d3e7@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 10:22:12AM -0800, Sadasivan Shaiju wrote:
> Hi  Venkatesh,
> 
> I have applied the following patches for the incorrect accounting
> of irq into the running task .
> 
> 
> [PATCH] x86: Add IRQ_TIME_ACCOUNTING
> [e82b8e4ea4f3dffe6e7939f90e78da675fcc450e]
> [PATCH] sched: Add IRQ_TIME_ACCOUNTING, finer accounting of irq time
> [b52bfee445d315549d41eacf2fa7c156e7d153d5]
> 
> [PATCH] sched: Do not account irq time to current task
> [305e6835e05513406fa12820e40e4a8ecb63743c]
> [PATCH] sched: Export ns irqtimes through /proc/stat
> [abb74cefa9c682fb38ba86c17ca3c86fed6cc464]
> 
> 
> 
> But still the stime and utime of the process in /proc/pid/stat is
> high. I think the above patches does not update The stime and
> utime values in /proc/pid/stat.
> 
> 
> Or am I missing anything?

Just checking that you do have CONFIG_IRQ_TIME_ACCOUNTING=y in your
kernel config?

Cheers,
Shaun
