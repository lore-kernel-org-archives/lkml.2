Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab0F3KOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 06:14:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35471 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755329Ab0F3KOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 06:14:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Airlie <airlied@linux.ie>
Subject: Re: [git pull] drm fixes + agp + one fb patch
Date: Wed, 30 Jun 2010 12:13:01 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
References: <alpine.DEB.2.00.1006300202190.30052@skynet.skynet.ie>
In-Reply-To: <alpine.DEB.2.00.1006300202190.30052@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006301213.01962.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 30, 2010, Dave Airlie wrote:
> 
> Hi Linus,
> 
> one fb layer fix in a flag I introduced,
> 
> the rest are drm fixes:
> radeon fixes: the larger ones in the command stream checker for older cards,
> which was causing a lot of userspace apps to fail. Also some powerpc server fixes.
> along with some updates to the evergreen command stream checker introduced in -rc1.
> 
> agp: fix issue with warning on memory allocation + fallback to vmalloc.
> ttm: fix regression introduced in -rc1 in memory allocation paths.
> 
> The following changes since commit 7e27d6e778cd87b6f2415515d7127eba53fe5d02:
> 
>   Linux 2.6.35-rc3 (2010-06-11 19:14:04 -0700)
> 
> are available in the git repository at:
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes
> 
> Adam Jackson (1):
>       drm/fb: Fix video= mode computation
> 
> Alex Deucher (7):
>       drm/radeon/kms: fix bandwidth calculation when sideport is present
>       drm/radeon/kms: fix DP after DPMS cycle
>       drm/radeon/kms: fix typo in evergreen_gpu_init
>       drm/radeon/kms: disable frac fb dividers for rs6xx
>       drm/radeon/kms: avoid oops on mac r4xx cards
>       drm/radeon/kms: fix typos in evergreen command checker
>       drm/radeon/kms: add some missing regs to evergreen gpu init
> 
> Cedric Godin (1):
>       drm/radeon/kms: fix dpms state on resume
> 
> Dave Airlie (7):
>       drm/radeon: fix dual-head on rv250
>       radeon/kms: fix powerpc/rn50 untiled behaviour.
>       agp: drop vmalloc flag.
>       agp: add no warn since we have a fallback to vmalloc paths
>       drm/radeon: add fake RN50 table for powerpc
>       drm/radeon/kms: don't read attempt to read bios from VRAM on unposted GPU.
>       fb: fix colliding defines for fb flags.
> 
> Jerome Glisse (2):
>       drm/ttm: non pooled page allocation should have GFP_USER set
>       drm/radeon/kms: Force HDP_NONSURF to maximum size
> 
> Matt Turner (1):
>       drm/radeon/kms: return ret in cursor_set failure path
> 
> Roland Scheidegger (3):
>       drm/radeon/kms: CS checker texture fixes for r1xx/r2xx/r3xx
>       drm/radeon/r200: handle more hw tex coord types
>       drm/radeon/r100/r200: fix calculation of compressed cube maps

Hmm.  What about:

https://patchwork.kernel.org/patch/106757/ ?

It fixes a regression from 2.6.34.

Rafael
