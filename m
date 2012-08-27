Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab2H0PLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 11:11:20 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41550 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab2H0PLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 11:11:19 -0400
Date: Mon, 27 Aug 2012 17:11:43 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Remove __GFP_NO_KSWAPD
Message-ID: <20120827151143.GC5376@phenom.ffwll.local>
Mail-Followup-To: Sedat Dilek <sedat.dilek@gmail.com>,
	David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <1346068957-27754-1-git-send-email-sedat.dilek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346068957-27754-1-git-send-email-sedat.dilek@gmail.com>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 02:02:37PM +0200, Sedat Dilek wrote:
> When I pulled-in today's drm-intel-next into linux-next (next-20120824)
> I saw this build-breakage:
> 
> drivers/gpu/drm/i915/i915_gem.c: In function 'i915_gem_object_get_pages_gtt':
> drivers/gpu/drm/i915/i915_gem.c:1778:40: error: '__GFP_NO_KSWAPD' undeclared (first use in this function)
> drivers/gpu/drm/i915/i915_gem.c:1778:40: note: each undeclared identifier is reported only once for each function it appears in
> 
> This is caused by commit ba099ef165f8 ("mm: remove __GFP_NO_KSWAPD")
> and commit b6beae2c2014 ("mm: remove __GFP_NO_KSWAPD fixes") in
> linux-next (next-20120824).
> 
> Fix this by removing __GFP_NO_KSWAPD from drm/i915 driver.
> 
> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>

Queued for -next, thanks for the patch.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
