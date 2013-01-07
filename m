Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab3AGQqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 11:46:34 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:37434 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab3AGQqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 11:46:33 -0500
Date: Mon, 7 Jan 2013 17:40:35 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx@lists.freedesktop.org, Alexey Zaytsev <alexey.zaytsev@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Treat crtc->mode.clock == 0 as disabled
Message-ID: <20130107164035.GT5737@phenom.ffwll.local>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	intel-gfx@lists.freedesktop.org,
	Alexey Zaytsev <alexey.zaytsev@gmail.com>,
	linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>, stable@vger.kernel.org
References: <CAKMK7uH2L=tPUszeO7XMHJjXiJ5ZcG+wVi5u5c2UeQa8-xM=YQ@mail.gmail.com>
 <1357553501-8783-1-git-send-email-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357553501-8783-1-git-send-email-chris@chris-wilson.co.uk>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 10:11:40AM +0000, Chris Wilson wrote:
> Prevent a divide-by-zero by consistently treating an 'active' CRTC
> without a mode set as actually disabled.
> 
> This looks to have been first introduced with
> 
> commit 24929352481f085c5f85d4d4cbc919ddf106d381
> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> Date:   Mon Jul 2 20:28:59 2012 +0200
> 
>     drm/i915: read out the modeset hw state at load and resume time
> 
> but then combined with
> 
> commit b0a2658acb5bf9ca86b4aab011b7106de3af0add
> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> Date:   Tue Dec 18 09:37:54 2012 +0100
> 
>     drm/i915: don't disable disconnected outputs
> 
> it finally started oopsing.
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Reported-and-tested-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
> Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: stable@vger.kernel.org

Picked up for -fixes, thanks for the patch.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
