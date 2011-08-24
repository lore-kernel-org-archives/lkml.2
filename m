Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab1HXALu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 20:11:50 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53794 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982Ab1HXALo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 20:11:44 -0400
Date: Wed, 24 Aug 2011 02:11:40 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steevven1 <steevven1@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Bug Report for Linux Kernel 3.x
Message-ID: <20110824001137.GA23979@somewhere>
References: <CAFWT=833UrQ0irJfL5z=6R97+wd4ewW9Cd88maeXhZ_95aMhsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFWT=833UrQ0irJfL5z=6R97+wd4ewW9Cd88maeXhZ_95aMhsw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 07:19:35PM -0400, Steevven1 wrote:
> Hello,
> 
> I would like to report what myself and several others believe to be a
> serious bug affecting all Linux kernels 3.0 and up, and none below 3.0
> (2.6.x and lower).
> 
> One-sentence description: On certain hardware, the 3.x series kernels
> drain a considerable amount more power than the 2.6-series kernels, up
> to 40% more, even when idle.
> 
> The specific hardware I have personally tested is a Lenovo ThinkPad
> X220 with an Intel SandyBridge i7 2620M processor. We think that this
> bug is POSSIBLY specific to this processor, or family of processors,
> commonly used in notebooks. A complete thread of mine and others'
> results, evidence, and troubleshooting process is located at:
> http://ubuntuforums.org/showthread.php?t=1822629
> 
> We have tried several different 3.0 and 3.1-series kernels, all with
> the same problems. One part of the problem was that the following
> (revealed by powertop) was causing excessive processor wakeups
> compared to the 2.6-series kernels: "[Rescheduling interrupts] <kernel
> IPI>"
> 
> Someone much more advanced than I figured out how to eliminate this
> problem and recompiled the kernel (which he posted in the thread I
> linked to previously), but power usage is still improved only
> slightly, nowhere near kernel 2.6 levels.
> 
> There is a lot more information I could give you here, but all of it
> is contained within the thread I linked to. If you have any specific
> questions, I will answer as quickly as possible.
> 
> Thanks a lot for your assistance. Please confirm that you received this email.
> 
> Steven Keys!

Hi Steve,


You said the problem with rescheduling interrupt disappeared but you
haven't said why. After reading the thread it seems it was about
Sparse irq config beeing enabled? And that disappeared after
sparse irq got disabled?

If so that looks like a first bug.

Also now that you don't see that problem anymore but still
a problem with power consumption, what does powertop report to
you?

Thanks.
