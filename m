Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab1FNRXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 13:23:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:48132 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab1FNRXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 13:23:21 -0400
Message-Id: <f80fcd$h9106@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,365,1304319600"; 
   d="scan'208";a="18121734"
Date: Tue, 14 Jun 2011 18:23:16 +0100
To: Daniel J Blueman <daniel.blueman@gmail.com>, Eric Anholt <eric@anholt.net>
Subject: Re: [PATCH 3.0-rc3] i915: Fix gen6 (SNB) GPU stalling
Cc: Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@redhat.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel.blueman@gmail.com>
References: <1308070307-2630-1-git-send-email-daniel.blueman@gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <1308070307-2630-1-git-send-email-daniel.blueman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jun 2011 00:51:47 +0800, Daniel J Blueman <daniel.blueman@gmail.com> wrote:
> True; that is quite heavy handed delay looping.
> 
> It's a pity the usual Intel font didn't make it to the programmer's
> reference manuals. Anyway, unmasking the blitter user interrupt in the hardware
> status mask register addresses the root cause. Out of reset it's FFFFFFFFh,
> so we don't need to read it here.
> 
> It would be good to get this into -rc4. -stable probably needs some additional
> tweaks.
> 
> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

Tested-by: Chris Wilson <chris@chris-wilson.co.uk>

Should apply as is and be equally effective for stable.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
