Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab1BJSac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 13:30:32 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41529 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab1BJSaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 13:30:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=dkim-signature:domainkey-signature:mime-version:in-reply-to
         :references:date:message-id:subject:from:to:cc:content-type;
        b=x8b7pDE9Fke50UBE1vhXBH3eELSUoIOiuSoib8KKpT+P3lZQ7Qj8iHCmrAD8bTMwlc
         5/V4myI7XEOmjut4UN9yS13INlx87EWaYstDYwwNfnloafqql10i2kWsgooVJ5oQkec3
         +LQjfzB7JsbDfR/tQhtodacF3Z/D9/YEmNvrs=
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lMKlheX6anBHGhnAVZl0gSDNTP0UvZCd4QjLckkTBfuY8QFLdmpyWVBo9qPfnZCvEO
         YLUK4CqThT8TfTYPRK4Kxw81OEHtZ89dWFyDp0CUJNBg/XMcvU/KznUSpd0D9es8fED/
         SmeDridr2w9HuaAMXVI+b8jtxgWckdd/wa0HM=
MIME-Version: 1.0
In-Reply-To: <1297340643.5512.1.camel@marge.simson.net>
References: <1297340643.5512.1.camel@marge.simson.net>
Date: Thu, 10 Feb 2011 19:30:25 +0100
Message-ID: <AANLkTikLM=Q_p0dk3USsYtLJ6GXKZsNoQuK3J+dA_z9V@mail.gmail.com>
Subject: Re: [PATCH 01/28] sched: Remove USER_SCHED
From: Dhaval Giani <dhaval.giani@gmail.com>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 9:48 AM, stable-bot for Dhaval Giani
<dhaval.giani@gmail.com> wrote:
> Commit: 7c9414385ebfdd87cc542d4e7e3bb0dbb2d3ce25 upstream
> Author: Dhaval Giani <dhaval.giani@gmail.com>
> AuthorDate: Wed Jan 20 13:26:18 2010 +0100
>
> Remove the USER_SCHED feature. It has been scheduled to be removed in
> 2.6.34 as per http://marc.info/?l=linux-kernel&m=125728479022976&w=2
>
> [trace from referenced thread]
> [1046577.884289] general protection fault: 0000 [#1] SMP
> [1046577.911332] last sysfs file: /sys/devices/platform/coretemp.7/temp1_input
> [1046577.938715] CPU 3
> [1046577.965814] Modules linked in: ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables coretemp k8temp
> [1046577.994456] Pid: 38, comm: events/3 Not tainted 2.6.32.27intel #1 X8DT3
> [1046578.023166] RIP: 0010:[] [] sched_destroy_group+0x3c/0x10d
> [1046578.052639] RSP: 0000:ffff88043e5abe10 EFLAGS: 00010097
> [1046578.081360] RAX: ffff880139fa5540 RBX: ffff8803d18419c0 RCX: ffff8801d2f8fb78
> [1046578.109903] RDX: dead000000200200 RSI: 0000000000000000 RDI: 0000000000000000
> [1046578.109905] RBP: 0000000000000246 R08: 0000000000000020 R09: ffffffff816339b8
> [1046578.109907] R10: 0000000004e6e5f0 R11: 0000000000000006 R12: ffffffff816339b8
> [1046578.109909] R13: ffff8803d63ac4e0 R14: ffff88043e582340 R15: ffffffff8104a216
> [1046578.109911] FS: 0000000000000000(0000) GS:ffff880028260000(0000) knlGS:0000000000000000
> [1046578.109914] CS: 0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [1046578.109915] CR2: 00007f55ab220000 CR3: 00000001e5797000 CR4: 00000000000006e0
> [1046578.109917] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [1046578.109919] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [1046578.109922] Process events/3 (pid: 38, threadinfo ffff88043e5aa000, task ffff88043e582340)
> [1046578.109923] Stack:
> [1046578.109924] ffff8803d63ac498 ffff8803d63ac4d8 ffff8803d63ac440 ffffffff8104a2c3
> [1046578.109927] <0> ffff88043e5abef8 ffff880028276040 ffff8803d63ac4d8 ffffffff81050395
> [1046578.109929] <0> ffff88043e582340 ffff88043e5826c8 ffff88043e582340 ffff88043e5abfd8
> [1046578.109932] Call Trace:
> [1046578.109938] [] ? cleanup_user_struct+0xad/0xcc
> [1046578.109942] [] ? worker_thread+0x148/0x1d4
> [1046578.109946] [] ? autoremove_wake_function+0x0/0x2e
> [1046578.109948] [] ? worker_thread+0x0/0x1d4
> [1046578.109951] [] ? kthread+0x79/0x81
> [1046578.109955] [] ? child_rip+0xa/0x20
> [1046578.109957] [] ? kthread+0x0/0x81
> [1046578.109959] [] ? child_rip+0x0/0x20
> [1046578.109961] Code: 3c 00 4c 8b 25 02 98 3d 00 48 89 c5 83 cf ff eb 5c 48 8b 43 10 48 63 f7 48 8b 04 f0 48 8b 90 80 00 00 00 48 8b 48 78 48 89 51 08 <48> 89 0a 48 b9 00 02 20 00 00 00 ad de 48 89 88 80 00 00 00 48
> [1046578.109975] RIP [] sched_destroy_group+0x3c/0x10d
> [1046578.109979] RSP
> [1046578.109981] ---[ end trace 5ebc2944b7872d4a ]---
>
> Signed-off-by: Dhaval Giani <dhaval.giani@gmail.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <1263990378.24844.3.camel@localhost>
> LKML-Reference: http://marc.info/?l=linux-kernel&m=129466345327931
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

There were a few more patches after this which cleaned up a few things
as well. Let me search them out and let you know the commit IDs.

Thanks,
Dhaval
