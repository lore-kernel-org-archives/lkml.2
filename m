Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab1KSAEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:04:25 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51277 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752860Ab1KSAEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:04:12 -0500
X-Sasl-enc: IYt3BLQpYVVf//hIEn2xFTSn99dwCFr9c5elMydtFZ/Q 1321661051
Date: Fri, 18 Nov 2011 16:03:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [00/26] 3.1.2-stable review
Message-ID: <20111119000336.GA8452@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.1.2 release.
There are 26 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Monday, November 21, 2011, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.1.2-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Documentation/sound/alsa/HD-Audio-Models.txt     |    1 +
 Makefile                                         |    4 +-
 arch/arm/mach-at91/at91cap9_devices.c            |    2 +-
 arch/arm/mach-at91/at91sam9g45_devices.c         |    2 +-
 arch/arm/mach-at91/at91sam9rl_devices.c          |    2 +-
 arch/powerpc/include/asm/sections.h              |    2 +-
 arch/powerpc/include/asm/synch.h                 |    1 +
 arch/powerpc/kernel/kvm.c                        |    1 -
 arch/powerpc/kernel/setup_32.c                   |    2 +
 arch/powerpc/kernel/setup_64.c                   |    1 +
 arch/powerpc/kvm/book3s_hv.c                     |    1 +
 arch/powerpc/lib/feature-fixups.c                |   23 ++++
 arch/powerpc/platforms/ps3/interrupt.c           |   23 ++++-
 arch/powerpc/platforms/ps3/platform.h            |    1 +
 arch/powerpc/platforms/ps3/smp.c                 |    2 +
 arch/sh/include/asm/page.h                       |    5 +
 arch/x86/xen/enlighten.c                         |    3 +-
 block/blk-map.c                                  |    7 +-
 drivers/gpu/drm/i915/i915_gem.c                  |    2 +-
 drivers/gpu/drm/nouveau/nouveau_channel.c        |    1 +
 drivers/gpu/drm/nouveau/nouveau_fence.c          |    2 -
 drivers/gpu/drm/radeon/atombios_dp.c             |    2 +-
 drivers/leds/led-class.c                         |    5 +-
 drivers/mfd/twl-core.c                           |    2 +-
 drivers/net/wireless/b43/main.c                  |    7 ++
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |    9 ++-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h |    6 +
 drivers/staging/brcm80211/brcmsmac/main.c        |    8 ++
 drivers/virtio/virtio_pci.c                      |   11 +-
 drivers/xen/gntalloc.c                           |    4 +-
 fs/hfs/trans.c                                   |    2 +
 include/drm/drm_pciids.h                         |    2 +
 mm/backing-dev.c                                 |    8 ++
 security/keys/user_defined.c                     |    3 +-
 sound/pci/hda/hda_codec.c                        |   60 +++++++----
 sound/pci/hda/patch_sigmatel.c                   |   11 ++
 sound/soc/codecs/wm8994.c                        |    2 +-
 sound/usb/mixer.c                                |  120 +++++++++++++---------
 38 files changed, 245 insertions(+), 105 deletions(-)
