Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab1LUVyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 16:54:50 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:39433 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539Ab1LUVyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 16:54:46 -0500
X-Sasl-enc: oGrkjC1ZdtxrJcfqOjeq8P/UVTORnzNaX0frS9Hctui3 1324504485
Date: Wed, 21 Dec 2011 13:53:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.1.6
Message-ID: <20111221215339.GA6487@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.1.6 kernel.

All users of the 3.1 kernel series must upgrade.

The updated 3.1.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.1.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                   |    2=20
 arch/arm/kernel/setup.c                    |   12 ++--
 arch/arm/mach-at91/at91rm9200_devices.c    |    2=20
 arch/arm/mach-at91/at91sam9260.c           |    6 +-
 arch/arm/mach-at91/at91sam9260_devices.c   |    2=20
 arch/arm/mach-at91/at91sam9261_devices.c   |    2=20
 arch/arm/mach-at91/at91sam9263_devices.c   |    2=20
 arch/arm/mach-davinci/board-da850-evm.c    |    2=20
 arch/arm/mach-davinci/board-dm646x-evm.c   |    6 +-
 arch/arm/mach-mxs/include/mach/mxs.h       |    1=20
 arch/x86/include/asm/system.h              |    1=20
 arch/x86/kernel/hpet.c                     |   21 +++++---
 arch/x86/kernel/process.c                  |    8 +++
 arch/x86/mm/gup.c                          |    2=20
 arch/x86/xen/setup.c                       |   20 ++++++--
 drivers/firmware/iscsi_ibft.c              |   42 ++++++++++++++++-
 drivers/firmware/iscsi_ibft_find.c         |   26 ----------
 drivers/gpu/drm/radeon/atombios_crtc.c     |   53 +++++++--------------
 drivers/gpu/drm/radeon/atombios_dp.c       |    9 ++-
 drivers/gpu/drm/radeon/radeon_connectors.c |   16 ++----
 drivers/gpu/drm/radeon/radeon_display.c    |    3 -
 drivers/gpu/drm/radeon/radeon_encoders.c   |   11 ++--
 drivers/gpu/drm/radeon/radeon_mode.h       |    4 -
 drivers/hwmon/jz4740-hwmon.c               |    2=20
 drivers/mmc/host/mxcmmc.c                  |    1=20
 drivers/ptp/ptp_clock.c                    |    4 +
 drivers/rtc/rtc-s3c.c                      |    2=20
 drivers/staging/rtl8712/usb_intf.c         |    1=20
 drivers/target/iscsi/iscsi_target.c        |   11 ++--
 drivers/target/iscsi/iscsi_target_core.h   |    1=20
 drivers/target/target_core_cdb.c           |    2=20
 drivers/target/target_core_file.c          |   12 ++--
 drivers/target/target_core_transport.c     |   21 +++++++-
 drivers/usb/class/cdc-acm.c                |   10 ++++
 drivers/usb/serial/option.c                |    7 ++
 fs/cifs/readdir.c                          |   10 +++-
 fs/dcache.c                                |   71 +++++++++++++++++-------=
-----
 fs/ext4/inode.c                            |   13 +++--
 fs/ext4/page-io.c                          |   12 ++++
 fs/ext4/super.c                            |   17 +++---
 fs/fuse/dev.c                              |    3 -
 fs/fuse/file.c                             |    2=20
 fs/hfs/btree.c                             |   20 ++++++--
 fs/jbd/journal.c                           |    8 +++
 fs/jbd2/journal.c                          |    8 +++
 fs/namespace.c                             |   20 ++++----
 fs/proc/meminfo.c                          |    7 +-
 fs/seq_file.c                              |    6 +-
 include/drm/drm_pciids.h                   |   10 ++++
 include/linux/dcache.h                     |    3 -
 include/linux/fs.h                         |    1=20
 include/linux/log2.h                       |    1=20
 kernel/lockdep.c                           |    8 ++-
 kernel/time/alarmtimer.c                   |    2=20
 mm/hugetlb.c                               |    1=20
 mm/page_alloc.c                            |   10 +++-
 mm/percpu-vm.c                             |   12 ++--
 mm/percpu.c                                |   34 ++++++++-----
 mm/vmalloc.c                               |    2=20
 security/apparmor/path.c                   |   65 +++++++++++++++---------=
--
 security/tomoyo/realpath.c                 |   13 ++++-
 sound/pci/hda/patch_realtek.c              |    2=20
 sound/pci/hda/patch_sigmatel.c             |   45 +++++++++---------
 sound/pci/sis7019.c                        |   64 +++++++++++++++++++++---=
--
 sound/soc/soc-utils.c                      |   31 ++++++++++++
 65 files changed, 548 insertions(+), 280 deletions(-)


Al Viro (1):
      fix apparmor dereferencing potentially freed dentry, sanitize __d_pat=
h() API

Alex Deucher (4):
      drm/radeon/kms: cleanup atombios_adjust_pll()
      drm/radeon/kms: rework DP bridge checks
      drm/radeon/kms: fix DP setup on TRAVIS bridges
      drm/radeon/kms: add some new pci ids

Alex Hermann (1):
      usb: option: Add Huawei E398 controlling interfaces

Anders Darander (1):
      ARM: at91: Fix USB AT91 gadget registration

Andrea Arcangeli (1):
      ext4: avoid hangs in ext4_da_should_update_i_disksize()

Arnaud Patard (1):
      ARM: 7204/1: arch/arm/kernel/setup.c: initialize arm_dma_zone_size ea=
rlier

Axel Lin (1):
      hwmon: (jz4740) fix signedness bug

Bj=C3=B8rn Mork (1):
      USB: option: Removing one bogus and adding some new Huawei combinatio=
ns

Claudio Scordino (1):
      fs/proc/meminfo.c: fix compilation error

David Dillow (1):
      ALSA: sis7019 - give slow codecs more time to reset

Eryu Guan (1):
      jbd/jbd2: validate sb->s_first in journal_get_superblock()

Greg Kroah-Hartman (1):
      Linux 3.1.6

Hans Verkuil (1):
      ARM: davinci: dm646x evm: wrong register used in setup_vpif_input_cha=
nnel_mode

Ian Campbell (1):
      xen: only limit memory map to maximum reservation for domain 0.

Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: fix clock conid for atmel_tcb.1 on 9260/9g20

Jeff Layton (1):
      cifs: check for NULL last_entry before calling cifs_save_resume_key

Jonghwan Choi (1):
      drivers/rtc/rtc-s3c.c: fix driver clock enable/disable balance issues

Konrad Rzeszutek Wilk (1):
      xen/pm_idle: Make pm_idle be default_idle under Xen.

Krzysztof Ha=C5=82asa (1):
      USB: cdc-acm: add IDs for Motorola H24 HSPA USB module.

Larry Finger (1):
      staging: r8712u: Add new USB ID

Linus Torvalds (1):
      linux/log2.h: Fix rounddown_pow_of_two(1)

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

Nicholas Bellinger (3):
      target: Reject SCSI data overflow for fabrics using transport_generic=
_map_mem_to_cmd
      iscsi-target: Fix residual count hanlding + remove iscsi_cmd->residua=
l_count
      iscsi-target: Add missing F_BIT for iscsi_tm_rsp

Phillip Lougher (1):
      hfs: fix hfs_find_init() sb->ext_tree NULL ptr oops

Roel Kluin (1):
      fuse: fix llseek bug

Roland Dreier (2):
      target: Handle 0 correctly in transport_get_sectors_6()
      target: Fix page length in emulated INQUIRY VPD page 86h

Sascha Hauer (1):
      mmc: mxcmmc: fix falling back to PIO

Sebastian Andrzej Siewior (1):
      target/file: walk properly over sg list

Takashi Iwai (2):
      ALSA: hda/realtek - Fix Oops in alc_mux_select()
      ALSA: hda - Fix GPIO LED setup for IDT 92HD75 codecs

Tejun Heo (1):
      percpu: fix chunk range calculation

Tetsuo Handa (1):
      TOMOYO: Fix pathname handling of disconnected paths.

Theodore Ts'o (2):
      ext4: fix ext4_end_io_dio() racing against fsync()
      ext4: display the correct mount option in /proc/mounts for [no]init_i=
table

Thomas Gleixner (2):
      alarmtimers: Fix time comparison
      ptp: Fix clock_getres() implementation

Wolfram Sang (1):
      arm: mx23: recognise stmp378x as mx23

Yinghai Lu (1):
      ibft: Fix finding IBFT ACPI table on UEFI

Yong Zhang (1):
      lockdep, kmemcheck: Annotate ->lock in lockdep_init_map()

Yongqiang Yang (2):
      ext4: avoid potential hang in mpage_submit_io() when blocksize < page=
size
      ext4: handle EOF correctly in ext4_bio_write_page()

Youquan Song (2):
      thp: add compound tail page _mapcount when mapped
      thp: set compound tail page _count to zero


--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJO8lVjAAoJEDjbvchgkmk+4aYQAIawp+WUbroJG2sEEgqIi+GC
fKMqRZTwWw51qb10bphtAcO33LK9Zz0oUqiwnfI/iUU6WTPqSfOBXbnb7pm+RViA
FdmU/IMpO0LoogT4E7Bz1IMtWwAQxQlG/xp5k/qs6SBvMGiACOeUk+Koew1Ng9MH
Wea0eoHXYJxZhst2VcDyJnpNnwsLnMqkFZmvxsDZgGIWe+VlFy3J/afYhMktkh7O
FJDvfLv4CFpls+bt6+tZH6x2SMYxFkXjN+9KK1NEmlFwlp12U3m4XiOnaeXWjhW0
A8XAIXDcZZt3Wj9pUZSCIbnn4O9hC72HRUG+zrMffWBCc6gUTxs3uUtrHmp5FSEd
3sJdaCNme1EwRJlBWlj8x7qe/bonBpzEA4w4/Hn05pJ4deYfQLVzqHmHRPS9/1i7
ewkPlWOsj/3CGy6ZWGjz9gfR8T/XjaaXU260/scVkn/a3MEAQYm5DXT4xzUiyf+t
q3scxNdUmCXGk2tXrGqUhXSUDrCrXo7x0teuAfJyzyi4KmmUZizGTsLpV4xkdP7r
KVF3cCzA2tVUptOu95K+vZxgJGddmXDlHkjoHJhxnlMYOFfMJAwTmj+FfcZ+fANV
fdPibE+TJWDxL3KyKVpTAuxN5Bp68bDXlOiH7MpMsKAVQAogC5GlFc++LlDwKN6f
mWoL6t5oMGQj2h2aDv5C
=Kwa0
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
