Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab2BBDqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 22:46:09 -0500
Received: from mga14.intel.com ([143.182.124.37]:42455 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966Ab2BBDp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 22:45:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="102252938"
Date: Thu, 2 Feb 2012 11:35:24 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Keith Packard <keithp@keithp.com>
Subject: Re: Linux 3.3-rc2
Message-ID: <20120202033524.GA11360@localhost>
References: <CA+55aFye5iedspjus4YLi+r77Xq74bCq+MqU0HrTmDC5Dveivg@mail.gmail.com>
 <20120201175651.GA3300@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120201175651.GA3300@elliptictech.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick,

[snip]
> However, the _very next commit_:
> 
>   2deed761188d ("drm/i915: HDMI hot remove notification to audio driver")
> 
> reintroduces the log spam every mode change, with two additional lines
> printed each time (the lines prefixed with an asterisk are new):
> 
> * HDMI hot plug event: Codec=3 Pin=3 Presence_Detect=0 ELD_Valid=1
> * HDMI status: Codec=3 Pin=3 Presence_Detect=0 ELD_Valid=0
>   HDMI hot plug event: Codec=3 Pin=3 Presence_Detect=1 ELD_Valid=1
>   HDMI status: Codec=3 Pin=3 Presence_Detect=1 ELD_Valid=1
>   HDMI: detected monitor W2253 at connection type HDMI
>   HDMI: available speakers: FL/FR
>   HDMI: supports coding type LPCM: channels = 2, rates = 32000 44100 48000, bits = 16 20 24

Actually we have another patch to disable all the above printk lines:

alsa: hide HDMI/ELD printks unless in debug kernels
http://lists.freedesktop.org/archives/intel-gfx/2011-November/013322.html

And the plan is to merge it in the next release of all the ELD fixes,
which should be 3.4.

Thanks,
Fengguang
