Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab2HTD5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 23:57:38 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54493 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab2HTD5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 23:57:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [ 00/32] 3.4.10-stable review
Date: Sun, 19 Aug 2012 20:56:56 -0700
Message-Id: <20120820035647.862247088@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

This is the start of the stable review cycle for the 3.4.10 release.
There are 33 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Aug 22 03:56:46 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.10-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                                    |   4 +-
 arch/s390/kernel/compat_linux.c             |   2 -
 arch/s390/kernel/compat_wrapper.S           |   4 +-
 arch/x86/xen/p2m.c                          |  36 ++++
 drivers/dma/imx-dma.c                       |  36 ++--
 drivers/gpu/drm/i915/intel_display.c        |  11 --
 drivers/gpu/drm/i915/intel_dp.c             |  18 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c     |   7 +-
 drivers/gpu/drm/nouveau/nvd0_display.c      |   2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c      |  14 +-
 drivers/gpu/drm/radeon/evergreen.c          |  71 ++-----
 drivers/gpu/drm/radeon/ni.c                 |  14 +-
 drivers/gpu/drm/radeon/radeon_asic.h        |   8 +-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |   4 +
 drivers/gpu/drm/radeon/radeon_mode.h        |   1 +
 drivers/gpu/drm/radeon/rv515.c              |  13 --
 drivers/infiniband/ulp/srp/ib_srp.c         |  87 ++++++---
 drivers/net/wireless/rt2x00/rt2800usb.c     |   1 +
 drivers/tty/serial/pmac_zilog.c             |  12 +-
 drivers/usb/gadget/u_ether.c                |   6 +
 drivers/usb/host/pci-quirks.c               |   7 +
 drivers/usb/host/pci-quirks.h               |   1 +
 drivers/usb/host/xhci-pci.c                 |  10 +
 drivers/usb/host/xhci-ring.c                |  36 ++--
 drivers/usb/host/xhci.c                     |   8 +-
 drivers/usb/host/xhci.h                     |   1 +
 drivers/usb/serial/ftdi_sio.c               |   1 +
 drivers/usb/serial/ftdi_sio_ids.h           |   7 +
 drivers/usb/serial/mos7840.c                |   9 +-
 drivers/usb/serial/option.c                 | 281 +++++++++++-----------------
 fs/ext4/extents.c                           |   1 +
 fs/ext4/super.c                             |   6 +
 fs/fuse/file.c                              |   2 +-
 fs/jbd2/journal.c                           |   3 +-
 include/drm/drm_pciids.h                    |   3 +
 include/linux/jbd2.h                        |   1 +
 include/linux/usb.h                         |  21 +++
 37 files changed, 409 insertions(+), 340 deletions(-)


