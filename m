Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390Ab1DKXCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 19:02:37 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:53047 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab1DKXCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 19:02:33 -0400
X-Greylist: delayed 607 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Apr 2011 19:02:33 EDT
Date: Mon, 11 Apr 2011 18:51:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: John Stultz <john.stultz@linaro.org>, tglx@linutronix.de
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        Jiri Pinkava <jiri.pinkava@vscht.cz>,
        MikeFrysinger <vapier@gentoo.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [git pull] RTC fixups for 2.6.39
Message-ID: <20110411225147.GA30116@andromeda.dapyr.net>
References: <1301456369.25964.5.camel@work-vm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301456369.25964.5.camel@work-vm>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 08:39:29PM -0700, John Stultz wrote:
> Hey Thomas,

Hey Thomas,

I was wondering when you planned to push these up to Linus?

Without the "RTC: Fix early irqs caused by calling rtc_set_alarm too
early" which fixes a regression introduced by some earlier
patches that John added, Linux guests under Xen fail to boot.

Thank you,

Konrad
> 
> Here's a collection of RTC fixups for 2.6.39:
>   git://git.linaro.org/people/jstultz/linux.git fortglx/39/tip/timers/rtc
> 
> Let me know if you have any issues with them.
> thanks
> -john
> 
> 
> John Stultz (1):
>       RTC: Fix early irqs caused by calling rtc_set_alarm too early
> 
> Mike Frysinger (1):
>       RTC: add missing "return 0" in new alarm func for rtc-bfin.c
> 
> Vasily Khoruzhick (1):
>       RTC: Fix s3c compile error due to missing s3c_rtc_setpie
> 
>  drivers/rtc/class.c     |    2 +-
>  drivers/rtc/interface.c |   26 ++++++++++++++++++++++++++
>  drivers/rtc/rtc-bfin.c  |    2 ++
>  drivers/rtc/rtc-s3c.c   |    2 --
>  include/linux/rtc.h     |    2 ++
>  5 files changed, 31 insertions(+), 3 deletions(-)
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
