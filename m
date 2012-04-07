Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab2DGV4r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 17:56:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44580 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab2DGV4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 17:56:46 -0400
Date: Sat, 7 Apr 2012 14:56:41 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, neilb@suse.de,
        rpurdie@linux.intel.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] LEDS-One-Shot-Timer-Trigger-implementation
Message-ID: <20120407215641.GA4539@core.coreip.homeip.net>
References: <1333310039.2879.4.camel@lorien2>
 <20120406165353.ab667eb0.akpm@linux-foundation.org>
 <1333808024.2728.39.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333808024.2728.39.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shuah,

On Sat, Apr 07, 2012 at 08:13:44AM -0600, Shuah Khan wrote:
> 
> > > +This feature will help implement vibrate functionality which requires one
> > > +time activation of vibrate mode without a continuous vibrate on/off cycles.
> > 
> > They make vibrating LED? ;)
> > 
> > What's going on here?  You're proposing to repurpose the LEDs code to
> > drive vibration devices?  Or some devices couple a LED with a vibration
> > device?
> 
> I owe you filling in the blanks type explanation. Let me describe the
> use-case I am trying to address first. Vibrater function on phones is
> implemented using PWM pins on SoC or PMIC. When there is no such
> hardware present, a software solution is needed. Currently two drivers
> timed-gpio and timed-output (under staging/android in Linux 3.3)
> together implement the software vibrate feature. The main functionality
> it implements is the one time enables of timer to prevent user space
> crashes leaving the phone in vibrate mode causing the battery to drain.
> leds as it is implemented currently, is not suitable to address this
> use-case as it doesn't support one time enables.

So why do not you use memoryless force feedback framework that other
devices use (see drivers/input/misc/*vibra.c drivers).

Thanks.

-- 
Dmitry
