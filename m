Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326Ab2HQPuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 11:50:21 -0400
Received: from mga10.intel.com ([192.55.52.92]:40340 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753814Ab2HQPuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 11:50:15 -0400
MIME-Version: 1.0
In-Reply-To: <1344918891-6283-6-git-send-email-keithp@keithp.com>
References: <1344918891-6283-1-git-send-email-keithp@keithp.com>
	<1344918891-6283-6-git-send-email-keithp@keithp.com>
Date: Fri, 17 Aug 2012 16:50:13 +0100
Message-ID: <CAPX-8+-VaU+i5Fm35O=FDAYqh88TSnTVjJ8TCrY2CYTfVJwydw@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH 5/7] drm/i915: Pipe-C only configurations
 would not get SR
From: "Lespiau, Damien" <damien.lespiau@intel.com>
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 5:34 AM, Keith Packard <keithp@keithp.com> wrote:
> These should probably all look like
>
>         enabled |= (1 << pipe)
>
> so that the intent is clear...
>
> Signed-off-by: Keith Packard <keithp@keithp.com>
> ---
>  drivers/gpu/drm/i915/intel_pm.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
> index 94aabca..1a84425 100644
> --- a/drivers/gpu/drm/i915/intel_pm.c
> +++ b/drivers/gpu/drm/i915/intel_pm.c
> @@ -1815,7 +1815,7 @@ static void sandybridge_update_wm(struct drm_device *dev)
>                 DRM_DEBUG_KMS("FIFO watermarks For pipe C -"
>                               " plane %d, cursor: %d\n",
>                               plane_wm, cursor_wm);
> -               enabled |= 3;
> +               enabled |= 4;
>         }

Looks like a very good catch!

Reviewed-by: Damien Lespiau <damien.lespiau@intel.com>

-- 
Damien
