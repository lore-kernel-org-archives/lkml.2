Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143Ab1KKTFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 14:05:06 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:34146 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab1KKTFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 14:05:01 -0500
Message-ID: <1321038249.2129.4.camel@js-netbook>
Subject: Re: [GIT PULL] clocksource:  Avoid possible mult overflows
From: John Stultz <johnstul@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, David Daney <ddaney.cavm@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Chen Jie <chenj@lemote.com>,
        zhangfx <zhangfx@lemote.com>
Date: Fri, 11 Nov 2011 11:04:09 -0800
In-Reply-To: <20111111071225.GB14347@elte.hu>
References: <1320953625.10668.86.camel@work-vm>
	 <20111111071225.GB14347@elte.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11111119-1780-0000-0000-000000DAF55B
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000230; HX=3.00000177; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00086730; UDB=6.00023500; UTC=2011-11-11
 19:04:57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-11 at 08:12 +0100, Ingo Molnar wrote:
> * john stultz <johnstul@us.ibm.com> wrote:
> 
> > Hey Ingo,
> > 	Here's the revised fix to the mult overflow issue against
> > tip/timers/core. Let me know if you hit any other issues.
> > 
> > thanks
> > -john
> > 
> > 
> >   git://git.linaro.org/people/jstultz/linux.git formingo/3.2/tip/timers/core
> 
> Pulled, thanks John!
> 
> Note, it was not based on the latest tip:timers/core branch of:
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git

Ah. I had set my remote to:
	git://git.kernel.org/pub/scm/linux/kernel/git/mingo/tip.git

> and it conflicted with another patch of yours (trivially). I've 
> resolved the conflict, please double check that it's all fine.

So, tip/timers/core doesn't seem to have the patch.

tip/timers/urgent has the original version, not the current v3.

Where exactly did you pull this one to?

thanks
-john

