Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab2HZSqm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 14:46:42 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44119 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab2HZSql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 14:46:41 -0400
Date: Sun, 26 Aug 2012 20:39:52 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH drm-next 2/3] drm/i915: Remove reference to
 drm_display_info raw_edid field
Message-ID: <20120826183952.GB5194@phenom.ffwll.local>
Mail-Followup-To: Sedat Dilek <sedat.dilek@gmail.com>,
	David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <1345846584-5910-1-git-send-email-sedat.dilek@gmail.com>
 <1345846584-5910-2-git-send-email-sedat.dilek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345846584-5910-2-git-send-email-sedat.dilek@gmail.com>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 12:16:23AM +0200, Sedat Dilek wrote:
> Reported-By: Stephen Rothwell <sfr@canb.auug.org.au>
> Acked-by: Jani Nikula <jani.nikula@intel.com>
> Acked-by: Dave Airlie <airlied@gmail.com>
> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>

This doesn't apply to my drm-intel-next tree any more - we've moved around
the assignement a bit.
-Daniel

> ---
>  drivers/gpu/drm/i915/intel_modes.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_modes.c b/drivers/gpu/drm/i915/intel_modes.c
> index 29b7259..4bc1c0f 100644
> --- a/drivers/gpu/drm/i915/intel_modes.c
> +++ b/drivers/gpu/drm/i915/intel_modes.c
> @@ -45,7 +45,6 @@ int intel_connector_update_modes(struct drm_connector *connector,
>  	drm_mode_connector_update_edid_property(connector, edid);
>  	ret = drm_add_edid_modes(connector, edid);
>  	drm_edid_to_eld(connector, edid);
> -	connector->display_info.raw_edid = NULL;
>  	kfree(edid);
>  
>  	return ret;
> -- 
> 1.7.9.5
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
