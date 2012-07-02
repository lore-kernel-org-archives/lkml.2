Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab2GBSvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 14:51:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755810Ab2GBSvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 14:51:47 -0400
Date: Mon, 2 Jul 2012 14:51:03 -0400
From: Dave Jones <davej@redhat.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/2][RFC] Potential fix for leapsecond caused futex issue
 (v2)
Message-ID: <20120702185103.GA32257@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	John Stultz <johnstul@us.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Prarit Bhargava <prarit@redhat.com>, stable@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>
References: <1341167401-31342-1-git-send-email-johnstul@us.ibm.com>
 <4FF11FCB.4030207@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF11FCB.4030207@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2012 at 09:12:59PM -0700, John Stultz wrote:
 > On 07/01/2012 11:29 AM, John Stultz wrote:
 > > TODOs:
 > > * Chase down the futex/hrtimer interaction to see if this could
 > > be triggered in any other way.
 > > * Get Tglx's input/ack
 > > * Generate a backport for pre-v3.4 kernels
 > So while still waiting for feedback on the clock_was_set() change, I 
 > went ahead and generated backports for most of the stable kernels on 
 > kernel.org.
 > 
 > Clearly these shouldn't go anywhere until the fix is upstream, but since 
 > I assume there's a number of distro developers who are likely under 
 > pressure to have a fix soon, I wanted to make them available so no one 
 > is duplicating work.
 > 
 > You can find them here:
 > http://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=summary
 > 
 > I did boot and test each of those kernels with my leaptest-timer.c test 
 > successfully.

I'm curious how the test that I did with the kernel patch,
or Richard Cochran's userspace test program didn't trigger this bug
when we tested last week.

any ideas what we missed ?

	Dave
 
