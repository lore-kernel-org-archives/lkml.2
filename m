Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab1BIRHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 12:07:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58498 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581Ab1BIRH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 12:07:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] Remove CONFIG_PM altogether, enable power management all the time
Date: Wed, 9 Feb 2011 18:07:02 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <4D51D341.3040209@am.sony.com> <20110209114137.GA10163@opensource.wolfsonmicro.com>
In-Reply-To: <20110209114137.GA10163@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102091807.03094.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 09, 2011, Mark Brown wrote:
> On Tue, Feb 08, 2011 at 03:35:29PM -0800, Frank Rowand wrote:
> 
> > For 2.6.38-rc4, x86_64, CONFIG_NR_CPUS=4:
> 
> > size vmlinux
> >    text     data       bss       dec      hex  filename
> > 
> > 6553910  3555020   9994240  20103170  132c002  vmlinux    with    CONFIG_PM
> > 6512652  3553116   9994240  20060008  1321768  vmlinux    without CONFIG_PM
> > 
> >   41258     1904         0     43162                      delta
> 
> > That is big enough for me to care.
> 
> Hrm, that's pretty surprising.  It'd be interesting to know how much of
> that is due to the PM core itself and how much of that is from drivers.
> For the drivers CONFIG_PM isn't really the option they should be using
> in the first place - they mostly want some combination of PM_SLEEP and
> PM_RUNTIME for the specific functionality.  I'm running some checks now.
> 
> >  > CONFIG_PM_SLEEP=y
> 
> Raphael's patch will make this a user visible option in place of raw
> CONFIG_PM by default so you'd be able to turn that off.

No, it won't (just to clarify).

Thanks,
Rafael
