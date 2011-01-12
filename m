Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab1ALXSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 18:18:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:35475 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753821Ab1ALXSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 18:18:17 -0500
Message-Id: <b7da2f$q4c60f@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,314,1291622400"; 
   d="scan'208";a="877008911"
Date: Wed, 12 Jan 2011 23:18:13 +0000
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] drm intel only fixes
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
In-Reply-To: <AANLkTin-yRw0tXzFkooeMWc-t4oi4akMYLaeDFgpVLZ=@mail.gmail.com>
References: <alpine.DEB.2.00.1101120601100.6210@skynet.skynet.ie> <AANLkTimgs8UfGWk5PCZi4PM5SsvejJd5Y4bb3nHGyZy2@mail.gmail.com> <20110112114649.5365d518@jbarnes-desktop> <AANLkTinSygbLm=nmXy_Wf2ENV8WcQqCc0BKAAOsysvZd@mail.gmail.com> <AANLkTimSKOa8XavLn_RsLZ2scZ=ujdYahcTkeJ2pxBFq@mail.gmail.com> <AANLkTi=80ccp1LtcXw1zO-7Rp58_+9yw-tebkJr67g9M@mail.gmail.com> <b7da2f$q4bsoi@fmsmga001.fm.intel.com> <AANLkTin-yRw0tXzFkooeMWc-t4oi4akMYLaeDFgpVLZ=@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jan 2011 15:05:36 -0800, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Wed, Jan 12, 2011 at 2:40 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > Just the SNB machine?
> 
> No. I just checked. Reverting that commit on my other machine makes
> that TED video on my Core i5 machine look fine too.
> 
> So it's definitely the same bug on both Sandybridge and Core-i5 (I
> guess that's "Ironlake" in the crazy intel codename naming), just two
> slightly different symptoms. And I worried a bit that my bisect was
> bogus, but with the revert clearing it up on the other machine, I'm
> confident the bisect was good too.
> 
> On my sandybridge machine, the corruption happens already at the gdm
> login screen, which is why I used that one to bisect things. I'm
> including a (bad) photo taken with my cellphone of what the corruption
> looks like - see how the "sandybridge.linux-foundation.org" machine
> name text has been corrupted, and obviously my name (and the "e" in
> Other). And that blue rounded rectangle should contain "Log in as
> torvalds" or something like that, but instead it's clear.

Yes, that looks consistent with using the wrong relocation entry or GTT
offset within the batch.

Thanks,
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
