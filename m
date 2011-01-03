Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab1ACU5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 15:57:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53841 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab1ACU5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 15:57:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Rolland (=?utf-8?b?44Od44O844Or44O744Ot44Op44Oz?=) 
	<rol@witbe.net>
Subject: Re: [Bug #22542] [2.6.37-rc1] drm:i195 errors
Date: Mon, 3 Jan 2011 21:57:19 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc8+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Dave Airlie" <airlied@redhat.com>,
        "Keith Packard" <keithp@keithp.com>
References: <96DQe4a_2tH.A.4RE.497GNB@chimera> <201012311647.24673.rjw@sisk.pl> <20110103091055.600c72d5@tux.DEF.witbe.net>
In-Reply-To: <20110103091055.600c72d5@tux.DEF.witbe.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101032157.19528.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 03, 2011, Paul Rolland wrote:
> Hello Rafael,
> 
> On Fri, 31 Dec 2010 16:47:24 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Friday, December 31, 2010, Paul Rolland wrote:
> > > Hello,
> > > 
> > > I'm now running 2.6.37-rc8, and I still have :
> > > Dec 31 11:03:10 tux kernel: [drm:i915_gem_mmap_gtt_ioctl] *ERROR*
> > > Attempting to mmap a purgeable buffer
> > > 
> > > as well as :
> > > 
> > > Dec 31 10:44:53 tux kernel: [drm:intel_panel_get_max_backlight] *ERROR*
> > > fixme: max PWM is zero. Dec 31 10:49:34 tux kernel:
> > > [drm:intel_panel_get_max_backlight] *ERROR* fixme: max PWM is zero.
> > 
> > There were some last-minute fixes related to i915 added to the Linus' tree
> > after 2.6.37-rc8.  Perhaps you can give them a try?
> 
> OK, currently running : 
> [root@tux ~]# uname -a
> Linux tux.DEF.witbe.net 2.6.37-rc8-00014-g3643e0e #1 SMP Sun Jan 2 16:25:04 CET 2011 x86_64 x86_64 x86_64 GNU/Linux
> 
> and I've seen that too :
> Jan  3 08:27:30 tux kernel: [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to mmap a purgeable buffer
> Jan  3 08:27:30 tux kernel: [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to mmap a purgeable buffer
> Jan  3 08:27:30 tux kernel: [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to mmap a purgeable buffer
> Jan  3 08:27:30 tux kernel: [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to mmap a purgeable buffer
> 
> So, two possibilities :
>  - 2.6.37-rc8-00014-g3643e0e is not what you wanted me to test,
>  - the problem's still there.

I think it's still there.  Thanks for testing!

Rafael
