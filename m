Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab2HTD4Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 23:56:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54493 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab2HTD4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 23:56:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [ 00/16] 3.0.42-stable review
Date: Sun, 19 Aug 2012 20:55:59 -0700
Message-Id: <20120820035457.653002510@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

This is the start of the stable review cycle for the 3.0.42 release.
There are 17 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Aug 22 03:54:56 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.42-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                                |   4 +-
 arch/s390/kernel/compat_linux.c         |   2 -
 arch/x86/xen/p2m.c                      |  36 ++++
 drivers/gpu/drm/i915/intel_ringbuffer.c |   7 +-
 drivers/gpu/drm/radeon/evergreen.c      |  57 -------
 drivers/gpu/drm/radeon/radeon_asic.h    |   8 +-
 drivers/gpu/drm/radeon/rv515.c          |  13 --
 drivers/infiniband/ulp/srp/ib_srp.c     |  87 +++++++---
 drivers/net/wireless/rt2x00/rt2800usb.c |   1 +
 drivers/usb/host/pci-quirks.c           |   7 +
 drivers/usb/host/pci-quirks.h           |   1 +
 drivers/usb/host/xhci-pci.c             |  10 ++
 drivers/usb/host/xhci.c                 |   8 +-
 drivers/usb/host/xhci.h                 |   1 +
 drivers/usb/serial/ftdi_sio.c           |   1 +
 drivers/usb/serial/ftdi_sio_ids.h       |   7 +
 drivers/usb/serial/mos7840.c            |   9 +-
 drivers/usb/serial/option.c             | 281 +++++++++++++-------------------
 fs/ext4/super.c                         |   1 +
 fs/fuse/file.c                          |   2 +-
 include/linux/usb.h                     |  21 +++
 21 files changed, 284 insertions(+), 280 deletions(-)


