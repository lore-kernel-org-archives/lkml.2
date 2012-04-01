Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab2DAIpO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 04:45:14 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50493 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab2DAIpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 04:45:11 -0400
Date: Sun, 1 Apr 2012 10:45:06 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 00/10] vt-d irq_remap_ops patchset
Message-ID: <20120401084506.GD21108@gmail.com>
References: <1333133228-3134-1-git-send-email-suresh.b.siddha@intel.com>
 <20120331081407.GC15958@gmail.com>
 <CAE9FiQV-7rnVH1no3wbCJMq0L-FfbAEBh4+XDrnD93X_bK3HvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQV-7rnVH1no3wbCJMq0L-FfbAEBh4+XDrnD93X_bK3HvA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Sat, Mar 31, 2012 at 1:14 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> >
> >> Ingo,
> >>
> >> Here is the Joerg's irq_remap_ops patchset updated for the latest -tip.
> >> Simplified some of the naming conventions to follow the irq_remapping
> >> terminology. There are still some "if (irq_remapping_enabled)" checks in
> >> io_apic.c that I would like to roll into the new io_apic_ops. I will
> >> look into that shortly.
> >
> > Just wondering, has this been tested on affected hardware, on
> > top of latest -tip or so? I realize that most of these are
> > clean-ups so they should not break anything, but checking would
> > be worth it nevertheless.
> 
> Yes, I tested those patches on my setups with Nehalem, 
> Westmere, and Sandbridge.

ok, very good!

Thanks,

	Ingo
