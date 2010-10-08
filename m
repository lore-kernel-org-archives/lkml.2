Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab0JHMar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 08:30:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:42618 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277Ab0JHMaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 08:30:46 -0400
Message-Id: <8u3s8d$jqj67o@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,302,1283756400"; 
   d="scan'208";a="665426168"
Date: Fri, 08 Oct 2010 13:30:42 +0100
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: "do_IRQ: 0.89 No irq handler for vector (irq -1)"
Cc: Dave Airlie <airlied@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>
References: <AANLkTikZj21CtFwC2ttvc0wJPx2qyedn7b1xXaxH659E@mail.gmail.com> <alpine.LFD.2.00.1010072227420.2484@localhost6.localdomain6> <alpine.LFD.2.00.1010072329220.3354@localhost6.localdomain6> <89k83a$9u8ggv@azsmga001.ch.intel.com> <alpine.LFD.2.00.1010081414130.13094@localhost6.localdomain6>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <alpine.LFD.2.00.1010081414130.13094@localhost6.localdomain6>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Oct 2010 14:15:29 +0200 (CEST), Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 8 Oct 2010, Chris Wilson wrote:
> 
> > That was a leak of the object handles which should have been fixed in
> > .36-rc2
> 
> Emphasis on should. That's rc7

Hmm, that's a new one then. Or, at least the one I know I introduced I
fixed.

> > The other horrible crashes look like the set of unload fixes that Daniel
> > Vetter supplied for .36-rc3 but we postponed to .37.
> 
> Well, then you better prevent the removal of the module until it's fixed.

Is __module_get(THIS_MODULE) sufficient?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
