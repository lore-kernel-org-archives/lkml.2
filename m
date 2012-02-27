Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab2B0SVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 13:21:25 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55980 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab2B0SVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 13:21:24 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of venki@google.com designates 10.50.189.200 as permitted sender) smtp.mail=venki@google.com; dkim=pass header.i=venki@google.com
MIME-Version: 1.0
In-Reply-To: <20120227073239.GA3397@elte.hu>
References: <1330122800-834-1-git-send-email-venki@google.com>
	<20120227073239.GA3397@elte.hu>
Date: Mon, 27 Feb 2012 10:21:23 -0800
Message-ID: <CABeCy1bXR7RDi8iOh1fD2XcM3x6weefzv_ZVNghOCkfK3csErQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] Extend mwait idle to optimize away CAL and RES
 interrupts to an idle CPU -v2
From: Venki Pallipadi <venki@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        Yong Zhang <yong.zhang0@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 26, 2012 at 11:32 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Venkatesh Pallipadi <venki@google.com> wrote:
>
>> [...] I did have to avoid x86 smpboot cleanup that Ingo
>> suggested as that did not seem trivial to me :-).
>
> Well, idletask_ti_flags is unacceptably ugly, please do the
> smpboot.c cleanup because that paves the way to add new features
> to the x86 idle code.
>

OK. Will look at this soon.
If everything else looks OK, can you queue up the first 3 patches in
the series somewhere so that it gets some wider testing. Things should
work without that idletask_ti_flags change.

Thanks,
Venki
