Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab1LUVzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 16:55:01 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:44771 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753655Ab1LUVyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 16:54:50 -0500
X-Sasl-enc: Ru2lAinxU+HN9UO8gVzVW2pePFZ5JqBz0zCyVj4TLoM2 1324504488
Date: Wed, 21 Dec 2011 13:54:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.14
Message-ID: <20111221215425.GA22653@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.14 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                    |    2=20
 arch/arm/mach-at91/at91sam9260.c            |    6 +-
 arch/arm/mach-davinci/board-da850-evm.c     |    2=20
 arch/arm/mach-davinci/board-dm646x-evm.c    |    6 +-
 arch/arm/mach-mxs/include/mach/mxs.h        |    1=20
 arch/x86/kernel/hpet.c                      |   21 +++++---
 arch/x86/mm/gup.c                           |    2=20
 arch/x86/xen/setup.c                        |   18 +++++--
 drivers/firmware/iscsi_ibft.c               |   42 +++++++++++++++-
 drivers/firmware/iscsi_ibft_find.c          |   26 ----------
 drivers/hwmon/coretemp.c                    |    2=20
 drivers/hwmon/jz4740-hwmon.c                |    2=20
 drivers/md/raid5.c                          |    2=20
 drivers/mmc/host/mxcmmc.c                   |    1=20
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |   36 +++++++++-----
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   18 +------
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    2=20
 drivers/pci/intel-iommu.c                   |   40 +++++++++------
 drivers/ptp/ptp_clock.c                     |    4 +
 drivers/staging/rtl8712/usb_intf.c          |    1=20
 drivers/target/target_core_transport.c      |    9 ++-
 drivers/usb/class/cdc-acm.c                 |   10 +++
 drivers/usb/serial/option.c                 |    7 ++
 fs/dcache.c                                 |   71 +++++++++++++++++------=
-----
 fs/ext4/inode.c                             |    9 ++-
 fs/ext4/page-io.c                           |   12 ++++
 fs/ext4/super.c                             |   17 +++---
 fs/fuse/dev.c                               |    3 -
 fs/hfs/btree.c                              |   20 +++++--
 fs/jbd/journal.c                            |    8 +++
 fs/jbd2/journal.c                           |    8 +++
 fs/namespace.c                              |   20 ++++---
 fs/proc/meminfo.c                           |    7 +-
 fs/seq_file.c                               |    6 +-
 fs/xfs/linux-2.6/xfs_export.c               |    8 +--
 fs/xfs/xfs_attr.c                           |   14 +----
 fs/xfs/xfs_bmap.c                           |   10 ---
 fs/xfs/xfs_inode.c                          |    8 ---
 include/drm/drm_pciids.h                    |   10 +++
 include/linux/dcache.h                      |    3 -
 include/linux/fs.h                          |    1=20
 include/linux/log2.h                        |    1=20
 kernel/taskstats.c                          |    1=20
 kernel/time/alarmtimer.c                    |    2=20
 mm/hugetlb.c                                |    1=20
 mm/page_alloc.c                             |   10 +++
 mm/percpu-vm.c                              |   12 ++--
 mm/percpu.c                                 |   34 +++++++------
 mm/vmalloc.c                                |    2=20
 net/mac80211/agg-tx.c                       |   17 ++++++
 security/apparmor/path.c                    |   65 ++++++++++++++---------=
--
 security/tomoyo/realpath.c                  |    9 ++-
 sound/pci/hda/patch_realtek.c               |    2=20
 sound/pci/sis7019.c                         |   64 ++++++++++++++++++++---=
--
 sound/soc/soc-core.c                        |   19 +++----
 sound/soc/soc-utils.c                       |   31 +++++++++++-
 56 files changed, 501 insertions(+), 264 deletions(-)

Al Viro (1):
      fix apparmor dereferencing potentially freed dentry, sanitize __d_pat=
h() API

Alex Deucher (1):
      drm/radeon/kms: add some new pci ids

Alex Hermann (1):
      usb: option: Add Huawei E398 controlling interfaces

Allen Kay (3):
      intel-iommu: fix return value of iommu_unmap() API
      intel-iommu: set iommu_superpage on VM domains to lowest common denom=
inator
      intel-iommu: fix superpage support in pfn_to_dma_pte()

Andrea Arcangeli (1):
      ext4: avoid hangs in ext4_da_should_update_i_disksize()

Axel Lin (1):
      hwmon: (jz4740) fix signedness bug

Bj=C3=B8rn Mork (1):
      USB: option: Removing one bogus and adding some new Huawei combinatio=
ns

Christoph Hellwig (2):
      xfs: fix nfs export of 64-bit inodes numbers on 32-bit kernels
      xfs: avoid synchronous transactions when deleting attr blocks

Claudio Scordino (1):
      fs/proc/meminfo.c: fix compilation error

David Dillow (1):
      ALSA: sis7019 - give slow codecs more time to reset

Eryu Guan (1):
      jbd/jbd2: validate sb->s_first in journal_get_superblock()

Greg Kroah-Hartman (1):
      Linux 3.0.14

Hans Verkuil (1):
      ARM: davinci: dm646x evm: wrong register used in setup_vpif_input_cha=
nnel_mode

Ian Campbell (1):
      xen: only limit memory map to maximum reservation for domain 0.

Jean Delvare (1):
      hwmon: (coretemp) Fix oops on CPU offlining

Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: fix clock conid for atmel_tcb.1 on 9260/9g20

Krzysztof Ha=C5=82asa (1):
      USB: cdc-acm: add IDs for Motorola H24 HSPA USB module.

Larry Finger (1):
      staging: r8712u: Add new USB ID

Linus Torvalds (2):
      linux/log2.h: Fix rounddown_pow_of_two(1)
      Make TASKSTATS require root access

Manjunathappa, Prakash (1):
      ARM: davinci: da850 evm: change audio edma event queue to EVENTQ_0

Mark Brown (1):
      ASoC: Provide a more complete DMA driver stub

Mark Langsdorf (1):
      x86, hpet: Immediately disable HPET timer 1 if rtc irq is masked

Mel Gorman (1):
      mm: vmalloc: check for page allocation failure before vmlist insertion

Michal Hocko (1):
      mm: Ensure that pfn_valid() is called once per pageblock when reservi=
ng pageblocks

Miklos Szeredi (1):
      fuse: fix fuse_retrieve

NeilBrown (1):
      md/raid5: fix bug that could result in reads from a failed device.

Nikolay Martynov (1):
      mac80211: fix race condition caused by late addBA response

Phillip Lougher (1):
      hfs: fix hfs_find_init() sb->ext_tree NULL ptr oops

Roland Dreier (1):
      target: Handle 0 correctly in transport_get_sectors_6()

Sascha Hauer (1):
      mmc: mxcmmc: fix falling back to PIO

Stephen Warren (1):
      ASoC: core: Don't schedule deferred_resume_work twice

Takashi Iwai (1):
      ALSA: hda/realtek - Fix Oops in alc_mux_select()

Tejun Heo (1):
      percpu: fix chunk range calculation

Theodore Ts'o (1):
      ext4: display the correct mount option in /proc/mounts for [no]init_i=
table

Thomas Gleixner (2):
      alarmtimers: Fix time comparison
      ptp: Fix clock_getres() implementation

Wey-Yi Guy (1):
      iwlwifi: do not re-configure HT40 after associated

Wolfram Sang (1):
      arm: mx23: recognise stmp378x as mx23

Yinghai Lu (1):
      ibft: Fix finding IBFT ACPI table on UEFI

Yongqiang Yang (2):
      ext4: avoid potential hang in mpage_submit_io() when blocksize < page=
size
      ext4: handle EOF correctly in ext4_bio_write_page()

Youquan Song (2):
      thp: add compound tail page _mapcount when mapped
      thp: set compound tail page _count to zero


--DocE+STaALJfprDB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJO8lWRAAoJEDjbvchgkmk+swsQAI78b8ml1Je4izux55M1R2Oy
mkB4gg7fYwqTWL8ou9wRJg2sXkFrGxdtPvSAmfgmyWfODPXZCJGky1AYPBUSY1Il
h01lZouwAGXpcwIDSPjieFEuBAvNmYmABwohU+C8GPeFvHwq9H/YlOtjye9fYMmd
A0DYbISfs0yOZiZTK8xMu8bbdlTo7LBQl5yrd0Rn+6SY3EJhfiY5ky9Ul61V4l+x
rWt4kZ5DPFtSC0GnVjV71q9nhjw/rT7zYu2/BMTgJT2txDuwiGdS3tUUh4KUjKrC
nnEy40gqbhS1mz0e1S60CstBG3pAUGym2Dq2MrV48CmN13taSZsC/xbUa/9YWQ1x
A/FayGYvx8L7xDasqp3Mfk46zC/ILVb7bOZmHvqdiR/vq0/rclaMZXwJYa/GWFa8
GRLhBzK6eisLeUPIBxzkj8+f8ocrcBrMy3QrI+we6WC0xSdTqiG2gceKtLWkuJpd
SX20Wz7ZzttM1JwXFfiNeub3FHh4ZuNeVts68XOJl5mONrTFJQHl21jZywssHg3j
5lHJWrzJtH+o9kKPTD+1LhqWNiUtwCOOEBKjKLU0wmu4mo1xuX3rqiY7rXsKeVCE
cceQ9wFgCpeJyrSHpPURskfr7W8U5zA2QHRfLWngRRv56iD5IZ15AIUu3T6B6mTT
UkQ+uly9Snu3qh4n7Qgs
=3BUP
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
