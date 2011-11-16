Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab1KPNfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 08:35:54 -0500
Received: from mga03.intel.com ([143.182.124.21]:10735 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756857Ab1KPNfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 08:35:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,521,1315206000"; 
   d="scan'208";a="75651474"
Date: Wed, 16 Nov 2011 21:35:48 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Keith Packard <keithp@keithp.com>
Cc: Takashi Iwai <tiwai@suse.de>, "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] drm/i915: hot removal notification to HDMI audio
 driver
Message-ID: <20111116133548.GA23804@localhost>
References: <20111116132004.299754849@intel.com>
 <20111116132221.374839261@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111116132221.374839261@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry forgot to remove this left over chunk...

Note that I've not yet got the hardware to test the DisplayPort part
of this patch, but should be able to do so this week.

> --- linux.orig/drivers/gpu/drm/i915/intel_drv.h	2011-11-16 20:54:27.000000000 +0800
> +++ linux/drivers/gpu/drm/i915/intel_drv.h	2011-11-16 21:19:42.000000000 +0800
> @@ -382,6 +382,10 @@ extern void intel_fb_restore_mode(struct
>  extern void intel_init_clock_gating(struct drm_device *dev);
>  extern void intel_write_eld(struct drm_encoder *encoder,
>  			    struct drm_display_mode *mode);
> +extern void intel_hotplug_status(struct drm_device *dev,
> +			  struct drm_connector *connector,
> +			  struct drm_crtc *crtc,
> +			  enum drm_connector_status status);
>  extern void intel_cpt_verify_modeset(struct drm_device *dev, int pipe);
>  
>  #endif /* __INTEL_DRV_H__ */
