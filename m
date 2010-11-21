Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab0KUKas (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 05:30:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:11171 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab0KUKar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 05:30:47 -0500
Message-Id: <0d30dc$k822nk@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,231,1288594800"; 
   d="scan'208";a="679545588"
Date: Sun, 21 Nov 2010 10:30:43 +0000
To: Chris Vine <chris@cvine.freeserve.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel 2.6.37-rc2 breaks i915 graphics
In-Reply-To: <20101121102344.7c590b99@laptop.homenet>
References: <20101121102344.7c590b99@laptop.homenet>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Nov 2010 10:23:44 +0000, Chris Vine <chris@cvine.freeserve.co.uk> wrote:
> Hi,
> 
> With kernel 2.6.37-rc2, i915 graphics usually fails on boot-up after
> modesetting with my Lenovo S12 netbook which uses the Intel 945GME
> Express Integrated Graphics Controller.  It displays up to the point at
> which modesetting takes place and then usually goes blank.
> 
> There may be some kind of race at work here: first, sometimes (maybe 1
> times in 4) graphics comes up correctly on a first cold boot, but I
> have never managed to get it to come up on a warm reboot. Secondly,
> graphics can be restored when I know (but cannot see) that boot-up has
> concluded, simply by suspending the laptop and then resuming.  Resuming
> the laptop after a suspend always brings up the graphics correctly.

Add drm.debug=0xe to your boot commandline and compare if there is any
difference between a successful cold boot, a broken cold boot and a warm
boot. Similarly, comparing the output of intel_reg_dumper after each
should yield a few clues as to what stage in the boot process we fail.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
