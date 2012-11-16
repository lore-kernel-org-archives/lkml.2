Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab2KPRrL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:47:11 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40175 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab2KPRrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:47:09 -0500
MIME-Version: 1.0
In-Reply-To: <20121116171702.GB5854@phenom.ffwll.local>
References: <20121116171702.GB5854@phenom.ffwll.local>
Date: Fri, 16 Nov 2012 12:47:08 -0500
Message-ID: <CADnq5_NBz=Fk_n=Gkq9r9P6b+uq8c8MMVApjKdqhRrj44bgm7Q@mail.gmail.com>
Subject: Re: [pull] drm-intel-next
From: Alex Deucher <alexdeucher@gmail.com>
To: Dave Airlie <airlied@gmail.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 12:17 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> Hi Dave,
>
> Highlights of this -next round:
> - ivb fdi B/C fixes
> - hsw sprite/plane offset fixes from Damien
> - unified dp/hdmi encoder for hsw, finally external dp support on hsw
>   (Paulo)
> - kill-agp and some other prep work in the gtt code from Ben
> - some fb handling fixes from Ville
> - massive pile of patches to align hsw VGA with the spec and make it
>   actually work (Paulo)
> - pile of workarounds from Jesse, mostly for vlv, but also some other
>   related platforms
> - start of a dev_priv reorg, that thing grew out of bounds and chaotic
> - small bits&pieces all over the place, down to better error handling for
>   load-detect on gen2 (Chris, Jani, Mika, Zhenyu, ...)
>
> On top of the previous pile (just copypasta):
> - tons of hsw dp prep patches form Paulo
> - round scheduled work items and timers to nearest second (Chris)
> - some hw workarounds (Jesse&Damien)
> - vlv dp support and related fixups (Vijay et al.)
> - basic haswell dp support, not yet wired up for external ports (Paulo)
> - edp support (Paulo)
> - tons of refactorings to prepare for the above (Paulo)
> - panel rework, unifiying code between lvds and edp panels (Jani)
> - panel fitter scaling modes (Jani + Yuly Novikov)
> - panel power improvements, should now work without the BIOS setting it up
> - extracting some dp helpers from radeon/i915 and move them to
>   drm_dp_helper.c
> - randome pile of workarounds (Damien, Ben, ...)
> - some cleanups for the register restore code for suspend/resume
> - secure batchbuffer support, should enable tear-free blits on gen6+
>   Chris)
> - random smaller fixlets and cleanups.
>
> Note that I've done a tiny bit of history rectifying on this -next pull
> (just to make a debug dmesg output correct), and applied a bugfix for a
> regression that Chris caught (introduced much earlier in this patch-pile).
>
> Cheers, Daniel

Hey, I don't see the drm HPD fixes.  Are you planning to put them in
another pull request?  It would be nice to get them upstream for 3.8

Alex
