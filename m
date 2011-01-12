Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab1ALMOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 07:14:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:38322 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756060Ab1ALMOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 07:14:11 -0500
Message-Id: <0d30dc$kno619@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,312,1291622400"; 
   d="scan'208";a="695998505"
Date: Wed, 12 Jan 2011 12:14:07 +0000
To: Indan Zupancic <indan@nul.nu>
Subject: Re: Linux 2.6.37
Cc: Michal Hocko <mhocko@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
In-Reply-To: <b9dded$hknqnh@orsmga002.jf.intel.com>
References: <AANLkTikKA-nStyNjkdsVa8hd=PFQR3tYTJh3MnfpNkD8@mail.gmail.com> <20110106104816.GA4026@tiehlicka.suse.cz> <20110111171744.GA3854@tiehlicka.suse.cz> <1bdc18$j7rfh5@fmsmga002.fm.intel.com> <b34be07ef0c3e8fc82c29d4299f262e4.squirrel@webmail.greenhost.nl> <b9dded$hknqnh@orsmga002.jf.intel.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jan 2011 12:07:23 +0000, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> diff --git a/drivers/gpu/drm/i915/intel_panel.c
> b/drivers/gpu/drm/i915/intel_pan
> index e00d200..27c79c7 100644
> --- a/drivers/gpu/drm/i915/intel_panel.c
> +++ b/drivers/gpu/drm/i915/intel_panel.c
> @@ -278,6 +278,6 @@ void intel_panel_setup_backlight(struct drm_device
> *dev)
>  {
>         struct drm_i915_private *dev_priv = dev->dev_private;
>  
> -       dev_priv->backlight_level = intel_panel_get_max_backlight(dev);
> +       dev_priv->backlight_level = intel_panel_max_backlight(dev);
>         dev_priv->backlight_enabled = dev_priv->backlight_level != 0;

          dev_priv->backlight_level = intel_panel_get_backlight(dev);
-ETIRED

-- 
Chris Wilson, Intel Open Source Technology Centre
