Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab1GVWvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 18:51:24 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:38503 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab1GVWvX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 18:51:23 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1107222203400.2702@ionos>
References: <alpine.LFD.2.02.1107222203400.2702@ionos>
Date: Fri, 22 Jul 2011 23:51:21 +0100
Message-ID: <CABcS5h01jpOSKcKtrJ65AqNNQDCAOutQADAE_pcRp-MPBoO-VA@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.0-rt1
From: Rolando Martins <rolando.martins@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the great work!

Is it possible to have RT_GROUP_SCHED and PREEMPT_RT_FULL?

Thanks.
Rolando Martins


On Fri, Jul 22, 2011 at 9:37 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Dear RT Folks,
>
> I'm pleased to announce the 3.0-rt1 release.
>
> Changes versus 3.0-rc7-rt0:
>
>  * Update to Linus final 3.0 release
>
>  * RTC bugfixes (scheduled for mainline/stable)
>
>  * Long standing (rt only) timer_list bug (see
>    timers-avoid-the-base-null-otptimization-on-rt.patch in the split
>    out quilt queue)
>
>  * Minor non exciting fixes all over the place
>
> Known issues:
>
>  * Some weird "console=..." commandline + config dependent
>    interactions which have been not yet investigated down to their
>    root cause. Result in a boot hang. YMMV
>
> Patch against 3.0 can be found here:
>
>  http://www.kernel.org/pub/linux/kernel/projects/rt/patch-3.0-rt1.patch.bz2
>
> The split quilt queue is available at:
>
>  http://www.kernel.org/pub/linux/kernel/projects/rt/patches-3.0-rt1.tar.bz2
>
> Thanks,
>
>        tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
