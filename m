Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab0I3Rgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 13:36:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45306 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab0I3Rgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 13:36:54 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Proper kernel irq time accounting -v3
References: <1285788096-29471-1-git-send-email-venki@google.com>
	<8762xnwtjn.fsf@basil.nowhere.org>
	<AANLkTimd0Acz3kcNswBoDS2XytfUgbE+ZyTxHUAcNspa@mail.gmail.com>
Date: Thu, 30 Sep 2010 19:36:52 +0200
In-Reply-To: <AANLkTimd0Acz3kcNswBoDS2XytfUgbE+ZyTxHUAcNspa@mail.gmail.com>
	(Venkatesh Pallipadi's message of "Thu, 30 Sep 2010 09:37:17 -0700")
Message-ID: <87lj6juo97.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Venkatesh Pallipadi <venki@google.com> writes:
>
> Yes. Overhead will be RDTSC.
> notsc is a boot option that will disable this. I didn't want to have a

notsc is a very heavy hammer.

> specific run time option to disable this as we would already have
> other RDTSC users like native_sched_clock. Do you think we need a
> specific option to disable this feature? I don't like adding a runtime
> option because it complicates the code a bit (to handle things like
> someone turning it off and turning it on later, etc).

How about some benchmarks on a known slow TSC system, like a P4?

If you can't measure it even with high interrupt loads it is probably
not relevant. If it is it would be better to have a on/off switch.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
