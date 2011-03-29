Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab1C2NWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 09:22:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:15059 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061Ab1C2NWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 09:22:40 -0400
Message-Id: <1bdc18$k1kc9s@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,262,1299484800"; 
   d="scan'208";a="672805180"
Date: Tue, 29 Mar 2011 14:22:37 +0100
To: Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH] drm/i915: Move the irq wait queue initialisation into the ring init
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <1301395589-8121-1-git-send-email-chris@chris-wilson.co.uk> <1301401385-8935-1-git-send-email-chris@chris-wilson.co.uk> <AANLkTin0bicOYyY2WCaBxN276t5RV-Q9UZVr=WQ6NmQe@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <AANLkTin0bicOYyY2WCaBxN276t5RV-Q9UZVr=WQ6NmQe@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Mar 2011 16:05:35 +0300, Pekka Enberg <penberg@kernel.org> wrote:
> On Tue, Mar 29, 2011 at 3:23 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > Required so that we don't obliterate the queue if initialising the
> > rings after the global IRQ handler is installed.
> >
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> 
> I applied both of the patches on top of yesterdays git HEAD and I just
> get a blank screen after GRUB. No serial or net console here. Do you
> want me to try just one of the patches or turn on some debugging
> options?

That was the unspoken side-effect: if we fail to load the i915 module after
disabling the outputs, then we would be left with a blank screen.

If you can ssh in and retrieve the dmesg, then it should at least give a
reason...
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
