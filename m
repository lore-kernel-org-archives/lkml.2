Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab1CYMlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 08:41:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42688 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750982Ab1CYMlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 08:41:16 -0400
Date: Fri, 25 Mar 2011 12:41:14 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [patch 09/10] mfd: Cleanup irq namespace
Message-ID: <20110325124114.GG31415@opensource.wolfsonmicro.com>
References: <20110325110939.701487744@linutronix.de>
 <20110325111218.440617746@linutronix.de>
 <20110325120830.GC22502@sirena.org.uk>
 <alpine.LFD.2.00.1103251333140.31464@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103251333140.31464@localhost6.localdomain6>
X-Cookie: Don't Worry, Be Happy.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 01:33:34PM +0100, Thomas Gleixner wrote:
> On Fri, 25 Mar 2011, Mark Brown wrote:

> > it looks like you also need to update the set_irq_flags() naming.

> No, that's an ARM thing.

It seems like if you're going through and renaming all the genirq APIs
then it'd be only sensible to also go through and do the same thing for
the ARM extensions, the new code looks less clean in the affected areas.
