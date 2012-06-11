Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab2FKAkF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 20:40:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42345 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751123Ab2FKAkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 20:40:01 -0400
Message-ID: <1339375190.21665.217.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.20
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Mon, 11 Jun 2012 01:39:50 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-YIwS3U0e/9Vl/pfrWmov"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YIwS3U0e/9Vl/pfrWmov
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.20 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

Ben.

------------

 Makefile                                          |    2 +-
 arch/arm/Kconfig                                  |    2 +-
 arch/arm/mach-ixp4xx/common.c                     |   48 ++++++++++++-
 arch/arm/mach-ixp4xx/include/mach/gpio.h          |   79 +----------------=
----
 arch/microblaze/Kconfig                           |    2 +-
 arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h |    1 +
 arch/parisc/kernel/entry.S                        |   30 ++++----
 arch/parisc/kernel/vmlinux.lds.S                  |    6 +-
 arch/x86/xen/enlighten.c                          |    3 +
 drivers/acpi/battery.c                            |   10 ++-
 drivers/atm/solos-pci.c                           |    4 +-
 drivers/bluetooth/ath3k.c                         |   10 +++
 drivers/bluetooth/btusb.c                         |   14 +++-
 drivers/gpu/drm/i915/i915_reg.h                   |    6 +-
 drivers/gpu/drm/i915/intel_display.c              |    4 +-
 drivers/gpu/drm/i915/intel_dp.c                   |   17 +++--
 drivers/gpu/drm/i915/intel_lvds.c                 |   32 +++++++++
 drivers/gpu/drm/i915/intel_sdvo.c                 |   12 ++--
 drivers/gpu/drm/i915/intel_sdvo_regs.h            |    5 ++
 drivers/gpu/drm/i915/intel_tv.c                   |    5 ++
 drivers/gpu/drm/radeon/evergreen.c                |   18 +++--
 drivers/gpu/drm/radeon/evergreend.h               |    1 +
 drivers/gpu/drm/radeon/ni.c                       |    6 +-
 drivers/gpu/drm/radeon/radeon_atombios.c          |    4 +-
 drivers/gpu/drm/radeon/rv770.c                    |   10 ++-
 drivers/gpu/drm/radeon/rv770d.h                   |    1 +
 drivers/gpu/drm/ttm/ttm_bo.c                      |    1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c               |    2 +-
 drivers/iommu/amd_iommu.c                         |   29 ++++++--
 drivers/iommu/amd_iommu_init.c                    |   13 ++--
 drivers/iommu/amd_iommu_types.h                   |    3 +
 drivers/mtd/Kconfig                               |    2 +-
 drivers/mtd/nand/nand_bbt.c                       |    1 +
 drivers/net/ethernet/freescale/fec_mpc52xx.c      |    2 +-
 drivers/net/ethernet/realtek/r8169.c              |   39 +++++++---
 drivers/net/macvlan.c                             |    2 +-
 drivers/net/usb/asix.c                            |    3 +-
 drivers/net/wireless/ath/ath9k/xmit.c             |   16 +++--
 drivers/net/wireless/iwlwifi/iwl-2000.c           |    4 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c           |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c         |    1 +
 drivers/net/wireless/wl1251/sdio.c                |    2 +-
 drivers/net/wireless/wl1251/spi.c                 |    3 +-
 drivers/scsi/scsi_lib.c                           |   11 +--
 drivers/scsi/scsi_wait_scan.c                     |    2 +-
 drivers/target/target_core_file.c                 |   78 +++++------------=
---
 drivers/target/target_core_file.h                 |    1 -
 fs/attr.c                                         |    5 ++
 fs/cifs/cifsglob.h                                |    1 +
 fs/cifs/cifsproto.h                               |    6 +-
 fs/cifs/cifssmb.c                                 |   12 ++--
 fs/cifs/file.c                                    |   57 ++++++++-------
 fs/cifs/readdir.c                                 |   15 +++-
 fs/exofs/super.c                                  |    2 +-
 fs/ext4/balloc.c                                  |    8 +--
 fs/ext4/ioctl.c                                   |   13 ++--
 fs/ext4/mballoc.c                                 |    6 +-
 fs/ext4/namei.c                                   |    6 ++
 fs/ext4/super.c                                   |    4 +-
 fs/namespace.c                                    |    3 +-
 fs/nfs/nfs4proc.c                                 |    2 +
 include/drm/drm_pciids.h                          |    4 ++
 include/linux/Kbuild                              |    1 +
 include/linux/kernel-page-flags.h                 |    4 ++
 include/linux/netdevice.h                         |    9 ---
 include/linux/netfilter_bridge.h                  |    9 +++
 include/linux/skbuff.h                            |    2 -
 include/net/dst.h                                 |    2 +
 include/net/sctp/sctp.h                           |   13 ++++
 kernel/fork.c                                     |    3 +-
 lib/btree.c                                       |    4 +-
 mm/hugetlb.c                                      |   29 ++++++--
 mm/slub.c                                         |    9 ++-
 mm/vmalloc.c                                      |   11 +--
 mm/vmscan.c                                       |    2 +-
 net/8021q/vlan_dev.c                              |    2 +-
 net/bridge/br_forward.c                           |    1 +
 net/bridge/br_netfilter.c                         |    8 +--
 net/core/dev.c                                    |   36 ++--------
 net/ipv4/esp4.c                                   |   24 +++----
 net/ipv4/fib_semantics.c                          |   12 ++--
 net/ipv4/fib_trie.c                               |    2 +
 net/ipv6/esp6.c                                   |   18 ++---
 net/ipv6/ip6_output.c                             |   68 +++++++++++++----=
-
 net/l2tp/l2tp_ip.c                                |   30 ++++++--
 net/mac80211/util.c                               |   12 ++--
 net/sctp/output.c                                 |    4 +-
 net/sctp/transport.c                              |   17 -----
 net/sunrpc/clnt.c                                 |    2 +
 net/sunrpc/xprt.c                                 |    5 +-
 net/xfrm/xfrm_policy.c                            |    3 +
 sound/usb/pcm.c                                   |    3 +
 92 files changed, 607 insertions(+), 435 deletions(-)

AceLan Kao (2):
      Bluetooth: Add support for Atheros [13d3:3362]
      Bluetooth: Add support for AR3012 [0cf3:e004]

Al Viro (1):
      vfs: umount_tree() might be called on subtree that had never made it

Alex Deucher (5):
      drm/radeon: fix XFX quirk
      drm/radeon: fix bank information in tiling config
      drm/radeon: properly program gart on rv740, juniper, cypress, barts, =
hemlock
      drm/radeon/kms: add new Palm, Sumo PCI ids
      drm/radeon/kms: add new BTC PCI ids

Andreas Dilger (1):
      ext4: disallow hard-linked directory in ext4_lookup

Andy Whitcroft (1):
      ACPI battery: only refresh the sysfs files when pertinent information=
 changes

Ben Hutchings (1):
      Linux 3.2.20

Ben Widawsky (1):
      drm/i915: Update GEN6_RP_CONTROL definitions

Benjamin Poirier (1):
      xfrm: take net hdr len into account for esp payload size calculation

Boaz Harrosh (1):
      exofs: Fix CRASH on very early IO errors.

Chris Wilson (1):
      drm/i915:: Disable FBC on SandyBridge

Clemens Ladisch (1):
      ALSA: usb-audio: fix rate_list memory leak

Daniel Vetter (3):
      drm/i915: properly handle interlaced bit for sdvo dtd conversion
      drm/i915: enable vdd when switching off the eDP panel
      drm/i915: wait for a vblank to pass after tv detect

Dave Hansen (2):
      hugetlb: fix resv_map leak in error path
      mm: fix vma_resv_map() NULL pointer

David S. Miller (2):
      ipv4: Do not use dead fib_info entries.
      Revert "net: maintain namespace isolation between vlan and real devic=
e"

David Woodhouse (1):
      solos-pci: Fix DMA support

Dmitry Kasatkin (1):
      vfs: increment iversion when a file is truncated

Dmitry Maluka (1):
      mtd: nand: fix scan_read_raw_oob

Don Zickus (1):
      Bluetooth: btusb: typo in Broadcom SoftSailing id

Eric Dumazet (1):
      asix: allow full size 8021Q frames to be received

Eric Sandeen (1):
      ext4: force ro mount if ext4_setup_super() fails

Eyal Shapira (1):
      mac80211: fix ADDBA declined after suspend with wowlan

Felix Fietkau (2):
      ath9k: fix a use-after-free-bug when ath_tx_setup_buffer() fails
      skb: avoid unnecessary reallocations in __skb_cow

Francois Romieu (2):
      r8169: missing barriers.
      r8169: fix early queue wake-up.

Frank Svendsboe (1):
      mtd: of_parts: fix breakage in Kconfig

Gao feng (1):
      ipv6: fix incorrect ipsec fragment

Grazvydas Ignotas (1):
      wl1251: fix oops on early interrupt

James Bottomley (2):
      fix TLB fault path on PA2.0 narrow systems
      fix scsi_wait_scan

James Chapman (1):
      l2tp: fix oops in L2TP IP sockets for connect() AF_UNSPEC case

James M. Leddy (1):
      Bluetooth: btusb: add support for BCM20702A0 [0a5c:21e6]

Jan-Benedict Glaw (1):
      drm/i915: no lvds quirk for HP t5740e Thin Client

Jerome Glisse (1):
      drm/radeon: fix HD6790, HD6570 backend programming

Jesse Barnes (1):
      drm/i915: always use RPNSWREQ for turbo change requests

Joel Sass (1):
      drm/i915: Add Clientron E830 to the ignore LVDS list

Joerg Roedel (2):
      iommu/amd: Add workaround for event log erratum
      iommu/amd: Cache pdev pointer to root-bridge

John David Anglin (1):
      fix boot failure on 32-bit systems caused by branch stubs placed befo=
re .text

Jonas Gorski (1):
      MIPS: BCM63XX: Add missing include for bcm63xx_gpio.h

Joonsoo Kim (1):
      slub: fix a memory leak in get_partial_node()

Jo=C3=A3o Paulo Rechi Vita (1):
      Bluetooth: btusb: Add USB device ID "0a5c 21e8"

Julien Ducourthial (1):
      r8169: fix unsigned int wraparound with TSO

Jun'ichi Nomura (1):
      Fix dm-multipath starvation when scsi host is busy

Konrad Rzeszutek Wilk (1):
      x86, amd, xen: Avoid NULL pointer paravirt references

KyongHo (1):
      mm: fix faulty initialization in vmalloc_init()

Lars-Peter Clausen (1):
      microblaze: Do not select GENERIC_GPIO by default

Manoj Iyer (2):
      Bluetooth: btusb: Add vendor specific ID (0a5c 21f3) for BCM20702A0
      Bluetooth: btusb: Add vendor specific ID (0489 e042) for BCM20702A0

Marc Gariepy (1):
      drm/i915: Ignore LVDS on hp t5745 and hp st5747 thin client

Meenakshi Venkataraman (2):
      iwlwifi: update BT traffic load states correctly
      iwlwifi: do not use shadow registers by default

Michael Gruetzner (1):
      Bluetooth: Add support for Foxconn/Hon Hai AR5BBU22 0489:E03C

Michal Hocko (1):
      mm: consider all swapped back pages in used-once logic

Minchan Kim (1):
      mm/vmalloc.c: change void* into explict vm_struct*

Nicholas Bellinger (1):
      target/file: Use O_DSYNC by default for FILEIO backends

Nicolas Dichtel (1):
      sctp: check cached dst before using it

Peter Huang (Peng) (1):
      set fake_rtable's dst to NULL to avoid kernel Oops

Richard Cochran (1):
      ixp4xx: fix compilation by adding gpiolib support

Roland Dreier (1):
      btree: fix tree corruption in btree_get_prev()

Salman Qazi (2):
      ext4: add ext4_mb_unload_buddy in the error path
      ext4: remove mb_groups before tearing down the buddy_cache

Shirish Pargaonkar (2):
      cifs: Include backup intent search flags during searches {try #2)
      cifs: fix oops while traversing open file list (try #4)

Siddhesh Poyarekar (1):
      mm/fork: fix overflow in vma length when copying mmap on clone

Stephan Gatzka (1):
      fec_mpc52xx: fix timestamp filtering

Steven Harms (1):
      Add Foxconn / Hon Hai IDs for btusb module

Tao Ma (1):
      ext4: don't set i_flags in EXT4_IOC_SETFLAGS

Theodore Ts'o (3):
      ext4: add missing save_error_info() to ext4_error()
      ext4: don't trash state flags in EXT4_IOC_SETFLAGS
      ext4: fix the free blocks calculation for ext3 file systems w/ uninit=
_bg

Thomas Hellstrom (2):
      drm/ttm: Fix spinlock imbalance
      drm/vmwgfx: Fix nasty write past alloced memory area

Trond Myklebust (2):
      sunrpc: fix loss of task->tk_status after rpc_delay call in xprt_allo=
c_slot
      NFSv4: Map NFS4ERR_SHARE_DENIED into an EACCES error instead of EIO

Ulrich Drepper (1):
      kbuild: install kernel-page-flags.h

Yanmin Zhang (1):
      ipv4: fix the rcu race between free_fib_info and ip_route_output_slow


--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-YIwS3U0e/9Vl/pfrWmov
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT9U+Vue/yOyVhhEJAQqF5Q//R195BuKVqofyuXNq+C1yQ6o7vJoW6r6Y
GF840QRFh4VC81rkF4chI6IDd3Dx3JkMQQGFlw7TkuEkkIG9/+gRhBi0GHKYMpwA
v7BDzKq1d1rPGWOOMyw8i8BQCe780FbgTFpFZ41IFcVWB8Mt+z3FijsYhxnGuiQz
g9EwRGxlSHnXuDI2bh3hM5+3ywmxhVNSwcIsw6zypQ7fsCds28tYzO1fXsmjTcGp
WkAdJiJGfmKjw0If1AMC26LUhH4dYrzxmw0M9jywcXdmVlMB1h2lHcIEcpUUgv+m
80pONIraWzIsmFscbzrLElpBUBtanC62N0qtpfB7AaRVDhfEZZeVGZcoQBun7hN2
uSVsDlgg7W95+SQqHArxkFv96at4oUVwZRz2rfk3MXNCJsSN22xsXyxXyQMFlrf4
+XdlyT3vcE9mCG0VTWTwnbjauYWLde6yLd9Zu4UC+QMJcuiav0pzt8aZNlWN02J9
ZAyq5fLReynN4OEM3cfkeiI6mQhca1xB4Jo8bUZne2vT79qZsPT5fdkG5pawT6SP
ZaRnEyG7Qs/q/8QCv28urMn3WHn1gyd1XKr0aubuXAVZeyWap8ZXnYzGwT2z2asf
k9PM2WE2mF5m5sgILphO2tK2D4qK0VpYGgwgODNmiN1iMVkXmEbDHAZpjIH/DZfA
2LrCKZSv3I4=
=gfYW
-----END PGP SIGNATURE-----

--=-YIwS3U0e/9Vl/pfrWmov--
