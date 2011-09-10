Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933691Ab1IJR1j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 13:27:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55004 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933370Ab1IJR1h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 13:27:37 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1109101052340.2723@ionos>
References: <alpine.LFD.2.02.1109101052340.2723@ionos>
Date: Sat, 10 Sep 2011 18:27:34 +0100
Message-ID: <CABcS5h3+4br6aBfvRRPNhEkmSinbVNo3VoKJmRfW-cbeuj3Ksg@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.0.4-rt13
From: Rolando Martins <rolando.martins@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
recent work from Peter fixed the crashes caused by sched_rt_group (cgroups).
Nevertheless, its use still makes the system sluggish.
To test this, it's just a matter of mounting the "cpu" cgroup and then:
echo 100 > cpu.rt_period_us
echo 100 > cpu.rt_runtime_us

Thanks,
Rolando

On Sat, Sep 10, 2011 at 10:12 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Dear RT Folks,
>
> I'm pleased to announce the 3.0.4-rt13 release.
>
> Changes versus 3.0.2-rt11
>
>  * Migrate disable cure (Mike, Peter)
>
>  * ARM smpboot fix
>
>  * Printk debug (Peter)
>
>  * Ftrace: workaround the waitqueue issue
>
> Patch against 3.0.4 can be found here:
>
>  https://tglx.de/~tglx/rt/patch-3.0.4-rt13.patch.gz
>
> The split quilt queue is available at:
>
>  https://tglx.de/~tglx/rt/patches-3.0.4-rt13.tar.gz
>
> For those who don't have 3.0.4 around:
>
>  git://tesla.tglx.de/git/linux-2.6-tip rt/3.0
>
>  https://tglx.de/~tglx/rt/patch-3.0.4.gz
>
> Thanks,
>
>        tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
