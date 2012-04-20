Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab2DTWIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 18:08:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64077 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab2DTWIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 18:08:53 -0400
Date: Fri, 20 Apr 2012 15:08:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@android.com>, Thomas Gleixner <tglx@linutronix.de>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 0/4] Android Alarm Driver Cleanups (for staging-next/3.5)
Message-ID: <20120420220849.GA5642@kroah.com>
References: <1334950307-403-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334950307-403-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 12:31:43PM -0700, John Stultz wrote:
> This patch-set moves the Android alarm driver in staging to use
> the upstreamed CLOCK_BOOTTIME and alarmtimer interfaces, allowing
> us to greatly shrink the alarm driver.
> 
> The Google Android team has been using these patches in its AOSP tree
> for a little while without any reported issues.
> 
> The only gotcha is that I needed to make one alarmtimer interface
> non-static in order to support the android alarm driver. This sort
> of is a grey area for the staging tree, but I'm the author of the
> upstreamed alarmtimer code, and Thomas (cc'ed) had no objection
> to this patch going in via the staging tree, instead of -tip so 
> this should be ok (and much simpler then dealing with
> cross-maintainer dependencies).
> 
> Greg: Would you mind applying this set to staging-next for 3.5?

It took some messing with (due to some over-eager people fixing spelling
mistakes and compiler warnings that you didn't have in your tree), but
I've applied these now.  Thanks for doing this work.

But, as I already said, this patch set produces some big compiler
warnings, can you please fix them up before I get nasty messages from
the linux-next maintainer?

thanks,

greg k-h
