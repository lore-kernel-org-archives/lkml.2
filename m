Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab1KSAEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:04:13 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41895 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751636Ab1KSAEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:04:11 -0500
X-Sasl-enc: Owjnw0EOlWGXAJhugFpmlzFGd2+7p10CaQ2ztybC8ujh 1321661049
Date: Fri, 18 Nov 2011 16:00:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [00/26] 3.0.10-stable review
Message-ID: <20111119000026.GA6679@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.10 release.
There are 26 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Monday, November 21, 2011, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.10-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                                  |    4 +-
 arch/powerpc/include/asm/sections.h       |    2 +-
 arch/powerpc/include/asm/synch.h          |    1 +
 arch/powerpc/kernel/kvm.c                 |    1 -
 arch/powerpc/kernel/setup_32.c            |    2 +
 arch/powerpc/kernel/setup_64.c            |    1 +
 arch/powerpc/lib/feature-fixups.c         |   23 ++++++
 arch/powerpc/platforms/ps3/interrupt.c    |   23 +++++-
 arch/powerpc/platforms/ps3/platform.h     |    1 +
 arch/powerpc/platforms/ps3/smp.c          |    2 +
 arch/sh/include/asm/page.h                |    5 +
 arch/x86/platform/mrst/mrst.c             |   24 ++++---
 arch/x86/xen/enlighten.c                  |    3 +-
 block/blk-map.c                           |    7 +-
 drivers/gpu/drm/i915/i915_debugfs.c       |    2 +-
 drivers/gpu/drm/i915/i915_gem.c           |    2 +-
 drivers/gpu/drm/i915/intel_display.c      |    4 +-
 drivers/gpu/drm/nouveau/nouveau_channel.c |    1 +
 drivers/gpu/drm/nouveau/nouveau_fence.c   |    2 -
 drivers/gpu/drm/radeon/atombios_dp.c      |    2 +-
 drivers/leds/led-class.c                  |    5 +-
 drivers/md/raid5.c                        |   32 +++++---
 drivers/mfd/twl-core.c                    |    2 +-
 drivers/net/wireless/b43/main.c           |    7 ++
 drivers/virtio/virtio_pci.c               |   11 ++-
 drivers/xen/gntalloc.c                    |    4 +-
 fs/hfs/trans.c                            |    2 +
 include/drm/drm_pciids.h                  |    2 +
 mm/backing-dev.c                          |    8 ++
 security/keys/user_defined.c              |    3 +-
 sound/pci/hda/hda_codec.c                 |   60 +++++++++-----
 sound/soc/codecs/wm8994.c                 |    2 +-
 sound/usb/mixer.c                         |  120 +++++++++++++++++------------
 33 files changed, 245 insertions(+), 125 deletions(-)
