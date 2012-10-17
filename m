Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab2JQXHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 19:07:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50698 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752449Ab2JQXG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 19:06:59 -0400
Message-ID: <1350515187.26833.88.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.32
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Thu, 18 Oct 2012 00:06:27 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-CkodNQi0OALUjmvt5I1F"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CkodNQi0OALUjmvt5I1F
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.32 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

Ben.

------------

 Documentation/virtual/lguest/lguest.c          |    1 +
 Makefile                                       |    2 +-
 arch/arm/plat-omap/counter_32k.c               |   21 +-
 arch/mips/Makefile                             |    2 +-
 arch/mips/kernel/Makefile                      |    2 +-
 arch/mn10300/Makefile                          |    2 +-
 arch/powerpc/platforms/pseries/eeh_driver.c    |   94 ++++++--
 arch/x86/include/asm/pgtable.h                 |   11 +-
 arch/x86/platform/efi/efi.c                    |    1 +
 drivers/acpi/bus.c                             |    8 +-
 drivers/bluetooth/btusb.c                      |    2 +-
 drivers/char/ttyprintk.c                       |    2 +-
 drivers/dma/dmaengine.c                        |    4 +-
 drivers/firewire/core-cdev.c                   |    4 +-
 drivers/firmware/efivars.c                     |   17 +-
 drivers/gpu/drm/i915/i915_gem.c                |   17 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c     |    3 +-
 drivers/gpu/drm/i915/i915_gem_tiling.c         |    4 +-
 drivers/gpu/drm/i915/i915_irq.c                |   24 +-
 drivers/gpu/drm/i915/i915_reg.h                |    7 +
 drivers/gpu/drm/i915/intel_display.c           |   35 ++-
 drivers/gpu/drm/i915/intel_hdmi.c              |   17 +-
 drivers/gpu/drm/radeon/evergreen.c             |  185 +++++++--------
 drivers/gpu/drm/radeon/evergreen_reg.h         |    3 +
 drivers/gpu/drm/radeon/evergreend.h            |    7 +
 drivers/gpu/drm/radeon/radeon_asic.h           |    1 +
 drivers/gpu/drm/radeon/radeon_irq_kms.c        |   10 +
 drivers/gpu/drm/radeon/radeon_pm.c             |    8 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   19 +-
 drivers/infiniband/ulp/srp/ib_srp.c            |    3 +-
 drivers/input/mouse/synaptics.c                |   31 ++-
 drivers/iommu/intel-iommu.c                    |    4 +-
 drivers/media/rc/ite-cir.c                     |    2 +-
 drivers/media/video/gspca/pac7302.c            |    2 +
 drivers/mmc/host/omap_hsmmc.c                  |    4 +-
 drivers/mmc/host/sdhci-s3c.c                   |    2 +-
 drivers/mmc/host/sh_mmcif.c                    |    4 +
 drivers/mtd/maps/autcpu12-nvram.c              |   19 +-
 drivers/mtd/mtdpart.c                          |    5 +-
 drivers/mtd/nand/nand_bbt.c                    |    2 +-
 drivers/mtd/nand/nandsim.c                     |    1 +
 drivers/mtd/nand/omap2.c                       |    3 +-
 drivers/mtd/ubi/build.c                        |    5 +
 drivers/mtd/ubi/scan.c                         |    2 +-
 drivers/net/can/mscan/mpc5xxx_can.c            |    4 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c  |    8 +-
 drivers/net/ethernet/realtek/r8169.c           |   21 +-
 drivers/net/rionet.c                           |   20 +-
 drivers/net/wireless/ath/ath9k/pci.c           |    5 +-
 drivers/pci/probe.c                            |    6 +-
 drivers/s390/scsi/zfcp_aux.c                   |    1 +
 drivers/s390/scsi/zfcp_ccw.c                   |   73 +++++-
 drivers/s390/scsi/zfcp_cfdc.c                  |    2 +-
 drivers/s390/scsi/zfcp_dbf.c                   |   22 +-
 drivers/s390/scsi/zfcp_dbf.h                   |    1 +
 drivers/s390/scsi/zfcp_def.h                   |    2 +
 drivers/s390/scsi/zfcp_ext.h                   |    2 +
 drivers/s390/scsi/zfcp_fsf.c                   |   23 +-
 drivers/s390/scsi/zfcp_qdio.c                  |   16 +-
 drivers/s390/scsi/zfcp_sysfs.c                 |   18 +-
 drivers/s390/scsi/zfcp_unit.c                  |   36 ++-
 drivers/scsi/atp870u.c                         |   11 +-
 drivers/scsi/device_handler/scsi_dh_alua.c     |    3 +-
 drivers/scsi/hpsa.c                            |   41 +++-
 drivers/scsi/hpsa.h                            |    2 +
 drivers/scsi/hpsa_cmd.h                        |    1 +
 drivers/scsi/ibmvscsi/ibmvscsi.c               |    3 +
 drivers/scsi/isci/init.c                       |    1 -
 drivers/scsi/isci/probe_roms.c                 |    1 -
 drivers/scsi/scsi_sysfs.c                      |   30 ++-
 drivers/staging/comedi/comedi_fops.c           |    5 +-
 drivers/staging/comedi/drivers/jr3_pci.c       |    2 +-
 drivers/staging/comedi/drivers/s626.c          |    2 +-
 drivers/staging/speakup/speakup_soft.c         |   13 +-
 drivers/target/iscsi/iscsi_target.c            |    2 +-
 drivers/target/iscsi/iscsi_target_core.h       |    4 +-
 drivers/target/iscsi/iscsi_target_tpg.c        |   12 +
 drivers/target/target_core_configfs.c          |    8 +-
 drivers/target/target_core_file.c              |   41 +++-
 drivers/target/target_core_file.h              |    1 +
 drivers/tty/n_gsm.c                            |  104 +++++----
 drivers/tty/n_tty.c                            |    3 +-
 drivers/tty/serial/8250_pci.c                  |    9 +-
 drivers/tty/serial/amba-pl011.c                |   15 +-
 drivers/usb/host/xhci-mem.c                    |    7 +
 drivers/usb/host/xhci-pci.c                    |    1 +
 drivers/usb/host/xhci-ring.c                   |  286 ++++++++++++++++++++=
+++-
 drivers/usb/host/xhci.c                        |   39 +++-
 drivers/usb/host/xhci.h                        |   20 ++
 drivers/usb/serial/ftdi_sio.c                  |    2 +
 drivers/usb/serial/ftdi_sio_ids.h              |    5 +
 drivers/usb/serial/option.c                    |    3 +-
 drivers/usb/serial/qcaux.c                     |   10 +-
 fs/autofs4/root.c                              |    6 +-
 fs/binfmt_elf.c                                |   19 +-
 fs/ecryptfs/ecryptfs_kernel.h                  |    2 +
 fs/ecryptfs/file.c                             |  100 ++++-----
 fs/ecryptfs/inode.c                            |   65 +++---
 fs/ecryptfs/main.c                             |    1 +
 fs/ecryptfs/mmap.c                             |   39 ++--
 fs/ext4/inode.c                                |   25 ++-
 fs/ext4/move_extent.c                          |  174 +++++---------
 fs/ext4/namei.c                                |    2 -
 fs/fs-writeback.c                              |    1 +
 fs/jffs2/wbuf.c                                |    8 +-
 fs/lockd/mon.c                                 |    4 +-
 fs/nfs/blocklayout/blocklayout.c               |  176 ++++++++++++++-
 fs/nfs/blocklayout/blocklayout.h               |    1 +
 fs/udf/super.c                                 |    5 +-
 include/linux/mempolicy.h                      |    2 +-
 include/linux/pci_ids.h                        |    1 -
 include/net/ip_vs.h                            |    2 +-
 kernel/rcutree.c                               |    4 +-
 kernel/sched_stoptask.c                        |   22 +-
 kernel/sys.c                                   |    1 +
 kernel/workqueue.c                             |   27 ++-
 lib/gcd.c                                      |    3 +
 mm/hugetlb.c                                   |    4 +-
 mm/mempolicy.c                                 |  116 ++++++----
 mm/slab.c                                      |    6 +-
 mm/truncate.c                                  |    3 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    8 +
 net/ipv4/netfilter/nf_nat_sip.c                |   10 +-
 net/netfilter/nf_conntrack_expect.c            |   29 +--
 net/netfilter/xt_hashlimit.c                   |    8 +-
 net/netfilter/xt_limit.c                       |   13 +-
 net/sunrpc/xprtsock.c                          |   21 +-
 scripts/Kbuild.include                         |   14 +-
 scripts/gcc-version.sh                         |    6 +-
 scripts/gcc-x86_32-has-stack-protector.sh      |    2 +-
 scripts/gcc-x86_64-has-stack-protector.sh      |    2 +-
 scripts/kconfig/check.sh                       |    2 +-
 scripts/kconfig/lxdialog/check-lxdialog.sh     |    2 +-
 scripts/kconfig/streamline_config.pl           |    2 +
 scripts/package/buildtar                       |    2 +-
 sound/drivers/aloop.c                          |    6 +
 sound/pci/hda/patch_conexant.c                 |   94 ++++++--
 tools/hv/hv_kvp_daemon.c                       |    8 +-
 tools/perf/Makefile                            |    2 +-
 tools/power/cpupower/Makefile                  |    2 +-
 141 files changed, 1812 insertions(+), 791 deletions(-)

Alex Deucher (4):
      drm/radeon: only adjust default clocks on NI GPUs
      drm/radeon: Add MSI quirk for gateway RS690
      drm/radeon: force MSIs on RS690 asics
      drm/radeon: properly handle mc_stop/mc_resume on evergreen+ (v2)

Alex Williamson (1):
      intel-iommu: Default to non-coherent for domains unattached to iommus

Alexander Shiyan (1):
      mtd: autcpu12-nvram: Fix compile breakage

Alexandre Bounine (1):
      rapidio/rionet: fix multicast packet transmit logic

Andrea Arcangeli (1):
      mm: thp: fix pmd_present for split_huge_page and PROT_NONE with THP

Andreas Bie=C3=9Fmann (2):
      mtd: omap2: fix omap_nand_remove segfault
      mtd: omap2: fix module loading

Antonio Ospite (1):
      USB: ftdi_sio: add TIAO USB Multi-Protocol Adapter (TUMPA) support

Artem Bityutskiy (1):
      UBI: fix autoresize handling in R/O mode

Bart Van Assche (3):
      scsi_dh_alua: Enable STPG for unavailable ports
      IB/srp: Fix use-after-free in srp_reset_req()
      IB/srp: Avoid having aborted requests hang

Ben Hutchings (4):
      tools/hv: Fix exit() error code
      rc: ite-cir: Initialise ite_dev::rdev earlier
      staging: speakup_soft: Fix reading of init string
      Linux 3.2.32

Ben Widawsky (1):
      drm/i915: Fix GT_MODE default value

Benjamin Herrenschmidt (1):
      ibmvscsi: Fix host config length field overflow

Bernd Schubert (1):
      ext4: always set i_op in ext4_mknod()

Bernhard Walle (1):
      scripts/Kbuild.include: Fix portability problem of "echo -e"

Bj=C3=B8rn Mork (2):
      USB: option: blacklist QMI interface on ZTE MF683
      USB: qcaux: add Pantech vendor class match

Brian Norris (1):
      JFFS2: don't fail on bitflips in OOB

Chris Wilson (2):
      drm/i915: Flush the pending flips on the CRTC before modification
      drm/i915: Mark untiled BLT commands as fenced on gen2/3

Christoph Hellwig (1):
      iscsit: remove incorrect unlock in iscsit_build_sendtargets_resp

Colin Cross (1):
      ARM: OMAP: counter: add locking to read_persistent_clock

Dan Williams (2):
      isci: fix isci_pci_probe() generates warning on efi failure path
      scsi_remove_target: fix softlockup regression on hot remove

Daniel Vetter (3):
      drm/i915: call drm_handle_vblank before finish_page_flip
      drm/i915: fix swizzle detection for gen3
      drm/i915: clear fencing tracking state when retiring requests

David Henningsson (2):
      ALSA: hda - Fix internal mic for Lenovo Ideapad U300s
      ALSA: HDA: Add inverted internal mic quirk for Lenovo S205

Davidlohr Bueso (1):
      lib/gcd.c: prevent possible div by 0

Denys Vlasenko (1):
      coredump: prevent double-free on an error path in core dumper

Dmitry Monakhov (2):
      ext4: move_extent code cleanup
      ext4: online defrag is not supported for journaled files

Elric Fu (4):
      xHCI: add cmd_ring_state
      xHCI: add aborting command ring function
      xHCI: cancel command after command timeout
      xHCI: handle command after aborting the command ring

Eugeni Dodonov (1):
      drm/i915: prevent possible pin leak on error path

Fabio Estevam (1):
      drivers/dma/dmaengine.c: lower the priority of 'failed to get' dma ch=
annel message

Felix Kaechele (1):
      ALSA: hda - Add inverted internal mic quirk for Lenovo IdeaPad U310

Flavio Leitner (1):
      serial: set correct baud_base for EXSYS EX-41092 Dual 16950

Florian Westphal (1):
      netfilter: limit, hashlimit: avoid duplicated inline

Francois Romieu (2):
      r8169: Config1 is read-only on 8168c and later.
      r8169: 8168c and later require bit 0x20 to be set in Config2 for PME =
signaling.

Frank Sch=C3=A4fer (1):
      gspca_pac7302: add support for device 1ae7:2001 Speedlink Snappy Micr=
ophone SL-6825-SBK

Frederic Berat (1):
      n_gsm : Flow control handling in Mux driver

Gavin Shan (1):
      powerpc/eeh: Lock module while handling EEH event

Geert Uytterhoeven (1):
      mn10300: only add -mmem-funcs to KBUILD_CFLAGS if gcc supports it

Guennadi Liakhovetski (1):
      mmc: sh-mmcif: avoid oops on spurious interrupts

Gustavo Padovan (1):
      Bluetooth: Add USB_VENDOR_AND_INTERFACE_INFO() for Broadcom/Foxconn

Hans de Goede (1):
      gspca_pac7302: Add usb-id for 145f:013c

Hillf Danton (1):
      mm: hugetlb: fix pgoff computation when unmapping page from vma

Huang Shijie (1):
      mtd: mtdpart: break it as soon as we parse out the partitions

Hugh Dickins (1):
      mm: fix invalidate_complete_page2() lock ordering

Ian Abbott (4):
      staging: comedi: don't dereference user memory for INSN_INTTRIG
      staging: comedi: fix memory leak for saved channel list
      staging: comedi: s626: don't dereference insn->data
      staging: comedi: jr3_pci: fix iomem dereference

Ian Kent (1):
      autofs4 - fix reset pending flag on mount fail

Jaehoon Chung (1):
      mmc: sdhci-s3c: fix the wrong number of max bus clocks

Jan Engelhardt (1):
      netfilter: xt_limit: have r->cost !=3D 0 case work

Jan Kara (1):
      ext4: fix fdatasync() for files with only i_size changes

Jani Nikula (1):
      drm/i915: use adjusted_mode instead of mode for checking the 6bpc for=
ce flag

Jean Delvare (1):
      kbuild: Fix gcc -x syntax

Jesse Brandeburg (1):
      e1000: fix lockdep splat in shutdown handler

Jiri Slaby (1):
      TTY: ttyprintk, don't touch behind tty->write_buf

Jozsef Kadlecsik (1):
      netfilter: nf_ct_ipv4: packets with wrong ihl are invalid

Julia Lawall (1):
      zfcp: remove invalid reference to list iterator variable

KOSAKI Motohiro (2):
      mempolicy: remove mempolicy sharing
      mempolicy: fix refcount leak in mpol_set_shared_policy()

Khalid Aziz (1):
      firmware: Add missing attributes to EFI variable attribute print out =
from sysfs

Lai Jiangshan (1):
      workqueue: fix possible stall on try_to_grab_pending() of a delayed w=
ork item

Lin Ming (2):
      ACPI: run _OSC after ACPI_FULL_INITIALIZATION
      ipvs: fix oops on NAT reply in br_nf context

Linus Walleij (1):
      serial: pl011: handle corruption at high clock speeds

Martin Michlmayr (1):
      drivers/scsi/atp870u.c: fix bad use of udelay

Martin Peschke (1):
      zfcp: only access zfcp_scsi_dev for valid scsi_device

Matthieu CASTET (1):
      UBI: erase free PEB with bitflip in EC header

Mel Gorman (2):
      mempolicy: fix a race in shared_policy_replace()
      mempolicy: fix a memory corruption by refcount imbalance in alloc_pag=
es_vma()

Michael Spang (1):
      Increase XHCI suspend timeout to 16ms

Michael Wang (1):
      slab: fix the DEADLOCK issue on l3 alien lock

Michal Hocko (1):
      hugetlb: do not use vma_hugecache_offset() for vma_prio_tree_foreach

Michal Marek (1):
      kbuild: Do not package /boot and /lib in make tar-pkg

Mike Galbraith (1):
      sched: Fix migration thread runtime bogosity

Nicholas Bellinger (4):
      iscsi-target: Correctly set 0xffffffff field within ISCSI_OP_REJECT P=
DU
      target/file: Re-enable optional fd_buffered_io=3D1 operation
      iscsi-target: Add explicit set of cache_dynamic_acls=3D1 for TPG demo=
-mode
      iscsi-target: Bump defaults for nopin_timeout + nopin_response_timeou=
t values

Nikola Pajkovsky (1):
      udf: fix retun value on error path in udf_load_logicalvol

Omair Mohammed Abdullah (1):
      ALSA: aloop - add locking to timer access

Pablo Neira Ayuso (2):
      netfilter: nf_nat_sip: fix incorrect handling of EBUSY for RTCP expec=
tation
      netfilter: nf_ct_expect: fix possible access to uninitialized timer

Patrick McHardy (2):
      IPoIB: Fix use-after-free of multicast object
      netfilter: nf_nat_sip: fix via header translation with multiple param=
eters

Paul E. McKenney (1):
      rcu: Fix day-one dyntick-idle stall-warning bug

Paulo Zanoni (2):
      drm/i915: add some barriers when changing DIPs
      drm/i915: make sure we write all the DIP data bytes

Peng Tao (1):
      pnfsblock: fix partial page buffer wirte

Peter Senna Tschudin (1):
      target: fix return code in target_core_init_configfs error path

Richard Genoud (1):
      mtd: nandsim: bugfix: fail if overridesize is too big

Russ Gorby (5):
      n_gsm: uplink SKBs accumulate on list
      n_gsm: added interlocking for gsm_data_lock for certain code paths
      n_gsm: avoid accessing freed memory during CMD_FCOFF condition
      n_gsm: replace kfree_skb w/ appropriate dev_* versions
      n_gsm: memory leak in uplink error path

Rusty Russell (1):
      lguest: fix occasional crash in example launcher.

Sarah Sharp (2):
      xhci: Warn when hosts don't halt.
      xhci: Intel Panther Point BEI quirk.

Sascha Hauer (1):
      kbuild: make: fix if_changed when command contains backslashes

Seiji Aguchi (1):
      efi: initialize efi.runtime_version to make query_variable_info/updat=
e_capsule workable

Seth Forshee (1):
      Input: synaptics - adjust threshold for treating position values as n=
egative

Shawn Guo (1):
      kernel/sys.c: call disable_nonboot_cpus() in kernel_restart()

Shmulik Ladkani (1):
      mtd: nand: Use the mirror BBT descriptor when reading its version

Stanislav Kinsbursky (1):
      lockd: use rpc client's cl_nodename for id encoding

Stanislav Kozina (1):
      Remove BUG_ON from n_tty_read()

Stefan Richter (1):
      firewire: cdev: fix user memory corruption (i386 userland on amd64 ke=
rnel)

Steffen Maier (4):
      zfcp: Make trace record tags unique
      zfcp: Bounds checking for deferred error trace
      zfcp: Do not wakeup while suspended
      zfcp: restore refcount check on port_remove

Stephen M. Cameron (2):
      hpsa: Use LUN reset instead of target reset
      hpsa: dial down lockup detection during firmware flash

Sujith Manoharan (1):
      ath9k: Disable ASPM only for AR9285

Tejun Heo (1):
      workqueue: add missing smp_wmb() in process_one_work()

Theodore Ts'o (1):
      ext4: fix potential deadlock in ext4_nonda_switch()

Trond Myklebust (1):
      SUNRPC: Ensure that the TCP socket is closed when in CLOSE_WAIT

Tyler Hicks (5):
      eCryptfs: Unlink lower inode when ecryptfs_create() fails
      eCryptfs: Initialize empty lower files when opening them
      eCryptfs: Revert to a writethrough cache model
      eCryptfs: Write out all dirty pages just before releasing the lower f=
ile
      eCryptfs: Call lower ->flush() from ecryptfs_flush()

Vaibhav Bedia (1):
      mmc: omap_hsmmc: Pass on the suspend failure to the PM core

Vivek Gautam (1):
      usb: host: xhci: Fix Null pointer dereferencing with 71c731a for non-=
x86 systems

Wei Yongjun (1):
      can: mscan-mpc5xxx: fix return value check in mpc512x_can_get_clock()

Yinghai Lu (1):
      PCI: Check P2P bridge for invalid secondary/subordinate range

Yuta Ando (1):
      localmodconfig: Fix localyesconfig to set to 'y' not 'm'

samix.lebsir (1):
      char: n_gsm: remove message filtering for contipated DLCI

xiaojin (1):
      n_gsm.c: Implement 3GPP27.010 DLC start-up procedure in MUX


--=20
Ben Hutchings
Anthony's Law of Force: Don't force it, get a larger hammer.

--=-CkodNQi0OALUjmvt5I1F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUH859Oe/yOyVhhEJAQociA/9FY+TvaDWTiG1uL4z8N2Sks4GYzOir1jM
qCHYHj7nSlvP52OUGprmbDrB8jiCBv8sqAQLeUi8/9UE4gDD6dbpFO60x20cdDB3
gG5mi5nE+KKDXEAfZ2w5SJJNUo4lYkAQK2N/qBIG4TJFRiBTftZ+6+SlY5syj6lc
QXIfvZS6LgXFz54k4ehClKLz262F5RKd3OzaP86PyN+hwOVTPp2UmcWqPDiZUmCr
aduwyT5381Z7vhClg3FdLOpmIgarr2I8PDLSW1LN+en8ONAMPpOounPrWn6YTTBg
YHp/yi74UzymZETx/kiR4LrNz2QOs/nh4jjHJvFXV3IPchQ9NZy48F1UZKa9ltWl
+rcG2UYlYpmQaRyJExqWuX2AmMDzvx6YJ2NBxgPmiNgarpy7h9pCTGrG/R5daPFD
PirpdA6AYG2CpjKAY+xn68EOaiX7Ks3iswHCTsOYxxHWsNLMuJnChrMb1LOzZiPl
rpBN2aEajb9PhikuU9bCX9mvQjQ3ULgMHLrT52ugBRDCxXWJjJUNEO6NHFtNWb30
OoAHzXWEBU3NvLumjjOXn/N0s72iKx3rKMGM7EtDNKpXZ9ZKgQJcPF2xKVKD3L5O
tjI9jNPxc2xDHtc9A61wh7T20CvH31hGphxzvaYiMFDXwQNFajpcHAUtnMlTTQn2
OOFqMKCXSbo=
=qRgg
-----END PGP SIGNATURE-----

--=-CkodNQi0OALUjmvt5I1F--
