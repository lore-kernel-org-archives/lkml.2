Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab2DWUnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 16:43:43 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34332 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab2DWUnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 16:43:41 -0400
Date: Mon, 23 Apr 2012 22:44:39 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Xi Wang <xi.wang@gmail.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Keith Packard <keithp@keithp.com>, security@kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2 1/2] drm/i915: fix integer overflow in
 i915_gem_execbuffer2()
Message-ID: <20120423204439.GM4935@phenom.ffwll.local>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Xi Wang <xi.wang@gmail.com>, Keith Packard <keithp@keithp.com>,
	security@kernel.org, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	dri-devel@lists.freedesktop.org
References: <1335168402-25174-1-git-send-email-xi.wang@gmail.com>
 <1335169134_26001@CP5-2952>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335169134_26001@CP5-2952>
X-Operating-System: Linux phenom 3.2.0-2-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 09:18:25AM +0100, Chris Wilson wrote:
> On Mon, 23 Apr 2012 04:06:41 -0400, Xi Wang <xi.wang@gmail.com> wrote:
> > On 32-bit systems, a large args->buffer_count from userspace via ioctl
> > may overflow the allocation size, leading to out-of-bounds access.
> > 
> > This vulnerability was introduced in commit 8408c282 ("drm/i915:
> > First try a normal large kmalloc for the temporary exec buffers").
> > 
> > Signed-off-by: Xi Wang <xi.wang@gmail.com>
> > Cc: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: stable@vger.kernel.org
> Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Both patches picked up for -fixes, thanks.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
