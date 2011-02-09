Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab1BIULA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 15:11:00 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42608 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753058Ab1BIUK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 15:10:57 -0500
Date: Wed, 9 Feb 2011 20:10:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tim Bird <tim.bird@am.sony.com>,
        "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        Frank Rowand <frank.rowand@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <len.brown@intel.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Remove CONFIG_PM altogether, enable power management
 all the time
Message-ID: <20110209201054.GE23747@opensource.wolfsonmicro.com>
References: <20110209195918.GD23747@opensource.wolfsonmicro.com>
 <Pine.LNX.4.44L0.1102091507550.2050-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1102091507550.2050-100000@iolanthe.rowland.org>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 03:09:42PM -0500, Alan Stern wrote:
> On Wed, 9 Feb 2011, Mark Brown wrote:

> > Raphael's patches do that in a much better way than my original patch,
> > my original patch would have force CONFIG_PM on but still allowed all
> > the PM features that it controls to be turned on and off individually.

> Or to put it another way, if you enable any of CONFIG_PM_SUSPEND, 
> CONFIG_PM_HIBERNATION, or CONFIG_PM_RUNTIME, then CONFIG_PM will 
> automatically be turned on.  Otherwise it will automatically be turned 
> off.

Plus everything controlled by the old CONFIG_PM_OPS is now controlled
directly by CONFIG_PM.
