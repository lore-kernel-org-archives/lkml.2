Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab1ACT7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 14:59:40 -0500
Received: from mga14.intel.com ([143.182.124.37]:39696 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823Ab1ACT7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 14:59:39 -0500
Message-Id: <849307$b0clt4@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,268,1291622400"; 
   d="scan'208";a="369514418"
Date: Mon, 03 Jan 2011 19:59:34 +0000
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Knut Petersen <Knut_Petersen@t-online.de>
Subject: Re: [PATCH] Fix i915 drm regression on AOpen i915GMm-HFS motherboard
Cc: airlied@linux.ie, eric@anholt.net, jesse.barnes@intel.com,
        linux-kernel@vger.kernel.org,
        intel-gfx <intel-gfx@lists.freedesktop.org>, gregkh@suse.de
In-Reply-To: <AANLkTikffkQJnVKzcGhEZjPqg_iQPQ+P2Bbqz7A9Unq_@mail.gmail.com>
References: <4D21DC41.8070408@t-online.de> <b7da2f$q1ffv6@fmsmga001.fm.intel.com> <4D22119B.9050007@t-online.de> <AANLkTikffkQJnVKzcGhEZjPqg_iQPQ+P2Bbqz7A9Unq_@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Jan 2011 11:45:48 -0800, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Mon, Jan 3, 2011 at 10:12 AM, Knut Petersen
> <Knut_Petersen@t-online.de> wrote:
> >
> > I tried 2.6.37-rc8-git2 with both patches applied.
> 
> I thought Chris meant "instead of", rather than "both". Chris?

Right, I was trying to ascertain whether the intel_lvds_ddc_probe()
correctly detected the missing panel. That function currently requires
GMBUS to differentiate between a NAK and an IO error (bitbanging just
returns EREMOTEIO regardless, iirc). So far it has been successful in
detecting one false-positive for an AOpen All-in-one and hasn't fouled
up LVDS detection for the laptops I have.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
