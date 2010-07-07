Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750996Ab0GGEYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 00:24:22 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60646 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741Ab0GGEYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 00:24:21 -0400
Date: Wed, 7 Jul 2010 05:24:04 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm fixes
In-Reply-To: <alpine.DEB.2.00.1007070421460.22955@skynet.skynet.ie>
Message-ID: <alpine.DEB.2.00.1007070523370.25777@skynet.skynet.ie>
References: <alpine.DEB.2.00.1007070421460.22955@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ignore this one, picked up a problem in the ioports patch, so its gone.

new pull req sent.

Dave.

> 
> The following changes since commit 123f94f22e3d283dfe68742b269c245b0501ad82:
> 
>   Merge branch 'sched-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2010-07-02 09:52:58 -0700)
> 
> are available in the git repository at:
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes
> 
> Alex Deucher (2):
>       drm/radeon/kms: add ioport register access
>       drm/radeon/kms: fix shared ddc handling
> 
> Francisco Jerez (1):
>       drm/ttm: Allocate the page pool manager in the heap.
> 
> Jesse Barnes (1):
>       drm: correctly update connector DPMS status in drm_fb_helper
> 
>  drivers/gpu/drm/drm_fb_helper.c            |   23 ++++++++-
>  drivers/gpu/drm/radeon/atom.c              |    5 +-
>  drivers/gpu/drm/radeon/atom.h              |    2 +
>  drivers/gpu/drm/radeon/radeon.h            |   25 ++++++++++
>  drivers/gpu/drm/radeon/radeon_connectors.c |    4 +-
>  drivers/gpu/drm/radeon/radeon_device.c     |   34 ++++++++++++++
>  drivers/gpu/drm/ttm/ttm_page_alloc.c       |   68 +++++++++++++--------------
>  include/drm/ttm/ttm_page_alloc.h           |    4 --
>  8 files changed, 119 insertions(+), 46 deletions(-)
> 
