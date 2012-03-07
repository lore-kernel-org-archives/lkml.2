Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab2CGNYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 08:24:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:27631 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464Ab2CGNYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 08:24:17 -0500
Message-Id: <aefc95$3e4riv@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="115502687"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 2/9] drm/i915/intel_i2c: assign HDMI port D to pin pair 6
To: Daniel Kurtz <djkurtz@chromium.org>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Yufeng Shen <miletus@chromium.org>, Benson Leung <bleung@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Sameer Nanda <snanda@chromium.org>
In-Reply-To: <1331121050-17857-3-git-send-email-djkurtz@chromium.org>
References: <1331121050-17857-1-git-send-email-djkurtz@chromium.org> <1331121050-17857-3-git-send-email-djkurtz@chromium.org>
Date: Wed, 07 Mar 2012 13:23:06 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  7 Mar 2012 19:50:43 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> According to i915 documentation [1], "Port D" (DP/HDMI Port D) is
> actually gmbus pin pair 6 (gmbus0.2:0 == 110b GPIOF), not 7 (111b).
> Pin pair 7 is a reserved pair.
> 
> [1] Documentation for [DevSNB+] and [DevIBX], as found on
> http://intellinuxgraphics.org

The problem is I took those definitions from the gen2 specs, and munged
in the obvious changes with gen3... And it appears that the GPIO pin
assignment versus GMBUS has changed over the years. And so the can of
worms is opened!
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
