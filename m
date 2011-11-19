Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab1KSCKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 21:10:24 -0500
Received: from mga14.intel.com ([143.182.124.37]:4498 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861Ab1KSCKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 21:10:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,537,1315206000"; 
   d="scan'208";a="76890590"
Date: Sat, 19 Nov 2011 10:10:19 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Keith Packard <keithp@keithp.com>
Cc: Takashi Iwai <tiwai@suse.de>, "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] drm/i915: hot removal notification to HDMI audio
 driver
Message-ID: <20111119021019.GA7297@localhost>
References: <20111116132004.299754849@intel.com>
 <20111116132221.374839261@intel.com>
 <20111116133548.GA23804@localhost>
 <20111118093740.GA2799@localhost>
 <86aa7tmigr.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86aa7tmigr.fsf@sumi.keithp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 19, 2011 at 01:46:44AM +0800, Keith Packard wrote:
> On Fri, 18 Nov 2011 17:37:40 +0800, Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > However when in X, ->mode_set won't be called at all.  Only
> > ->get_modes and ->detect are called...
> 
> The desktop software will call mode_set when it configures the
> monitor. Otherwise, it's not being used (and so shouldn't have audio
> routed to it by default).

Thanks for the info! I'll (borrow some monitor and) double check next week.

Anyway, the first two patches are good and may be taken first.

Thanks,
Fengguang
