Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1DRXJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 19:09:14 -0400
Received: from mail.perches.com ([173.55.12.10]:4823 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056Ab1DRXJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 19:09:12 -0400
Subject: Re: [PATCH 2/2] drm: Verify debug message arguments
From: Joe Perches <joe@perches.com>
To: Ian Romanick <idr@freedesktop.org>
Cc: David Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <4DACC2B9.3020200@freedesktop.org>
References: <cover.1303097621.git.joe@perches.com>
	 <c24620769d5864c0c0e460358b256acd0ada5c79.1303097621.git.joe@perches.com>
	 <4DACC2B9.3020200@freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Apr 2011 16:09:11 -0700
Message-ID: <1303168151.31723.50.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-18 at 16:01 -0700, Ian Romanick wrote:
> > @@ -214,9 +214,9 @@ parse_lfp_panel_data(struct drm_i915_private *dev_priv,
> >  	    i915_lvds_downclock) {
> >  		dev_priv->lvds_downclock_avail = 1;
> >  		dev_priv->lvds_downclock = temp_downclock;
> > -		DRM_DEBUG_KMS("LVDS downclock is found in VBT. ",
> > -				"Normal Clock %dKHz, downclock %dKHz\n",
> > -				temp_downclock, panel_fixed_mode->clock);
> > +		DRM_DEBUG_KMS("LVDS downclock is found in VBT. "
> > +			      "Normal Clock %dKHz, downclock %dKHz\n",
> > +			      temp_downclock, panel_fixed_mode->clock);
> >  	}
> >  	return;
> >  }
> Does this hunk only change white space, or am I missing something?

No, you're right.  It's just whitespace.
I prefer arguments aligned to open paren.


