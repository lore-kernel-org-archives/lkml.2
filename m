Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab2KCUEw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 16:04:52 -0400
Received: from smtp.domeneshop.no ([194.63.252.54]:44149 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab2KCUEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 16:04:49 -0400
Message-ID: <50956ADA.6090108@paradoxuncreated.com>
Date: Sat, 03 Nov 2012 20:04:58 +0100
From: Ove Karlsen <ove.karlsen@paradoxuncreated.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.6.5-rt14
References: <alpine.LFD.2.02.1211012148170.2756@ionos>
In-Reply-To: <alpine.LFD.2.02.1211012148170.2756@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Den 01.11.2012 21:57, skrev Thomas Gleixner:
> Dear RT Folks,
>
> I'm pleased to announce the 3.6.5-rt14 release. 3.6.4-rt12 is an
> intermediate release with a few changes. 3.6.5-rt13 is an update to
> 3.6.5 and 3.6.5-rt14 has a fix for my stupidity to release from the
> wrong tree missing a fix for x86-32.
>
> Changes since 3.6.3-rt11:
>
>     * Fix the fallout of preempt_lazy
>
>     * Add preempt_lazy support for ARM and POWERPC
>
>     * Fix a 32bit compile warning which got introduced with the
>       random fixes.
>
>     * Fix a missing lock conversion in the decive tree code
>
> The delta patch against 3.6.4-rt11 is can be found here:
>
>    http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/incr/patch-3.6.4-rt11-rt12.patch.xz
>
> The RT patch against 3.6.5 can be found here:
>
>    http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patch-3.6.5-rt14.patch.xz
>
> The split quilt queue is available at:
>
>    http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patches-3.6.5-rt14.tar.xz
>
> Enjoy,
>
> 	tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Heya I see jitter is a focus on the RT patch.
I was wondering, what settings in features.h gives the least jitter? (I 
am a real perfectionist)
Also what kind of threadpriorities gives the least jitter, particulary 
with a focus on OpenGL? (Should some kernelthreads be reniced, for 
instance softirqs etc)
And have you given consideration to the fact that most distros and OS 
grow with some levels of bloat, and everyone can`t be an expert, so 
maybe one shold consider a (scheduler) queue for "bloat", and one queue 
for main app, so that even bloated distros can run with the jitteramount 
of a highly specialized distro? (for instance 
mainapp,service1,mainapp,service2,mainapp,service3), if bloat is on 
queue 2. Or is thins kind of thinking already in batch, or idle?
-- 
Fred være med deg / Peace Be with You,
Ove Karlsen
http://www.paradoxuncreated.com
