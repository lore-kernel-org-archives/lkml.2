Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381Ab2JURXM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 13:23:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37953 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322Ab2JURXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 13:23:08 -0400
Date: Sun, 21 Oct 2012 10:23:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.6.3
Message-ID: <20121021172330.GA5249@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.6.3 kernel.

All users of the 3.6 kernel series must upgrade.

The updated 3.6.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.6.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                        |    2=20
 arch/arm/Kconfig                                |   10 +
 arch/arm/include/asm/vfpmacros.h                |    4=20
 arch/arm/mm/cache-v7.S                          |    3=20
 arch/arm/plat-omap/counter_32k.c                |   21 +-
 arch/mips/ath79/clock.c                         |  109 ++++++++++----
 arch/mips/include/asm/mach-ath79/ar71xx_regs.h  |   23 +++
 arch/mips/kernel/kgdb.c                         |    9 +
 arch/x86/Makefile                               |    2=20
 arch/x86/xen/enlighten.c                        |   18 ++
 block/blk-core.c                                |    2=20
 drivers/acpi/ec.c                               |   30 +++-
 drivers/char/tpm/tpm.c                          |   21 +-
 drivers/firewire/core-cdev.c                    |    4=20
 drivers/gpu/drm/i915/i915_gem.c                 |    1=20
 drivers/gpu/drm/i915/i915_reg.h                 |    2=20
 drivers/gpu/drm/i915/intel_display.c            |    4=20
 drivers/gpu/drm/i915/intel_pm.c                 |    4=20
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    6=20
 drivers/md/raid10.c                             |    2=20
 drivers/mtd/nand/nand_base.c                    |    8 -
 drivers/net/ethernet/intel/e1000e/e1000.h       |    6=20
 drivers/net/ethernet/intel/e1000e/netdev.c      |    2=20
 drivers/net/usb/mcs7830.c                       |   30 ++--
 drivers/net/wireless/ath/ath9k/beacon.c         |    2=20
 drivers/net/wireless/ath/ath9k/main.c           |    2=20
 drivers/net/wireless/ath/ath9k/xmit.c           |   53 +++----
 drivers/scsi/qla2xxx/qla_target.c               |    2=20
 drivers/scsi/scsi_debug.c                       |    2=20
 drivers/scsi/storvsc_drv.c                      |    5=20
 drivers/scsi/virtio_scsi.c                      |    2=20
 drivers/target/iscsi/iscsi_target.c             |    2=20
 drivers/target/iscsi/iscsi_target_core.h        |    4=20
 drivers/target/iscsi/iscsi_target_tpg.c         |   12 +
 drivers/target/target_core_configfs.c           |    8 -
 drivers/target/target_core_file.c               |   41 +++++
 drivers/target/target_core_file.h               |    1=20
 drivers/target/target_core_spc.c                |   48 +-----
 drivers/tty/vt/vt.c                             |   13 +
 drivers/usb/class/cdc-acm.c                     |    3=20
 drivers/usb/gadget/at91_udc.c                   |    2=20
 drivers/vfio/pci/vfio_pci_intrs.c               |   18 ++
 drivers/video/udlfb.c                           |    2=20
 drivers/video/via/via_clock.c                   |   19 ++
 drivers/xen/xenbus/xenbus_xs.c                  |   21 ++
 fs/autofs4/root.c                               |    6=20
 fs/ceph/export.c                                |   18 +-
 fs/gfs2/export.c                                |    4=20
 fs/isofs/export.c                               |    2=20
 fs/jbd/commit.c                                 |   45 ++++--
 fs/jbd/transaction.c                            |   64 +++++---
 fs/lockd/mon.c                                  |   86 +++++++++--
 fs/lockd/netns.h                                |    4=20
 fs/lockd/svc.c                                  |    1=20
 fs/namei.c                                      |    2=20
 fs/nfs/blocklayout/blocklayout.c                |  177 +++++++++++++++++++=
+++--
 fs/nfs/blocklayout/blocklayout.h                |    1=20
 fs/nfs/client.c                                 |    1=20
 fs/nfs/nfs4proc.c                               |    9 +
 fs/nfsd/nfs4idmap.c                             |    2=20
 fs/nfsd/nfs4state.c                             |   19 ++
 fs/reiserfs/inode.c                             |    6=20
 fs/xfs/xfs_export.c                             |    3=20
 include/linux/mtd/nand.h                        |    3=20
 kernel/audit.c                                  |    2=20
 kernel/debug/kdb/kdb_io.c                       |   33 +++-
 kernel/module.c                                 |    4=20
 kernel/time/tick-sched.c                        |    2=20
 kernel/time/timekeeping.c                       |    2=20
 kernel/timer.c                                  |   10 -
 mm/shmem.c                                      |    6=20
 net/core/pktgen.c                               |    2=20
 net/mac80211/status.c                           |    4=20
 net/mac80211/tx.c                               |   22 +-
 net/sunrpc/xprtsock.c                           |   21 ++
 scripts/Makefile.fwinst                         |    4=20
 sound/pci/ac97/ac97_codec.c                     |    2=20
 sound/pci/emu10k1/emu10k1_main.c                |    9 +
 sound/pci/hda/hda_intel.c                       |   40 +++--
 sound/pci/hda/patch_cirrus.c                    |    6=20
 sound/pci/hda/patch_realtek.c                   |    6=20
 sound/pci/hda/patch_via.c                       |    4=20
 sound/soc/codecs/wm2200.c                       |    3=20
 sound/soc/omap/omap-abe-twl6040.c               |    2=20
 sound/soc/sh/fsi.c                              |   15 +-
 85 files changed, 940 insertions(+), 297 deletions(-)

Alex Williamson (2):
      vfio: Move PCI INTx eventfd setting earlier
      vfio: Fix PCI INTx disable consistency

Alexander Holler (1):
      video/udlfb: fix line counting in fb_write

Amerigo Wang (1):
      pktgen: fix crash when generating IPv6 packets

Brian Norris (1):
      mtd: nand: allow NAND_NO_SUBPAGE_WRITE to be set from driver

Bryan Schumaker (1):
      NFS: Remove bad delegations during open recovery

Christoph Hellwig (1):
      iscsit: remove incorrect unlock in iscsit_build_sendtargets_resp

Colin Cross (1):
      ARM: OMAP: counter: add locking to read_persistent_clock

Dan Carpenter (2):
      timekeeping: Cast raw_interval to u64 to avoid shift overflow
      md/raid10: use correct limit variable

Daniel Drake (1):
      viafb: don't touch clock state on OLPC XO-1.5

David Henningsson (2):
      ALSA: hda - do not detect jack on internal speakers for Realtek
      ALSA: hda - Always check array bounds in alc_get_line_out_pfx

Egbert Eich (1):
      drm/radeon: Don't destroy I2C Bus Rec in radeon_ext_tmds_enc_destroy(=
).

Fabio Porcedda (1):
      usb: gadget: at91_udc: fix dt support

Felix Fietkau (2):
      ath9k: use ieee80211_free_txskb
      mac80211: use ieee80211_free_txskb to fix possible skb leaks

Feng Tang (2):
      ACPI: EC: Make the GPE storm threshold a module parameter
      ACPI: EC: Add a quirk for CLEVO M720T/M730T laptop

Frederic Weisbecker (1):
      nohz: Fix one jiffy count too far in idle cputime

Gabor Juhos (1):
      MIPS: ath79: Fix CPU/DDR frequency calculation for SRIF PLLs

Greg Kroah-Hartman (1):
      Linux 3.6.3

Guennadi Liakhovetski (1):
      ASoC: fsi: don't reschedule DMA from an atomic context

Hildner, Christian (1):
      timers: Fix endless looping between cascade() and internal_add_timer()

Hiroaki SHIMODA (1):
      e1000e: Change wthresh to 1 to avoid possible Tx stalls

Hugh Dickins (1):
      tmpfs,ceph,gfs2,isofs,reiserfs,xfs: fix fh_len checking

Ian Kent (1):
      autofs4 - fix reset pending flag on mount fail

J. Bruce Fields (2):
      nfsd4: don't pin clientids to pseudoflavors
      nfsd4: fix nfs4 stateid leak

Jan Kara (1):
      jbd: Fix assertion failure in commit code due to lacking transaction =
credits

Jani Nikula (1):
      drm/i915: use adjusted_mode instead of mode for checking the 6bpc for=
ce flag

Jason Wessel (2):
      mips,kgdb: fix recursive page fault with CONFIG_KPROBES
      kdb,vt_console: Fix missed data due to pager overruns

Jean-Christian de Rivaz (1):
      Add CDC-ACM support for the CX93010-2x UCMxx USB Modem

K. Y. Srinivasan (1):
      SCSI: storvsc: Account for in-transit packets in the RESET path

Kenneth Graunke (1):
      drm/i915: Set guardband clipping workaround bit in the right register.

Konrad Rzeszutek Wilk (3):
      xen/pv-on-hvm kexec: add quirk for Xen 3.4 and shutdown watches.
      xen/bootup: allow {read|write}_cr8 pvops call.
      xen/bootup: allow read_tscp call for Xen PV guests.

Lukas Czerner (1):
      SCSI: scsi_debug: Fix off-by-one bug when unmapping region

Malahal Naineni (1):
      NFSD: pass null terminated buf to kstrtouint()

Mark Brown (2):
      ASoC: wm2200: Use rev A register patches on rev B
      ASoC: wm2200: Fix non-inverted OUT2 mute control

Matthew Garrett (1):
      module: taint kernel when lve module is loaded

Maxim Kachur (1):
      ALSA: emu10k1: add chip details for E-mu 1010 PCIe card

Michal Marek (1):
      kbuild: Fix accidental revert in commit fe04ddf

Nicholas Bellinger (4):
      iscsi-target: Correctly set 0xffffffff field within ISCSI_OP_REJECT P=
DU
      iscsi-target: Add explicit set of cache_dynamic_acls=3D1 for TPG demo=
-mode
      iscsi-target: Bump defaults for nopin_timeout + nopin_response_timeou=
t values
      target/file: Re-enable optional fd_buffered_io=3D1 operation

Ondrej Zary (1):
      mcs7830: Fix link state detection

Paolo Bonzini (2):
      target: support zero allocation length in INQUIRY
      target: fix truncation of mode data, support zero allocation length

Peng Tao (2):
      pnfsblock: fix partial page buffer wirte
      NFS41: fix error of setting blocklayoutdriver

Peter Huewe (1):
      tpm: Propagate error from tpm_transmit to fix a timeout hang

Peter Senna Tschudin (1):
      target: fix return code in target_core_init_configfs error path

Peter Ujfalusi (1):
      ASoC: omap-abe-twl6040: Fix typo of Vibrator

Richard W.M. Jones (1):
      SCSI: virtio-scsi: initialize scatterlist structure

Roland Dreier (1):
      qla2xxx: Fix endianness of task management response code

Russell King (1):
      ARM: vfp: fix saving d16-d31 vfp registers on v6+ kernels

Sasha Levin (2):
      fs: handle failed audit_log_start properly
      fs: prevent use after free in auditing when symlink following was den=
ied

Simon Horman (1):
      ARM: 7541/1: Add ARM ERRATA 775420 workaround

Stanislav Kinsbursky (3):
      lockd: per-net NSM client creation and destruction helpers introduced
      lockd: use rpc client's cl_nodename for id encoding
      lockd: create and use per-net NSM RPC clients on MON/UNMON requests

Stefan Richter (1):
      firewire: cdev: fix user memory corruption (i386 userland on amd64 ke=
rnel)

Takashi Iwai (5):
      ALSA: hda - Add missing hda_gen_spec to struct via_spec
      ALSA: hda - Fix memory leaks at error path in patch_cirrus.c
      ALSA: hda - Fix registration race of VGA switcheroo
      ALSA: hda - Stop LPIB delay counting on broken hardware
      ALSA: ac97 - Fix missing NULL check in snd_ac97_cvol_new()

Tejun Heo (1):
      block: fix request_queue->flags initialization

Trond Myklebust (1):
      SUNRPC: Ensure that the TCP socket is closed when in CLOSE_WAIT

Willy Tarreau (1):
      drm/i915: remove useless BUG_ON which caused a regression in 3.5.


--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQhC+SAAoJEDjbvchgkmk+ImoP/jKxMz3mUS+WltJ14/ExZdrS
0kAtdcRJv+yBwmpI3ynOJnFaXQXfPxAApBuotutsR4Qcg720MMdcz0OTvhBPb9Ik
yKvTUroRmEqEt6V+aLBrhO7uccUiTWTIbHYq3gK/DfgD8yE7cmRPNgXmEDRTT1KS
YtPdBJV8mWEe5Cf7q/auQlfuTu8cqymixhDU/YJToHAxXoRCW3qE8XJMZ4REVHJ2
+qjNg1qCsB+UjpeCAgoIDHY2JKg1L4p/sY/KNXd+5OI7BLde6hsr2pLNxRtQEczk
6P9XTBffy3sWQg909UZ95iiV6DjET1NML15B9rR05mdfoo7BqTdOq6n3Qecd10Hn
ILWpgwOMVwMGyOTQYFQ+jePwscU1EuE38Z29aCTGGFd+Q6vF3z+/Gju8lLLDjOV5
dwHk19bKPdAgg181+5Tov6Uqpec8C0Ltnt9j6GjjeoHv9oWFsBG9BIFkJdLYQCrm
gGhkxFncOvKVAsEYSsaDm6IbPGIi5oR771PioIi4+EtO6d5NL4OerDTTqNFh4enf
s/EWTd8miT2fzli8rt0Up26ErpL8ttVXAG5rfPQ9TmYdDZv3zT3mqGUr8/S7jjtS
a3G4M8w7atCM0oQ3zXesfty/oEH5Pd/zHtc2eV6YELw9bn3DaDQaXkhkyeuH5KR+
k/kz7aZAkreveV1LEhza
=ng/B
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
