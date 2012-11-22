Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab2KVTsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:48:53 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:55376 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757332Ab2KVTsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:48:36 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFw3yqWRamfe3tn4Lh9G2BsuNd1RsST05=fc4jOoTLWsmw@mail.gmail.com>
References: <alpine.DEB.2.00.1211220431150.14614@skynet.skynet.ie>
	<CA+55aFw3yqWRamfe3tn4Lh9G2BsuNd1RsST05=fc4jOoTLWsmw@mail.gmail.com>
Date: Thu, 22 Nov 2012 20:57:25 +1000
Message-ID: <CAPM=9tyJmYup+wtzn4bxZ=P2imX9F_R6J94Xju=G7iEbFT4Lng@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 2:50 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Nov 21, 2012 at 6:34 PM, Dave Airlie <airlied@linux.ie> wrote:
>>
>> its vmware/nouveua/radeon/intel/ttm scattered.
>
> Hmm. That's not what I see. I just see nouveau and soem PCI ID addition.
>
>>  21 files changed, 108 insertions(+), 31 deletions(-)
>
> I get
>
>  14 files changed, 70 insertions(+), 21 deletions(-)
>
> probably due to this.
>
> Forgot to push? The tip of your tree that I see is 452f19201f35d
> ("Merge branch 'drm-fixes-3.7' of
> git://people.freedesktop.org/~agd5f/linux into drm-fixes")
>
> Or is it because you already sent me the intel fixes earlier?

Doh!, yes I picked wrong place to generate report from, okay here is
one corresponding to what you saw,

The following changes since commit 6f755116c93ca35f496ccf1910dcd28cd16713e3:

  Merge branch 'drm-intel-fixes' of
git://people.freedesktop.org/~danvet/drm-intel into drm-fixes
(2012-11-16 10:00:43 +1000)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

Alex Deucher (2):
      drm/radeon: properly track the crtc not_enabled case evergreen_mc_stop()
      drm/radeon: add new SI pci id

Dave Airlie (3):
      Merge branch 'drm-nouveau-fixes' of
git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes
      Merge branch 'drm-nouveau-fixes' of
git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes
      Merge branch 'drm-fixes-3.7' of
git://people.freedesktop.org/~agd5f/linux into drm-fixes

Kelly Doran (1):
      drm/nvc0/disp: fix thinko in vblank regression fix..

Maarten Lankhorst (2):
      drm/nouveau: add missing pll_calc calls
      drm/nouveau: use the correct fence implementation for nv50

Marcin Slusarz (3):
      drm/nv40: allocate ctxprog with kmalloc
      drm/nouveau: fix crash with noaccel=1
      drm/nouveau/bios: fix DCB v1.5 parsing

Paul Bolle (1):
      radeon: add AGPMode 1 quirk for RV250

 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c    |   19 ++++++++++++-------
 .../gpu/drm/nouveau/core/engine/graph/ctxnv40.c    |   12 +++++++++---
 drivers/gpu/drm/nouveau/core/engine/graph/nv40.c   |    4 +++-
 drivers/gpu/drm/nouveau/core/engine/graph/nv40.h   |    2 +-
 drivers/gpu/drm/nouveau/core/include/core/object.h |   14 +++++++++-----
 .../gpu/drm/nouveau/core/include/subdev/clock.h    |    3 ++-
 drivers/gpu/drm/nouveau/core/subdev/bios/dcb.c     |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/clock/nva3.c   |   19 +++++++++++++++++++
 drivers/gpu/drm/nouveau/core/subdev/clock/nvc0.c   |    1 +
 drivers/gpu/drm/nouveau/nouveau_abi16.c            |    4 ++++
 drivers/gpu/drm/nouveau/nouveau_drm.c              |    3 ++-
 drivers/gpu/drm/radeon/evergreen.c                 |    2 ++
 drivers/gpu/drm/radeon/radeon_agp.c                |    5 ++++-
 include/drm/drm_pciids.h                           |    1 +
 14 files changed, 70 insertions(+), 21 deletions(-)
