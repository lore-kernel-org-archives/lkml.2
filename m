Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab1FHKYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 06:24:39 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33813 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667Ab1FHKYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 06:24:38 -0400
Date: Wed, 8 Jun 2011 11:24:00 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm radeon urgent fixes
In-Reply-To: <alpine.DEB.2.00.1106081117370.5955@skynet.skynet.ie>
Message-ID: <alpine.DEB.2.00.1106081123090.5955@skynet.skynet.ie>
References: <alpine.DEB.2.00.1106081117370.5955@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Hi Linus,
> 
> I'm blaming 3.0 for me not seeing this breakage, I'm having trouble 
> persuading my USB disk to boot 3.0, on an F15 userspace looks like LVM or 
> something systemd related.
> 
> 1 is really urgent but the other two fixes some machines + blank screens.

correctly attributed patches and changelog below (lost Daniel's author 
line).
> 
> Dave.
> 
The following changes since commit cb0a02ecf95e5f47d92e7d4c513cc1f7aeb40cda:

  Merge branch 'irq-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2011-06-07 19:21:11 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-radeon-urgent

Alex Deucher (1):
      drm/radeon/kms: disable hdmi audio by default

Daniel Haid (1):
      drm/radeon/kms: fix for radeon on systems >4GB without hardware iommu

Dave Airlie (1):
      drm/radeon/kms: set family for use in parser.

 drivers/gpu/drm/radeon/radeon_cs.c     |    1 +
 drivers/gpu/drm/radeon/radeon_device.c |    1 +
 drivers/gpu/drm/radeon/radeon_drv.c    |    4 ++--
 3 files changed, 4 insertions(+), 2 deletions(-)
