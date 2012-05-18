Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968049Ab2ERV1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 17:27:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46755 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967811Ab2ERV1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 17:27:05 -0400
Date: Fri, 18 May 2012 14:27:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/47] 3.3.7-stable review
Message-ID: <20120518212701.GA5023@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.3.7 release.
There are 47 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun May 20 21:26:47 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.3.7-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Makefile                                      |    4 +-
 arch/arm/mm/fault.c                           |    4 +-
 arch/arm/vfp/vfpmodule.c                      |   10 ++--
 arch/sparc/kernel/central.c                   |    2 +-
 arch/sparc/mm/ultra.S                         |    6 +-
 arch/tile/kernel/compat_signal.c              |   12 ++--
 drivers/char/virtio_console.c                 |    7 +++
 drivers/crypto/Kconfig                        |    1 +
 drivers/i2c/busses/i2c-eg20t.c                |    2 +-
 drivers/md/dm-mpath.c                         |    4 +-
 drivers/md/md.c                               |    2 +
 drivers/media/dvb/dvb-core/dvb_frontend.c     |    4 ++
 drivers/media/rc/ene_ir.c                     |   32 +++++-----
 drivers/media/rc/fintek-cir.c                 |   20 +++----
 drivers/media/rc/ite-cir.c                    |   20 +++----
 drivers/media/rc/nuvoton-cir.c                |   36 ++++++------
 drivers/media/rc/winbond-cir.c                |   78 ++++++++++++-------------
 drivers/media/video/marvell-ccic/mmp-driver.c |    1 -
 drivers/media/video/s5p-fimc/fimc-capture.c   |    2 +-
 drivers/mtd/mtdchar.c                         |    2 +-
 drivers/net/ethernet/dlink/dl2k.c             |   52 +++--------------
 drivers/net/ethernet/dlink/dl2k.h             |    7 ---
 drivers/net/ethernet/intel/e1000/e1000_main.c |    6 +-
 drivers/net/usb/cdc_ether.c                   |   30 +++++++++-
 drivers/net/usb/usbnet.c                      |   54 ++++++++++++-----
 drivers/spi/spi-topcliff-pch.c                |   78 +++++++++++++++++++++----
 drivers/target/target_core_file.c             |   22 +++++--
 drivers/target/target_core_pr.c               |    3 +
 drivers/target/target_core_tpg.c              |   22 -------
 drivers/video/omap2/dss/venc.c                |    5 ++
 fs/cifs/cifsfs.c                              |    2 +-
 fs/ext4/xattr.c                               |    7 ++-
 fs/jffs2/gc.c                                 |    2 +-
 fs/nfs/nfs4proc.c                             |   28 ++++-----
 fs/nfs/nfs4xdr.c                              |   18 +++---
 include/linux/usb/usbnet.h                    |    3 +-
 init/do_mounts.c                              |    2 +-
 kernel/compat.c                               |   63 ++++++++++++++------
 kernel/fork.c                                 |    3 +
 mm/hugetlb.c                                  |    1 -
 mm/memcontrol.c                               |    6 ++
 mm/nobootmem.c                                |    3 +-
 mm/percpu.c                                   |   12 ++++
 net/ipv4/tcp.c                                |    3 +-
 sound/pci/echoaudio/echoaudio_dsp.c           |    2 +-
 sound/pci/hda/hda_intel.c                     |    6 +-
 sound/pci/hda/patch_realtek.c                 |    1 +
 sound/pci/hda/patch_sigmatel.c                |    6 +-
 sound/soc/codecs/cs42l73.c                    |   16 ++---
 sound/soc/codecs/wm8994.c                     |    2 +-
 50 files changed, 424 insertions(+), 290 deletions(-)

