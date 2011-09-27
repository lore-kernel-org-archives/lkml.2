Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab1I0Qtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 12:49:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:52138 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab1I0Qtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 12:49:43 -0400
Message-Id: <f80fcd$20puj0@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,450,1312182000"; 
   d="scan'208";a="67959392"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 7/9] drm/i915: Use CK505 as non-SSC source where available
To: Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
In-Reply-To: <1317103906-4649-8-git-send-email-keithp@keithp.com>
References: <yunbou6lxb4.fsf@aiko.keithp.com> <1317103906-4649-1-git-send-email-keithp@keithp.com> <1317103906-4649-8-git-send-email-keithp@keithp.com>
Date: Tue, 27 Sep 2011 17:49:39 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Sep 2011 23:11:44 -0700, Keith Packard <keithp@keithp.com> wrote:
> This eliminates VGA shimmer on some Ironlake machines which have a
> CK505 clock source.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
References: https://bugzilla.kernel.org/show_bug.cgi?id=21742
References: https://bugs.freedesktop.org/show_bug.cgi?id=38750
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
