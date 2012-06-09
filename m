Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab2FIRZP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 13:25:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35958 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab2FIRZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 13:25:12 -0400
Date: Sat, 9 Jun 2012 08:51:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.4.2
Message-ID: <20120609155155.GA955@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.2 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                          |    2=20
 arch/arm/Kconfig                                  |    2=20
 arch/arm/mach-ixp4xx/common.c                     |   48 +++++++++
 arch/arm/mach-ixp4xx/include/mach/gpio.h          |   79 ----------------
 arch/ia64/include/asm/Kbuild                      |    1=20
 arch/microblaze/Kconfig                           |    2=20
 arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h |    1=20
 arch/parisc/kernel/entry.S                        |   30 +++---
 arch/parisc/kernel/vmlinux.lds.S                  |    6 -
 arch/x86/kernel/nmi.c                             |    6 -
 arch/x86/kernel/ptrace.c                          |    6 -
 arch/x86/xen/enlighten.c                          |    3=20
 drivers/acpi/battery.c                            |   10 +-
 drivers/atm/solos-pci.c                           |    4=20
 drivers/gpu/drm/i915/intel_display.c              |    2=20
 drivers/gpu/drm/i915/intel_dp.c                   |   17 +--
 drivers/gpu/drm/i915/intel_lvds.c                 |    8 +
 drivers/gpu/drm/i915/intel_sdvo.c                 |   12 +-
 drivers/gpu/drm/i915/intel_sdvo_regs.h            |    5 +
 drivers/gpu/drm/i915/intel_tv.c                   |   53 ++++++++++
 drivers/gpu/drm/radeon/evergreen.c                |   18 ++-
 drivers/gpu/drm/radeon/evergreend.h               |    1=20
 drivers/gpu/drm/radeon/ni.c                       |   32 ++++--
 drivers/gpu/drm/radeon/r600_audio.c               |    5 -
 drivers/gpu/drm/radeon/radeon_atombios.c          |    4=20
 drivers/gpu/drm/radeon/radeon_cs.c                |   31 +++---
 drivers/gpu/drm/radeon/radeon_gart.c              |   19 ++-
 drivers/gpu/drm/radeon/rv770.c                    |   10 +-
 drivers/gpu/drm/radeon/rv770d.h                   |    1=20
 drivers/gpu/drm/ttm/ttm_bo.c                      |    1=20
 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c               |    2=20
 drivers/iommu/amd_iommu.c                         |  108 ++++++++++++++---=
-----
 drivers/iommu/amd_iommu_init.c                    |   13 +-
 drivers/iommu/amd_iommu_types.h                   |    3=20
 drivers/md/raid1.c                                |    4=20
 drivers/md/raid10.c                               |    5 -
 drivers/mtd/Kconfig                               |    2=20
 drivers/mtd/devices/block2mtd.c                   |    1=20
 drivers/mtd/nand/mxc_nand.c                       |   12 +-
 drivers/mtd/nand/nand_bbt.c                       |    1=20
 drivers/net/ethernet/freescale/fec_mpc52xx.c      |    2=20
 drivers/net/usb/asix.c                            |    3=20
 drivers/net/wireless/ath/ath9k/xmit.c             |   16 ++-
 drivers/net/wireless/iwlwifi/iwl-2000.c           |    4=20
 drivers/net/wireless/iwlwifi/iwl-6000.c           |    6 -
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c         |    1=20
 drivers/net/wireless/wl1251/sdio.c                |    2=20
 drivers/net/wireless/wl1251/spi.c                 |    3=20
 drivers/scsi/scsi_lib.c                           |   11 +-
 drivers/scsi/scsi_wait_scan.c                     |    2=20
 fs/attr.c                                         |    5 +
 fs/cifs/cifsglob.h                                |    1=20
 fs/cifs/cifsproto.h                               |    6 -
 fs/cifs/cifssmb.c                                 |   12 +-
 fs/cifs/file.c                                    |   57 ++++++-----
 fs/cifs/readdir.c                                 |   15 ++-
 fs/exofs/super.c                                  |    2=20
 fs/ext4/ialloc.c                                  |   10 +-
 fs/ext4/ioctl.c                                   |   13 +-
 fs/ext4/mballoc.c                                 |    6 -
 fs/ext4/namei.c                                   |    6 +
 fs/ext4/resize.c                                  |    2=20
 fs/ext4/super.c                                   |    4=20
 fs/namespace.c                                    |    3=20
 fs/nfs/idmap.c                                    |   10 --
 fs/nfs/nfs4proc.c                                 |    2=20
 fs/proc/base.c                                    |   17 ++-
 fs/proc/task_mmu.c                                |    2=20
 include/drm/drm_pciids.h                          |   17 +++
 include/linux/Kbuild                              |    1=20
 include/linux/kernel-page-flags.h                 |    4=20
 include/linux/radix-tree.h                        |    5 -
 include/linux/skbuff.h                            |    2=20
 include/net/dst.h                                 |    1=20
 kernel/fork.c                                     |    3=20
 lib/radix-tree.c                                  |    3=20
 mm/hugetlb.c                                      |   29 ++++-
 mm/slub.c                                         |    9 +
 mm/vmalloc.c                                      |    3=20
 mm/vmscan.c                                       |    2=20
 net/ipv4/esp4.c                                   |   24 +---
 net/ipv4/fib_semantics.c                          |   12 +-
 net/ipv6/esp6.c                                   |   18 +--
 net/ipv6/ip6_output.c                             |   68 ++++++++++---
 net/l2tp/l2tp_ip.c                                |   30 ++++--
 net/mac80211/util.c                               |   12 +-
 net/sunrpc/clnt.c                                 |    2=20
 net/sunrpc/xprt.c                                 |    5 -
 net/xfrm/xfrm_policy.c                            |    3=20
 sound/usb/pcm.c                                   |    3=20
 tools/vm/page-types.c                             |   28 -----
 91 files changed, 669 insertions(+), 408 deletions(-)

Al Viro (1):
      vfs: umount_tree() might be called on subtree that had never made it

Alex Deucher (9):
      drm/radeon: fix XFX quirk
      drm/radeon: fix typo in trinity tiling setup
      drm/radeon: fix regression in UMS CS ioctl
      drm/radeon: fix bank information in tiling config
      drm/radeon: properly program gart on rv740, juniper, cypress, barts, =
hemlock
      drm/radeon/kms: add new Trinity PCI ids
      drm/radeon/kms: add new Palm, Sumo PCI ids
      drm/radeon/kms: add new BTC PCI ids
      drm/radeon/kms: add new SI PCI ids

Andreas Dilger (1):
      ext4: disallow hard-linked directory in ext4_lookup

Andy Whitcroft (1):
      ACPI battery: only refresh the sysfs files when pertinent information=
 changes

Benjamin Poirier (1):
      xfrm: take net hdr len into account for esp payload size calculation

Boaz Harrosh (1):
      exofs: Fix CRASH on very early IO errors.

Chris Wilson (1):
      drm/i915/dp: Flush any outstanding work to turn the VDD off

Christian K=C3=B6nig (1):
      drm/radeon: fix vm deadlocks on cayman

Clemens Ladisch (1):
      ALSA: usb-audio: fix rate_list memory leak

Dan Carpenter (2):
      NFS: kmalloc() doesn't return an ERR_PTR()
      ext4: fix potential NULL dereference in ext4_free_inodes_counts()

Daniel Vetter (3):
      drm/i915: properly handle interlaced bit for sdvo dtd conversion
      drm/i915: wait for a vblank to pass after tv detect
      drm/i915: enable vdd when switching off the eDP panel

Dave Hansen (2):
      hugetlb: fix resv_map leak in error path
      mm: fix vma_resv_map() NULL pointer

David Woodhouse (1):
      solos-pci: Fix DMA support

Dmitry Kasatkin (1):
      vfs: increment iversion when a file is truncated

Dmitry Maluka (1):
      mtd: nand: fix scan_read_raw_oob

Eric Dumazet (1):
      asix: allow full size 8021Q frames to be received

Eric Sandeen (1):
      ext4: force ro mount if ext4_setup_super() fails

Eyal Shapira (1):
      mac80211: fix ADDBA declined after suspend with wowlan

Felix Fietkau (2):
      ath9k: fix a use-after-free-bug when ath_tx_setup_buffer() fails
      skb: avoid unnecessary reallocations in __skb_cow

Frank Svendsboe (1):
      mtd: of_parts: fix breakage in Kconfig

Gabor Juhos (1):
      mtd: block2mtd: fix recursive call of mtd_writev

Gao feng (1):
      ipv6: fix incorrect ipsec fragment

Grazvydas Ignotas (1):
      wl1251: fix oops on early interrupt

Greg Kroah-Hartman (1):
      Linux 3.4.2

H.J. Lu (1):
      x86, x32, ptrace: Remove PTRACE_ARCH_PRCTL for x32

Haogang Chen (1):
      ext4: fix potential integer overflow in alloc_flex_gd()

James Bottomley (2):
      SCSI: fix scsi_wait_scan
      PARISC: fix TLB fault path on PA2.0 narrow systems

James Chapman (1):
      l2tp: fix oops in L2TP IP sockets for connect() AF_UNSPEC case

Jan-Benedict Glaw (1):
      drm/i915: no lvds quirk for HP t5740e Thin Client

Jerome Glisse (1):
      drm/radeon: fix HD6790, HD6570 backend programming

Jesse Barnes (1):
      drm/i915: always use RPNSWREQ for turbo change requests

Joerg Roedel (4):
      iommu/amd: Check for the right TLP prefix bit
      iommu/amd: Add workaround for event log erratum
      iommu/amd: Cache pdev pointer to root-bridge
      iommu/amd: Fix deadlock in ppr-handling error path

John David Anglin (1):
      PARISC: fix boot failure on 32-bit systems caused by branch stubs pla=
ced before .text

Jonas Gorski (1):
      MIPS: BCM63XX: Add missing include for bcm63xx_gpio.h

Joonsoo Kim (1):
      slub: fix a memory leak in get_partial_node()

Jun'ichi Nomura (1):
      SCSI: Fix dm-multipath starvation when scsi host is busy

Konrad Rzeszutek Wilk (1):
      x86, amd, xen: Avoid NULL pointer paravirt references

Konstantin Khlebnikov (1):
      radix-tree: fix contiguous iterator

KyongHo (1):
      mm: fix faulty initialization in vmalloc_init()

Lars-Peter Clausen (1):
      microblaze: Do not select GENERIC_GPIO by default

Linus Torvalds (1):
      vfs: Fix /proc/<tid>/fdinfo/<fd> file handling

Meenakshi Venkataraman (2):
      iwlwifi: update BT traffic load states correctly
      iwlwifi: do not use shadow registers by default

Michal Hocko (1):
      mm: consider all swapped back pages in used-once logic

NeilBrown (1):
      md: raid1/raid10: fix problem with merge_bvec_fn

Rafa=C5=82 Mi=C5=82ecki (1):
      drm/radeon/audio: don't hardcode CRTC id

Richard Cochran (1):
      ixp4xx: fix compilation by adding gpiolib support

Rodrigo Vivi (1):
      drm/i915: Adding TV Out Missing modes.

Salman Qazi (2):
      ext4: add ext4_mb_unload_buddy in the error path
      ext4: remove mb_groups before tearing down the buddy_cache

Sascha Hauer (1):
      mtd: mxc_nand: move ecc strengh setup before nand_scan_tail

Sasha Levin (1):
      mm: fix NULL ptr deref when walking hugepages

Shirish Pargaonkar (2):
      cifs: Include backup intent search flags during searches {try #2)
      cifs: fix oops while traversing open file list (try #4)

Siddhesh Poyarekar (1):
      mm/fork: fix overflow in vma length when copying mmap on clone

Stephan Gatzka (1):
      fec_mpc52xx: fix timestamp filtering

Steven Rostedt (1):
      x86: Reset the debug_stack update counter

Tao Ma (1):
      ext4: don't set i_flags in EXT4_IOC_SETFLAGS

Theodore Ts'o (2):
      ext4: add missing save_error_info() to ext4_error()
      ext4: don't trash state flags in EXT4_IOC_SETFLAGS

Thomas Hellstrom (2):
      drm/ttm: Fix spinlock imbalance
      drm/vmwgfx: Fix nasty write past alloced memory area

Trond Myklebust (2):
      NFSv4: Map NFS4ERR_SHARE_DENIED into an EACCES error instead of EIO
      sunrpc: fix loss of task->tk_status after rpc_delay call in xprt_allo=
c_slot

Ulrich Drepper (1):
      kbuild: install kernel-page-flags.h

Yanmin Zhang (1):
      ipv4: fix the rcu race between free_fib_info and ip_route_output_slow

maximilian attems (1):
      IA64: Add cmpxchg.h to exported userspace headers


--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJP03EbAAoJEDjbvchgkmk+bAMP/09cYov/uJGDlUPYZKIijKB7
z7trhFuU9Ve1i/74RnILm/jymA5xFcLd0V/+K2EWKsSi4k8NRyrnx6qnaDZCMHwf
aGsxDrd/2W2TSDR1QmAM+88anI84obtIOjbulHIaqFV6DDykJQbRLhe1UNYtamWk
ZxbE5oMqrRPBTrn62r8d44lhdkHtZgU44h0uydKmal/iSi185EfqXkYUN01TwkmC
Xk6f4vsHp+xUYTqYckSsjMwMKcV2xA/QX3qkwhiuF3IitJv1dmlFaqqIrbctcUxp
PnbzdCpw0fQSHA1CFlFM23yKLI76wIG5/11ciSwzgXGh33amxemOqu3YmkRxKEMD
uJMjUc17QQfnZ7fl08vwb49tgkNgLGpZ3D79Emex0+SBC0LKR33TIDdhPs8Zey/T
r7HPx9m7dVGRObespw1lXwtFHD4IwivtkS5NAWPfpT2Rp+l+/lI9IabGkFUZN6UC
jIDTMQMlBJ+iJAYRZQ/hE3/OW/VoNeXDk8SrG4bNKbUBYw9u8IQtjlFCXGLiBXdz
7K/smi2nHYoUuG7D/ml0FnR2G/Jy3jina4T50n5e9t3F4Vea0cCftZ15iH+Fy0HY
JIMBMBvjltEQEDd6Ju1ao3e6LHttplLZ4d9igM0iag2OM00Bxatl9FmHwV7HZtr7
d5ogxR0wGYBzHTmB3jeM
=a+1s
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
