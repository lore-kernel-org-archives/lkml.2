Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab2IGX43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 19:56:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50910 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab2IGX42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 19:56:28 -0400
Date: Fri, 7 Sep 2012 16:56:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Fries <david@fries.net>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Matthew Garrett <mjg@redhat.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] rtc_sysfs_show_hctosys 0 if resume failed
Message-Id: <20120907165626.c9b842b1.akpm@linux-foundation.org>
In-Reply-To: <20120826021931.GA20620@spacedout.fries.net>
References: <20120826021931.GA20620@spacedout.fries.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Aug 2012 21:19:31 -0500
David Fries <david@fries.net> wrote:

> Subject: [PATCH] rtc_sysfs_show_hctosys 0 if resume failed

This doesn't make much sense.  Did you mean "rtc_sysfs_show_hctosys():
display 0 if resume failed"?

> The original rtc_sysfs_show_hctosys returnd 1 if this device was the
> CONFIG_RTC_HCTOSYS_DEVICE device, a later patch checked
> rtc_hctosys_ret from boot, this verifies boot do_settimeofday
> succeeded, and sets rtc_hctosys_ret in resume to indicate when
> adjusting the clock from resume fails.
> 
> This uses only CONFIG_RTC_HCTOSYS_DEVICE for conditional compilation
> instead of it and CONFIG_RTC_HCTOSYS.  rtc_hctosys_ret was moved to
> class.c so rtc_hctosys can be removed with just a Kconfig change if
> boot time setting isn't desired.

And this makes my head spin.  What does the patch actually do?  I think
it might fix a bug, but it's unclear what that bug is.

Can you please write a better changelog and title and resend?

Sorry.
