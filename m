Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab0GLUuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:50:32 -0400
Received: from mail.perches.com ([173.55.12.10]:1712 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab0GLUua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:50:30 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/36] Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:49:52 -0700
Message-Id: <cover.1278967120.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

private_data is a void *, so remove the unnecessary casts

Joe Perches (36):
  arch/cris: Remove unnecessary casts of private_data
  arch/ia64: Remove unnecessary casts of private_data
  arch/powerpc: Remove unnecessary casts of private_data
  arch/s390: Remove unnecessary casts of private_data
  drivers/bluetooth: Remove unnecessary casts of private_data
  drivers/char: Remove unnecessary casts of private_data
  drivers/gpu: Remove unnecessary casts of private_data
  drivers/ieee1394: Remove unnecessary casts of private_data
  drivers/infiniband: Remove unnecessary casts of private_data
  drivers/isdn: Remove unnecessary casts of private_data
  drivers/media: Remove unnecessary casts of private_data
  drivers/misc: Remove unnecessary casts of private_data
  drivers/net/caif: Remove unnecessary casts of private_data
  drivers/net/wireless: Remove unnecessary casts of private_data
  drivers/s390: Remove unnecessary casts of private_data
  drivers/sbus: Remove unnecessary casts of private_data
  drivers/scsi: Remove unnecessary casts of private_data
  drivers/staging: Remove unnecessary casts of private_data
  drivers/usb/gadget: Remove unnecessary casts of private_data
  drivers/usb/misc: Remove unnecessary casts of private_data
  drivers/usb: Remove unnecessary casts of private_data
  fs/cifs: Remove unnecessary casts of private_data
  fs/coda: Remove unnecessary casts of private_data
  fs/ecryptfs: Remove unnecessary casts of private_data
  fs/ext3: Remove unnecessary casts of private_data
  fs/ext4: Remove unnecessary casts of private_data
  fs/ocfs2: Remove unnecessary casts of private_data
  fs: Remove unnecessary casts of private_data
  kernel/trace: Remove unnecessary casts of private_data
  kernel: Remove unnecessary casts of private_data
  net/core: Remove unnecessary casts of private_data
  net/irda: Remove unnecessary casts of private_data
  net/sunrpc: Remove unnecessary casts of private_data
  sound/soc/blackfin: Remove unnecessary casts of private_data
  sound/soc/davinci: Remove unnecessary casts of private_data
  sound/core: Remove unnecessary casts of private_data

 arch/cris/arch-v32/drivers/mach-fs/gpio.c     |   10 +++++-----
 arch/ia64/kernel/perfmon.c                    |   12 ++++++------
 arch/powerpc/kvm/timing.c                     |    2 +-
 arch/s390/kernel/debug.c                      |    6 +++---
 drivers/bluetooth/btmrvl_debugfs.c            |    2 +-
 drivers/char/snsc.c                           |    8 ++++----
 drivers/gpu/drm/radeon/radeon_ttm.c           |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c          |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c      |    2 +-
 drivers/ieee1394/dv1394.c                     |    4 ++--
 drivers/ieee1394/raw1394.c                    |    4 ++--
 drivers/ieee1394/video1394.c                  |    6 +++---
 drivers/infiniband/hw/ipath/ipath_file_ops.c  |    2 +-
 drivers/isdn/capi/capi.c                      |    6 +++---
 drivers/isdn/hysdn/hysdn_proclog.c            |    2 +-
 drivers/isdn/i4l/isdn_ppp.c                   |    2 +-
 drivers/media/IR/imon.c                       |    6 +++---
 drivers/media/common/saa7146_vbi.c            |    4 ++--
 drivers/media/common/saa7146_video.c          |    4 ++--
 drivers/media/dvb/bt8xx/dst_ca.c              |    2 +-
 drivers/media/video/cx18/cx18-ioctl.c         |    2 +-
 drivers/media/video/cx88/cx88-alsa.c          |    2 +-
 drivers/media/video/hdpvr/hdpvr-video.c       |    4 ++--
 drivers/media/video/mem2mem_testdev.c         |    4 ++--
 drivers/media/video/saa7134/saa7134-alsa.c    |    2 +-
 drivers/media/video/uvc/uvc_v4l2.c            |    8 ++++----
 drivers/misc/ibmasm/ibmasmfs.c                |    4 ++--
 drivers/net/caif/caif_spi.c                   |    4 ++--
 drivers/net/wireless/airo.c                   |   22 +++++++++++-----------
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    9 +++------
 drivers/net/wireless/iwlwifi/iwl-debugfs.c    |   10 +++++-----
 drivers/net/wireless/libertas/debugfs.c       |    4 ++--
 drivers/s390/block/dasd_eer.c                 |    6 +++---
 drivers/s390/char/tape_block.c                |    4 ++--
 drivers/s390/char/tape_char.c                 |    8 ++++----
 drivers/s390/char/vmcp.c                      |    6 +++---
 drivers/sbus/char/openprom.c                  |    4 ++--
 drivers/scsi/aacraid/linit.c                  |    2 +-
 drivers/scsi/pmcraid.c                        |    7 +++----
 drivers/scsi/sg.c                             |   18 +++++++++---------
 drivers/staging/batman-adv/bat_debugfs.c      |    4 ++--
 drivers/staging/batman-adv/icmp_socket.c      |   12 ++++--------
 drivers/staging/cx25821/cx25821-alsa.c        |    2 +-
 drivers/staging/easycap/easycap_ioctl.c       |    4 ++--
 drivers/staging/easycap/easycap_main.c        |    4 ++--
 drivers/staging/easycap/easycap_sound.c       |    2 +-
 drivers/usb/gadget/f_hid.c                    |    6 +++---
 drivers/usb/misc/ftdi-elan.c                  |    4 ++--
 drivers/usb/misc/iowarrior.c                  |    8 ++++----
 drivers/usb/misc/legousbtower.c               |    6 +++---
 drivers/usb/misc/sisusbvga/sisusb.c           |   10 +++++-----
 drivers/usb/misc/usblcd.c                     |    8 ++++----
 drivers/usb/usb-skeleton.c                    |    8 ++++----
 fs/cifs/file.c                                |   24 ++++++++++--------------
 fs/cifs/inode.c                               |    4 ++--
 fs/cifs/ioctl.c                               |    3 +--
 fs/coda/psdev.c                               |    8 ++++----
 fs/ecryptfs/ecryptfs_kernel.h                 |    2 +-
 fs/ext3/dir.c                                 |    2 +-
 fs/ext4/dir.c                                 |    2 +-
 fs/ext4/mballoc.c                             |    2 +-
 fs/ocfs2/dlm/dlmdebug.c                       |    6 +++---
 fs/ocfs2/dlmfs/dlmfs.c                        |    3 +--
 fs/ocfs2/dlmglue.c                            |    4 ++--
 fs/seq_file.c                                 |    6 +++---
 kernel/pm_qos_params.c                        |    2 +-
 kernel/trace/ftrace.c                         |    4 ++--
 kernel/trace/trace.c                          |    2 +-
 net/core/pktgen.c                             |    4 ++--
 net/irda/irnet/irnet_ppp.c                    |   10 +++++-----
 net/sunrpc/rpc_pipe.c                         |    4 ++--
 sound/core/oss/mixer_oss.c                    |   22 +++++++++++-----------
 sound/core/pcm.c                              |    3 +--
 sound/core/timer.c                            |    4 ++--
 sound/soc/blackfin/bf5xx-ac97.c               |    6 ++----
 sound/soc/blackfin/bf5xx-tdm.c                |    6 ++----
 sound/soc/davinci/davinci-pcm.c               |    2 +-
 77 files changed, 206 insertions(+), 225 deletions(-)

