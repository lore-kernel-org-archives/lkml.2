Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555Ab2CGSIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 13:08:30 -0500
Received: from mga03.intel.com ([143.182.124.21]:62670 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732Ab2CGSI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 13:08:29 -0500
Message-Id: <d08817$3ejp7k@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="115991796"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 2/9] drm/i915/intel_i2c: assign HDMI port D to pin pair 6
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Yufeng Shen <miletus@chromium.org>, Benson Leung <bleung@chromium.org>,
        Sameer Nanda <snanda@chromium.org>
In-Reply-To: <CAGS+omDvcmfVAh_Tx64SdC0Ys8FOgZXjbYmPO8SrgQW_1aPOJg@mail.gmail.com>
References: <1331121050-17857-1-git-send-email-djkurtz@chromium.org> <1331121050-17857-3-git-send-email-djkurtz@chromium.org> <aefc95$3e4riv@orsmga001.jf.intel.com> <CAGS+omDvcmfVAh_Tx64SdC0Ys8FOgZXjbYmPO8SrgQW_1aPOJg@mail.gmail.com>
Date: Wed, 07 Mar 2012 18:07:54 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2012 02:02:03 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> I'm not sure what exactly you mean by gen2 and gen3 specs, but, as far as I
> can tell, the GPIO pin assignment is the same for both Cougar Point (Sandy
> Bridge) [1] and Ibex Peak (?) [2].  Although, the documentation is a bit
> confusing and it is difficult to tell.
> 
> [1] http://intellinuxgraphics.org/documentation/SNB/IHD_OS_Vol3_Part3.pdf
> [2] http://intellinuxgraphics.org/IHD_OS_Vol3_Part3r2.pdf
> 
> What do you mean exactly by gen2 & gen3?  Can you point to docs?
gen2 == 830gm,845g,855gm,865g
gen3 == 915g,945g,PineView

Those docs have not been completely scrubbed and made public yet.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
