Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab1HZWF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 18:05:26 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58636 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751244Ab1HZWFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 18:05:24 -0400
X-Sasl-enc: 5BRhIfHqW3Ut/bjTTH2XjXyurnXdO1N9nQP4yQZJ+7Um 1314396323
Date: Fri, 26 Aug 2011 15:04:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/20] 2.6.33.19-longterm review
Message-ID: <20110826220431.GA15382@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.33.19 release.
There are 20 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Monday, August 29, 2011, 12:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.33.19-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                                   |    2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c         |    1 -
 arch/x86/vdso/vdso32/sysenter.S            |    2 +-
 drivers/gpu/drm/ttm/ttm_bo.c               |    4 ++-
 drivers/hwmon/ibmaem.c                     |   15 +++++---
 drivers/net/igb/e1000_82575.c              |    1 +
 drivers/staging/rtl8192u/r819xU_firmware.c |    9 ++---
 drivers/usb/class/usbtmc.c                 |    2 +-
 drivers/usb/host/pci-quirks.c              |    2 +-
 drivers/usb/serial/qcserial.c              |    1 +
 drivers/usb/storage/unusual_devs.h         |   10 +++++
 fs/befs/linuxvfs.c                         |   23 +++++++-----
 fs/fuse/dev.c                              |    4 ++
 fs/partitions/efi.c                        |    9 +++++
 kernel/futex.c                             |   54 +++++++++++++++++++++------
 mm/vmalloc.c                               |    7 ++--
 net/atm/br2684.c                           |    2 -
 sound/pci/ac97/ac97_patch.c                |    1 +
 sound/usb/caiaq/audio.c                    |   37 ++++++++++++++++---
 sound/usb/caiaq/device.h                   |    1 +
 tools/perf/util/config.c                   |    7 ----
 21 files changed, 138 insertions(+), 56 deletions(-)
