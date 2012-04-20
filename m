Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab2DTXnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 19:43:08 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:33098 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab2DTXnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 19:43:06 -0400
Date: Fri, 20 Apr 2012 16:43:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@android.com>, Thomas Gleixner <tglx@linutronix.de>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 0/4] Android Alarm Driver Cleanups (for staging-next/3.5)
Message-ID: <20120420234300.GB27780@kroah.com>
References: <1334950307-403-1-git-send-email-john.stultz@linaro.org>
 <20120420220849.GA5642@kroah.com>
 <4F91E9C1.4050102@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F91E9C1.4050102@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 03:57:05PM -0700, John Stultz wrote:
> On 04/20/2012 03:08 PM, Greg KH wrote:
> >On Fri, Apr 20, 2012 at 12:31:43PM -0700, John Stultz wrote:
> >>Greg: Would you mind applying this set to staging-next for 3.5?
> >It took some messing with (due to some over-eager people fixing spelling
> >mistakes and compiler warnings that you didn't have in your tree), but
> >I've applied these now.  Thanks for doing this work.
> >
> >But, as I already said, this patch set produces some big compiler
> >warnings, can you please fix them up before I get nasty messages from
> >the linux-next maintainer?
> Ok. So I manged to trigger the warning at patch 3/4 too. However,
> patch 4/4 resolves it.

Ah, I didn't notice that, you are right, nice.

> The problem is the android alarm driver and the alarmtimer code have
> a naming collision with "struct alarm", and there were some macros
> (see CONFIG_ANDROID_ALARM_OLDDRV_COMPAT in
> staging/android/android_alarm.h before these patches) that allow a
> easier transition over to the new code for out of tree drivers.
> 
> Ideally I would have yanked those macros in 3/4 instead of 4/4.  But
> after 4/4 is applied the issue should not longer be present (at
> least I've not been able to trigger it)
> 
> Do you want me to respin the last two patches?

No, they are both applied now, so all is good, sorry for the noise.

greg k-h
