Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab0LJSY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 13:24:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56242 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750790Ab0LJSY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 13:24:57 -0500
Date: Fri, 10 Dec 2010 18:24:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Peter Huewe <peterhuewe@gmx.de>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd/wm831x-irq: Convert to new irq_chip functions and
 fix build failure
Message-ID: <20101210182455.GJ3200@rakim.wolfsonmicro.main>
References: <1291937687-20243-1-git-send-email-peterhuewe@gmx.de>
 <12ABA93B-6923-4AF7-BF34-E070BE72A8E2@opensource.wolfsonmicro.com>
 <alpine.LFD.2.00.1012100233510.2653@localhost6.localdomain6>
 <20101210050755.GA21712@linux-sh.org>
 <20101210121420.GC3200@rakim.wolfsonmicro.main>
 <20101210154332.GB21712@linux-sh.org>
 <20101210172407.GF3200@rakim.wolfsonmicro.main>
 <20101210174843.GB3750@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101210174843.GB3750@linux-sh.org>
X-Cookie: Well thaaaaaaat's okay.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 11, 2010 at 02:48:43AM +0900, Paul Mundt wrote:

> I have no intention of dropping the select from SH, but I'm not going to
> insist that these drivers have the deprecated dependency if we're a) not
> really using them and b) there's a reasonable expectation that they'll
> basically be taken care of in .38 anyways.

That's unfortunate, I'm a bit concerned about support for users picking
up the kernel and using it to build products.

Samuel, would you be OK with cherry picking the relevant commits to the
Wolfson drivers back into .37?  I'm especially concerned about WM8994
here - I'd really not like to see a kernel version go out where that
doesn't work.

> I haven't been following the progress in -next, but now that you've
> pointed it out I'll give it a look. It's less effort to just fix up the
> remaining users than it is to audit API dependencies for all of them at
> least.

Probably slightly more in that you can't just blindly add the dependency
when you see the problem but yeah.
