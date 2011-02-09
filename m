Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab1BIT7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 14:59:24 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39734 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753616Ab1BIT7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 14:59:21 -0500
Date: Wed, 9 Feb 2011 19:59:18 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        Frank Rowand <frank.rowand@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Remove CONFIG_PM altogether, enable power management
 all the time
Message-ID: <20110209195918.GD23747@opensource.wolfsonmicro.com>
References: <4D51D341.3040209@am.sony.com>
 <20110209114137.GA10163@opensource.wolfsonmicro.com>
 <201102091807.03094.rjw@sisk.pl>
 <4D52DD81.7050401@am.sony.com>
 <20110209184010.GB23747@opensource.wolfsonmicro.com>
 <4D52E441.2000805@am.sony.com>
 <20110209192506.GC23747@opensource.wolfsonmicro.com>
 <4D52F0D0.9020609@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D52F0D0.9020609@am.sony.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 11:53:52AM -0800, Tim Bird wrote:
> On 02/09/2011 11:25 AM, Mark Brown wrote:

> > Not really, the goal was to simplify the PM config options to ones that
> > are actually useful and cut down on the number of silly combinations
> > that the randconfigs turn up.  CONFIG_PM is there mostly for historical
> > reasons, it doesn't really mean much by itself except as a gate to other
> > options.

> I'm confused.  Do you plan to retain the option to
> turn off PM features completely, or not?  I thought that's
> what CONFIG_PM did today.

Raphael's patches do that in a much better way than my original patch,
my original patch would have force CONFIG_PM on but still allowed all
the PM features that it controls to be turned on and off individually.
