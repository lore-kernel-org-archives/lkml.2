Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab2GSJxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 05:53:51 -0400
Received: from 1wt.eu ([62.212.114.60]:5019 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751Ab2GSJxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 05:53:48 -0400
Date: Thu, 19 Jul 2012 11:53:11 +0200
From: Willy Tarreau <w@1wt.eu>
To: John Stultz <johnstul@us.ibm.com>
Cc: stable@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] 2.6.32-stable: Fix for leapsecond deadlock & hrtimer/futex issue
Message-ID: <20120719095311.GE16208@1wt.eu>
References: <1342562735-55870-1-git-send-email-johnstul@us.ibm.com> <50060496.2090909@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50060496.2090909@us.ibm.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 05:34:30PM -0700, John Stultz wrote:
> On 07/17/2012 03:05 PM, John Stultz wrote:
> >This is the last backport I have ready at this time. I realize there's
> >still the 2.6.27 tree, but if I recall correctly I had some trouble
> >getting that booted in my test environment. I can take a swing at
> >backporting it, but I may need a hand with testing.
> 
> And if anyone is interested in helping test, I've got a first pass 
> (builds & mostly boots) of the 2.6.27-stable backports here:
> git://git.linaro.org/people/jstultz/linux.git leapfix/2.6.27.62
> 
> http://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=shortlog;h=refs/heads/leapfix/2.6.27.62
> 
> Unfortunately I run into udev issues trying to boot this on my more 
> recent test environment.

John, don't waste your time trying to boot older kernels, I'm well
equipped for this task and it's much easier for me, so let's split
the work efficiently :-)

Thanks,
Willy

