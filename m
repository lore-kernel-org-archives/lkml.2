Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab1JWG2k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 02:28:40 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:50561 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753199Ab1JWG2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 02:28:39 -0400
X-Sasl-enc: z5ayq6/2XHBP2KqpnlePr+0aitm7OIJRqVftr/h5cuEu 1319351318
Date: Sun, 23 Oct 2011 08:28:33 +0200
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/27] 3.0.8-stable review
Message-ID: <20111023062833.GA8126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.8 release.
There are @num@ patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Tuesday, Oct 25 07:00:00 UTC 2011
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.8-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                              |    4 +-
 arch/arm/kernel/perf_event_v7.c       |    4 +-
 arch/arm/mm/init.c                    |    7 ++
 crypto/ghash-generic.c                |    6 +
 drivers/firewire/sbp2.c               |    4 +
 drivers/gpu/drm/radeon/atom.c         |   15 +++-
 drivers/gpu/drm/radeon/atom.h         |    1 +
 drivers/gpu/drm/ttm/ttm_bo.c          |   10 +-
 drivers/gpu/drm/ttm/ttm_bo_util.c     |    2 +-
 drivers/hid/hid-ids.h                 |    3 +
 drivers/hid/hid-magicmouse.c          |   10 ++-
 drivers/hid/usbhid/hid-quirks.c       |    1 +
 drivers/hwmon/w83627ehf.c             |   15 ++-
 drivers/media/video/uvc/uvc_entity.c  |    2 +-
 drivers/platform/x86/samsung-laptop.c |   10 ++
 fs/cifs/cifsfs.c                      |   10 +-
 fs/fuse/dev.c                         |   12 ++-
 fs/hfsplus/hfsplus_fs.h               |   16 +++-
 fs/hfsplus/part_tbl.c                 |   32 +++---
 fs/hfsplus/super.c                    |   12 +-
 fs/hfsplus/wrapper.c                  |   83 +++++++++++----
 fs/namei.c                            |   24 +++--
 fs/xfs/linux-2.6/xfs_linux.h          |    2 +
 fs/xfs/linux-2.6/xfs_super.c          |   48 +++------
 fs/xfs/quota/xfs_dquot_item.c         |   10 ++-
 fs/xfs/xfs_buf_item.c                 |    3 +-
 fs/xfs/xfs_inode_item.c               |   10 ++-
 fs/xfs/xfs_trans.c                    |   27 ++++-
 fs/xfs/xfs_trans.h                    |    2 +-
 fs/xfs/xfs_trans_ail.c                |  192 +++++++++++++++++++++++----------
 fs/xfs/xfs_trans_priv.h               |   18 ++--
 kernel/posix-cpu-timers.c             |    7 +-
 kernel/sys.c                          |    2 +-
 mm/migrate.c                          |    8 +-
 net/x25/af_x25.c                      |    3 +-
 sound/pci/hda/hda_intel.c             |    1 +
 sound/pci/hda/patch_conexant.c        |    1 +
 37 files changed, 421 insertions(+), 196 deletions(-)
