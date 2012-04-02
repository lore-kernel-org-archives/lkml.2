Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab2DBJhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 05:37:24 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:60910 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751584Ab2DBJhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 05:37:23 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm/i915: disable ppgtt on snb when dmar is enabled
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Tony Vroon <tony@linx.net>
In-Reply-To: <1333354115-2430-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1333354115-2430-1-git-send-email-daniel.vetter@ffwll.ch>
Date: Mon, 02 Apr 2012 10:36:50 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1333359434_198686@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Apr 2012 10:08:35 +0200, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> Totally unexpected that this regressed. Luckily it sounds like we just
> need to have dmar disable on the igfx, not the entire system. At least
> that's what a few days of testing between Tony Vroon and me indicates.
> 
> Reported-by: Tony Vroon <tony@linx.net>
> Cc: Tony Vroon <tony@linx.net>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=43024
> Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Patch itself looks sane,

Acked-by: Chris Wilson <chris@chris-wilson.co.uk>

-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
