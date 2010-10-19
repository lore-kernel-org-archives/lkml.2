Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab0JSBer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 21:34:47 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48202 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985Ab0JSBeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 21:34:46 -0400
Subject: Re: [PATCH 4/6] [RFC] RTC: Rework RTC code to use timerlist for
 events
From: john stultz <johnstul@us.ibm.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
In-Reply-To: <20101018141056.0b916878@linux.lan.towertech.it>
References: <1287189535-24649-1-git-send-email-john.stultz@linaro.org>
	 <1287189535-24649-2-git-send-email-john.stultz@linaro.org>
	 <1287189535-24649-3-git-send-email-john.stultz@linaro.org>
	 <1287189535-24649-4-git-send-email-john.stultz@linaro.org>
	 <1287189535-24649-5-git-send-email-john.stultz@linaro.org>
	 <20101018141056.0b916878@linux.lan.towertech.it>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 18:34:15 -0700
Message-ID: <1287452055.2758.62.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 14:10 +0200, Alessandro Zummo wrote:
> On Fri, 15 Oct 2010 17:38:53 -0700
> John Stultz <john.stultz@linaro.org> wrote:
> 
> > This patch reworks a large portion of the generic RTC code
> > to in-effect virtualize the rtc interrupt code.
> > 
> > The current RTC interface is very much a raw hardware interface.
> > Via the proc, /dev/, or sysfs interfaces, applications can set
> > the hardware to trigger interrupts in one of three modes:
> 
>  [...]
> 
> 
>  If everything still works after all those changes,
>  it seems a good thing to me ;)

Heh, well, that's a good bit less resistance then I thought I'd get :)

Not that I'm complaining, but Is there anyone else in the RTC community
that you'd recommend getting feedback from on a change this large? I
just want to try to get any back-to-the-blackboard level feedback early
on if possible.

Also, are there any other RTC test cases (other then whats in
Documentation/rtc.txt) that you might recommend to help insure things
are bug-free before submission?

thanks
-john


