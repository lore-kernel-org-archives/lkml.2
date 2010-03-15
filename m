Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936763Ab0COU6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 16:58:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:54747 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932260Ab0COU6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 16:58:15 -0400
X-Authenticated: #5115406
X-Provags-ID: V01U2FsdGVkX1+pTAs2YrSp6GgGCWZ7cdhN6erVnobpiExR4uy2BC
	WUUuLP0PzmquDU
From: Thomas Weber <swirl@gmx.li>
To: linux-kernel@vger.kernel.org
Cc: Thomas Weber <swirl@gmx.li>
Subject: [PATCH 0/4] Some typo fixing
Date: Mon, 15 Mar 2010 21:58:54 +0100
Message-Id: <1268686738-28293-1-git-send-email-swirl@gmx.li>
X-Mailer: git-send-email 1.6.4.4
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have fixed some typos.

Thomas Weber (4):
  Fix typo: [Ss]ytem => [Ss]ystem
  Fix typo: udpate => update
  Fix typo: paramters => parameters
  Fix typo: orginal => original

 Documentation/cgroups/cgroups.txt               |    2 +-
 Documentation/kbuild/kconfig.txt                |    2 +-
 Documentation/sysfs-rules.txt                   |    2 +-
 Documentation/trace/events.txt                  |    8 ++++----
 drivers/acpi/osl.c                              |    4 ++--
 drivers/ata/ata_piix.c                          |    2 +-
 drivers/firewire/ohci.c                         |    2 +-
 drivers/gpu/drm/drm_bufs.c                      |    2 +-
 drivers/infiniband/hw/ipath/ipath_iba6110.c     |    2 +-
 drivers/infiniband/hw/ipath/ipath_iba6120.c     |    4 ++--
 drivers/infiniband/hw/ipath/ipath_iba7220.c     |    2 +-
 drivers/isdn/hisax/hfc4s8s_l1.c                 |    2 +-
 drivers/macintosh/windfarm_pm81.c               |    2 +-
 drivers/media/dvb/dvb-usb/friio-fe.c            |    2 +-
 drivers/net/smsc911x.c                          |    4 ++--
 drivers/pci/hotplug/cpqphp_core.c               |    2 +-
 drivers/pci/pci.c                               |    2 +-
 drivers/ps3/ps3-sys-manager.c                   |    2 +-
 drivers/regulator/core.c                        |    2 +-
 drivers/s390/char/sclp_cpi_sys.c                |    2 +-
 drivers/scsi/bfa/include/defs/bfa_defs_cee.h    |    2 +-
 drivers/scsi/bfa/include/defs/bfa_defs_status.h |    4 ++--
 drivers/spi/spi_mpc8xxx.c                       |    2 +-
 drivers/staging/iio/Documentation/overview.txt  |    2 +-
 drivers/staging/rt2860/rtmp.h                   |    2 +-
 drivers/staging/rtl8187se/r8180_core.c          |    4 ++--
 drivers/staging/rtl8187se/r8180_dm.c            |    2 +-
 drivers/staging/rtl8187se/r8185b_init.c         |    2 +-
 drivers/virtio/virtio_pci.c                     |    2 +-
 fs/jfs/jfs_dmap.c                               |    2 +-
 kernel/cgroup.c                                 |    2 +-
 mm/page_alloc.c                                 |    2 +-
 net/wimax/op-rfkill.c                           |    2 +-
 sound/pci/emu10k1/emu10k1_main.c                |    2 +-
 34 files changed, 42 insertions(+), 42 deletions(-)

