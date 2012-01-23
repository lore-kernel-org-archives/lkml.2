Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab2AWXnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:43:40 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36397 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753688Ab2AWXn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:43:29 -0500
X-Sasl-enc: UwgeTsZ0oA4QMJBuJm/1PMlGo6wZG+34E6VstXYNArlz 1327362208
Date: Mon, 23 Jan 2012 15:42:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [00/27] 2.6.32.55-longterm review
Message-ID: <20120123234224.GA19510@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the longterm review cycle for the 2.6.32.@rel@ release.
There are 27 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Wednesday, January 25, 2012, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.55-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                            |    2 +-
 arch/score/kernel/entry.S           |    2 +-
 arch/x86/mm/mmap.c                  |    4 +-
 block/scsi_ioctl.c                  |    7 +++++
 drivers/block/cciss.c               |    6 ++--
 drivers/block/ub.c                  |    3 +-
 drivers/block/virtio_blk.c          |    4 +-
 drivers/cdrom/cdrom.c               |    3 +-
 drivers/hid/hid-core.c              |    2 +-
 drivers/i2c/busses/i2c-ali1535.c    |   11 +++++---
 drivers/i2c/busses/i2c-nforce2.c    |    2 +-
 drivers/i2c/busses/i2c-sis5595.c    |    4 +-
 drivers/i2c/busses/i2c-sis630.c     |    6 ++++-
 drivers/i2c/busses/i2c-viapro.c     |    7 ++++-
 drivers/ide/ide-floppy_ioctl.c      |    3 +-
 drivers/media/video/v4l2-ioctl.c    |    6 ++++
 drivers/mtd/ubi/cdev.c              |    3 ++
 drivers/mtd/ubi/wl.c                |    7 +++--
 drivers/pci/msi.c                   |   10 ++++++++
 drivers/pnp/quirks.c                |   42 +++++++++++++++++++++++++++++++++
 drivers/scsi/sd.c                   |    2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c |    4 +++
 drivers/usb/class/cdc-wdm.c         |    4 +-
 drivers/xen/xenbus/xenbus_xs.c      |    6 ++++
 fs/ext4/super.c                     |    7 ++---
 fs/nfsd/export.c                    |    2 +-
 fs/proc/uptime.c                    |    9 +++++-
 include/linux/blkdev.h              |    2 +
 include/linux/kernel.h              |   44 +++++++++++++++++++++++++++++++++++
 include/linux/pci_regs.h            |    2 +-
 include/linux/sunrpc/svcsock.h      |    2 +-
 include/linux/videodev2.h           |    1 +
 include/xen/interface/io/xs_wire.h  |    3 ++
 kernel/kprobes.c                    |    2 +-
 net/sunrpc/svc.c                    |   10 +++----
 net/sunrpc/svc_xprt.c               |   11 ++++++++-
 security/integrity/ima/ima_api.c    |    4 +-
 security/integrity/ima/ima_queue.c  |    1 +
 sound/pci/hda/hda_local.h           |    7 ++++-
 sound/pci/hda/hda_proc.c            |    2 +
 sound/pci/hda/patch_sigmatel.c      |    2 +-
 sound/pci/ice1712/amp.c             |    7 ++++-
 sound/usb/usx2y/usb_stream.c        |    6 +---
 43 files changed, 215 insertions(+), 59 deletions(-)
