Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab0LRVkZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 16:40:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:6202 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199Ab0LRVkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 16:40:24 -0500
Message-Id: <5b55a1$j0av6h@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,194,1291622400"; 
   d="scan'208";a="637893841"
Date: Sat, 18 Dec 2010 21:40:00 +0000
To: Stephen Clark <sclark46@earthlink.net>, sclark46@earthlink.net
Subject: Re: I915 driver locks up
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4D0D19FF.4020600@earthlink.net>
References: <4D0D1516.3040404@earthlink.net> <4D0D19FF.4020600@earthlink.net>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Dec 2010 15:30:55 -0500, Stephen Clark <sclark46@earthlink.net> wrote:
> On 12/18/2010 03:09 PM, Stephen Clark wrote:
> > Hi,
> >
> > I am using 2.6.35.9-64.fc14.x86_64 running 1.3.9-1.fc14.x86_64
> > and am having my 945gma lock up in texture decompress according
> > to intel_gpu_top utility, when trying to play Myst 5.
> >
> > Any fixes on the horizon?
> >
> Additional data point with 2.6.37-0.rc6.git0.1.fc15.x86_64 from rawhide 
> I get:
> [  307.256028] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer 
> elapsed... GPU hung
> [  307.258118] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request 
> returns -11 (awaiting 27197 at 27195, next 27199)
> [  307.258975] [drm:i915_reset] *ERROR* Failed to reset chip.
> 
> and my X screen goes weird - have to switch to vty console.

Judging by your description, you've hit a bug in Mesa. Please verify the
bug with the current stable release (of Mesa) and file a bug report, and
be sure to include /sys/kernel/debug/dri/0/i915_error_state for the hang.

Thanks,
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
