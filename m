Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760530Ab0JZWC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 18:02:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:54639 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672Ab0JZWC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 18:02:27 -0400
Date: Tue, 26 Oct 2010 15:00:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: lockdep:  Invalid subclass: 31, related to mousedev_create
Message-Id: <20101026150028.039a0cb5.randy.dunlap@oracle.com>
In-Reply-To: <4CC74C9F.6040801@candelatech.com>
References: <4CC74C9F.6040801@candelatech.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010 14:48:15 -0700 Ben Greear wrote:

> This is coming out of today's wireless-testing tree:
> 
> BUG: looking up invalid subclass: 31
> turning off the locking correctness validator.
> Pid: 1, comm: swapper Not tainted 2.6.36-wl+ #33
> Call Trace:
>   [<c076af55>] ? printk+0xf/0x12
>   [<c045535f>] look_up_lock_class+0x2d/0x9e
>   [<c0455bb7>] register_lock_class+0x17/0x2ac
>   [<c0455ed2>] ? lockdep_init_map+0x86/0xf1
>   [<c0454fbe>] ? debug_mutex_init+0x28/0x33
>   [<c0455f2c>] lockdep_init_map+0xe0/0xf1
>   [<c0686d0d>] mousedev_create+0x8d/0x196
>   [<c09b4215>] mousedev_init+0x15/0x51
>   [<c040115e>] do_one_initcall+0x71/0x121
>   [<c09b4200>] ? mousedev_init+0x0/0x51
>   [<c098838c>] kernel_init+0x126/0x1a7
>   [<c0988266>] ? kernel_init+0x0/0x1a7
>   [<c0403586>] kernel_thread_helper+0x6/0x1a
> mice: PS/2 mouse device common for all mice


Please see this reply:
http://lkml.org/lkml/2010/10/25/48

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
