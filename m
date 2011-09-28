Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab1I1SWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 14:22:50 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65309 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab1I1SWt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 14:22:49 -0400
MIME-Version: 1.0
In-Reply-To: <1317103906-4649-1-git-send-email-keithp@keithp.com>
References: <yunbou6lxb4.fsf@aiko.keithp.com>
	<1317103906-4649-1-git-send-email-keithp@keithp.com>
Date: Wed, 28 Sep 2011 15:22:48 -0300
Message-ID: <CA+gsUGTZfxt2L9mT-kYGGKiYhtRKn2xO5tXperwAWLVi2mKeOQ@mail.gmail.com>
Subject: Re: [Intel-gfx] PCH reference clock cleanups
From: Paulo Zanoni <przanoni@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/27 Keith Packard <keithp@keithp.com>:
> Here's a patch sequence which cleans up a bunch of PCH refclk related
> bits.

For the series: Tested-by: Paulo Zanoni <paulo.r.zanoni@intel.com>

Tested all the patches on Ironlake (LVDS + VGA). Fixes fd.o bug #38750 for me.

I also tested the patch you sent today 1 hour ago (inline in one of
the emails) and things still work with it. I'll keep using these
patches since they fix my laptop. Any problem will be reported.

Maybe my email client/server is ruining things, but I believe patch 7
includes whitespace errors.

> There are a couple of questionable patches that I'd like to see
> people look at:
>
>  [PATCH 6/9] drm/i915: Fix PCH SSC reference clock settings
>  [PATCH 9/9] drm/i915: Initialize PCH refclks at modeset init time
>
> Here's the main patch -- this looks at the global set of encoders and
> figures out what the refclk should be to make all of those work
> correctly. Nothing is dependent on the active configuration, so we
> aren't reprogramming this register during run-time. The last patch in
> the sequence moves the setting of this register from modeset time to
> init time.
>
>  [PATCH 7/9] drm/i915: Use CK505 as non-SSC source where available
>
> This is a small piece straight from Jesse's patch; just uses the VBT
> configuration for CK505 clock sources.
>
>  [PATCH 8/9] drm/i915: All PCH refclks are 120MHz
>
> Ok, so I'd love to know where in any PCH reference matter someone has
> found a place where the reference clock for any of the PLLs is
> anything other than 120MHz. Can someone find a reference for other frequencies?
>
> --
> keith.packard@intel.com
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx
>

-- 
Paulo Zanoni
