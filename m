Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab1GJKjy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 06:39:54 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33811 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab1GJKjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 06:39:52 -0400
Date: Sun, 10 Jul 2011 11:39:22 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@fluxnic.net>,
        Marc Zyngier <marc.zyngier@arm.com>, John Stultz <johnstul@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wim Van Sebroeck <wim@iguana.be>, "arm@kernel.org" <arm@kernel.org>,
        Vitaly Kuzmichev <vkuzmichev@mvista.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2 0/6] arm_smp_twd: mpcore_wdt: Fix MPCORE watchdog
	setup
Message-ID: <20110710103922.GB4812@n2100.arm.linux.org.uk>
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com> <1309892440-3260-1-git-send-email-vkuzmichev@mvista.com> <4E14337F.1050101@arm.com> <20110706101456.GN8286@n2100.arm.linux.org.uk> <20110706110548.GA31936@1n450.cable.virginmedia.net> <20110706111603.GS8286@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706111603.GS8286@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 12:16:03PM +0100, Russell King - ARM Linux wrote:
> On Wed, Jul 06, 2011 at 12:05:48PM +0100, Catalin Marinas wrote:
> > On Wed, Jul 06, 2011 at 11:14:56AM +0100, Russell King - ARM Linux wrote:
> > > Do we know why the calibration was initially introduced?  FWIR, it came
> > > from the SMP group in ARM, so I guess they had a reason for it rather
> > > than copying x86.
> > 
> > I think it was introduced because the TWD frequency is half of the CPU
> > frequency but the latter may not be known - boot monitor configuration
> > could change it.
> 
> Okay, that implies we can't have a fixed frequency built into the kernel
> then.  For such platforms like the ARM dev boards (realview + vexpress),
> I expect we can read the CPU frequency from somewhere like one of the
> ICST PLLs.

So how do we do that?  I see this as a blocker on these patches.
