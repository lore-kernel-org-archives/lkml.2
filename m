Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab1DKP52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 11:57:28 -0400
Received: from ip-67-205-80-138.static.privatedns.com ([67.205.80.138]:10907
	"EHLO node250.e-blokos.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539Ab1DKP51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 11:57:27 -0400
X-Greylist: delayed 918 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Apr 2011 11:57:27 EDT
Message-ID: <497D1168CB2F407F9005845B39FEF144@e1705>
From: "Madovsky" <infos@madovsky.org>
To: "Thomas Gleixner" <tglx@linutronix.de>,
        "LKML" <linux-kernel@vger.kernel.org>
Cc: "linux-rt-users" <linux-rt-users@vger.kernel.org>
References: <alpine.LFD.2.00.1104111723020.4501@localhost6.localdomain6>
Subject: Re: [ANNOUNCE] 2.6.33.9-rt31
Date: Mon, 11 Apr 2011 11:42:04 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

the links below don't show any new kernels or
not found pages

Regards

Franck
----- Original Message ----- 
From: "Thomas Gleixner" <tglx@linutronix.de>
To: "LKML" <linux-kernel@vger.kernel.org>
Cc: "linux-rt-users" <linux-rt-users@vger.kernel.org>
Sent: Monday, April 11, 2011 11:35 AM
Subject: [ANNOUNCE] 2.6.33.9-rt31


> We are pleased to announce the next update to our new preempt-rt
> series which is mostly a forward to 2.6.33.9. Thanks Greg !
>
> RT specific patches since 2.6.33.7.2-rt30
>
> 8a97f01: arm: mxc: Add sched_clock to mxc-platform
> a5a2b75: arm: mxc: Add add dummy_get_cycles()
> c1d6834: trace: Add timestamp to maxlatproc data
> cfe9ed2: trace: Add current task to maxlatproc data
> 70fdd17: trace: Add timeroffset to maxlatproc data
> db2aacd: trace: timer offsets histogram consider smp same prio
> 3115eb2: x86, hotplug: Revert 74a6e0fd8 (x86, hotplug: Use mwait to ...)
> 250bf15: ARM: sched_clock: make minsec argument to 
> clocks_calc_mult_shift() zero
> c04f3a8: ARM: sched_clock: allow init_sched_clock() to be called early
> 4d79f92: ARM: sched_clock: provide common infrastructure for sched_clock()
> 7443ac2: asm-generic/percpu: fixup RT mismerge
> 7e1c4f9: rtmutex: Ensure only the top waiter or higher priority task can 
> take the lock
> 47b3309: rtmutex: Fix comment about why new_owner can be NULL in 
> wake_futex_pi()
> 2ce1161: rtmutex: Revert Optimize rt lock wakeup
> 9704792: rtmutex: Try to take lock early in rt_spin_lock_slowlock()
> 5995a44: rtmutex: Only save lock depth once in spin_slowlock
>
> Download locations:
>
>    http://www.kernel.org/pub/linux/kernel/projects/rt/
>
> Git release branch:
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git 
> rt/2.6.33
>
> Gitweb:
> 
> http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=rt/2.6.33
>
> Information on the RT patch can be found at:
>
>    http://rt.wiki.kernel.org/index.php/Main_Page
>
> to build the 2.6.33.9-rt31 tree, the following patches should be
> applied:
>
>    http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.33.9.tar.bz2
> 
> http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.33.9-rt31.bz2
>
> Enjoy !
>
>      tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html 

