Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab2DBImD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 04:42:03 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53647 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab2DBImB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 04:42:01 -0400
Date: Mon, 2 Apr 2012 10:41:52 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Rob Clark <rob.clark@linaro.org>, linaro-dev@lists.linaro.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: Linux 3.4-rc1
Message-ID: <20120402084152.GA4612@phenom.ffwll.local>
Mail-Followup-To: Kyungmin Park <kmpark@infradead.org>,
	Rob Clark <rob.clark@linaro.org>, linaro-dev@lists.linaro.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org
References: <CA+55aFy4aFGRLUrF+rYN3dskTepBtC+=x3B3bc_rzf1OaN_5pw@mail.gmail.com>
 <CAN_cFWMcttuebg_i8iWc+szDYMFT7gR=VJW0VtRj0Dh061Ob=A@mail.gmail.com>
 <CAH9JG2VujPUQfJ=7nyqM90jzuf60qqNYVi4fN40F1SpDua75gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH9JG2VujPUQfJ=7nyqM90jzuf60qqNYVi4fN40F1SpDua75gg@mail.gmail.com>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 12:40:39PM +0900, Kyungmin Park wrote:
> On Mon, Apr 2, 2012 at 12:34 AM, Rob Clark <rob.clark@linaro.org> wrote:
> > On Sat, Mar 31, 2012 at 6:58 PM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> >>  - drm dma-buf prime support. Dave Airlie sent me the pull request but
> >> didn't push very hard for it, it's in my "ok, I can still pull it for
> >> 3.4 if individual DRM driver people tell me that it will make their
> >> lives easier." So this is in limbo - I have nothing against it, but I
> >> won't pull unless I get a few people say "yes, please".
> >
> > yes, please :-)
> >
> > Note that the core drm dma-buf/prime support has already been reviewed
> > by a lot of folks, and tested with a few different drivers (exynos,
> > omapdrm, i915, nouveau, udl) with some driver support that could be
> > pushed for 3.5 cycle if the core support makes it in for 3.4 cycle.
> Yes, Please.
> 
> It's used for exynos display and multimedia.

Thirded.

There are a lot of loose pieces to juggle until we have everything in
place for buffer sharing (and quite a few of this involve contentious
topics). But this core piece for integrating dma-buf with drm here has
been acked/reviewd by all the relevant people and merging it would imo
greatly help in wiring up all the other loose ends.

Cheers, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
