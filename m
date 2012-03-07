Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab2CGMJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:09:53 -0500
Received: from mga03.intel.com ([143.182.124.21]:48154 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab2CGMJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:09:52 -0500
Message-Id: <c55c5d$2768q2@AZSMGA002.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="74654530"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 9/9] drm/i915/intel_i2c: reuse GMBUS2 value from polling loop
To: Daniel Kurtz <djkurtz@chromium.org>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Sameer Nanda <snanda@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
In-Reply-To: <1331121050-17857-10-git-send-email-djkurtz@chromium.org>
References: <1331121050-17857-1-git-send-email-djkurtz@chromium.org> <1331121050-17857-10-git-send-email-djkurtz@chromium.org>
Date: Wed, 07 Mar 2012 12:09:42 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  7 Mar 2012 19:50:50 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> Save the GMBUS2 value read while polling for state changes, and then
> reuse this value when determining for which reason the loops were exited.
> This is a small optimization which saves a couple of bus accesses for
> memory mapped IO registers.
> 
> Note: checkpatch doesn't like this ('assigning in if condition'), but it seems
> like the cleanest implementation.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
