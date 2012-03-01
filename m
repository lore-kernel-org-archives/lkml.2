Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030275Ab2CAAkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 19:40:32 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55500 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757946Ab2CAAjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 19:39:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.134.234 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Wed, 29 Feb 2012 16:39:27 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.2.9
Message-ID: <20120301003927.GA31453@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.9 kernel.

All users of the 3.2 kernel series must upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                       |    2=20
 arch/arm/common/pl330.c                        |    3=20
 arch/arm/include/asm/assembler.h               |    5=20
 arch/arm/mach-at91/at91rm9200_devices.c        |    2=20
 arch/arm/mach-at91/at91sam9260_devices.c       |    2=20
 arch/arm/mach-at91/at91sam9261_devices.c       |    2=20
 arch/arm/mach-at91/at91sam9263_devices.c       |    2=20
 arch/arm/mach-omap2/vp.c                       |    5=20
 arch/arm/mm/cache-v7.S                         |    6=20
 arch/powerpc/kernel/perf_event.c               |    8=20
 arch/s390/kernel/time.c                        |    7=20
 arch/x86/kernel/cpu/intel_cacheinfo.c          |   44 +++-
 drivers/base/regmap/regcache.c                 |    4=20
 drivers/cdrom/cdrom.c                          |    8=20
 drivers/gpu/drm/radeon/r100.c                  |    4=20
 drivers/gpu/drm/radeon/rs600.c                 |    4=20
 drivers/hwmon/ads1015.c                        |    3=20
 drivers/hwmon/f75375s.c                        |    5=20
 drivers/hwmon/max6639.c                        |   22 +-
 drivers/infiniband/ulp/ipoib/ipoib.h           |    6=20
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   55 +----
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    9=20
 drivers/media/rc/imon.c                        |   26 ++
 drivers/media/video/hdpvr/hdpvr-video.c        |    3=20
 drivers/mmc/card/block.c                       |   82 ++++---
 drivers/net/can/sja1000/sja1000.c              |   13 +
 drivers/net/ethernet/3com/3c59x.c              |    2=20
 drivers/net/ethernet/jme.c                     |   10=20
 drivers/net/ethernet/jme.h                     |    2=20
 drivers/net/ethernet/ti/davinci_emac.c         |    6=20
 drivers/net/ethernet/via/via-velocity.c        |    3=20
 drivers/net/usb/ipheth.c                       |    5=20
 drivers/net/veth.c                             |    4=20
 drivers/net/wireless/ath/ath9k/rc.c            |    2=20
 drivers/pci/probe.c                            |    5=20
 drivers/scsi/scsi_pm.c                         |   16 +
 drivers/scsi/scsi_priv.h                       |    1=20
 drivers/scsi/scsi_scan.c                       |    4=20
 drivers/target/target_core_alua.c              |    8=20
 drivers/target/target_core_cdb.c               |   28 +-
 drivers/target/target_core_device.c            |    4=20
 drivers/target/target_core_pr.c                |   38 +--
 drivers/target/target_core_pscsi.c             |    4=20
 drivers/target/target_core_transport.c         |   45 +++-
 drivers/usb/core/hcd-pci.c                     |    5=20
 drivers/usb/core/hcd.c                         |    6=20
 drivers/usb/core/hub.c                         |   30 +-
 drivers/usb/host/pci-quirks.c                  |   11 +
 drivers/usb/host/xhci-hub.c                    |    2=20
 drivers/usb/host/xhci-mem.c                    |   32 ++-
 drivers/usb/host/xhci.c                        |    5=20
 drivers/usb/serial/cp210x.c                    |    2=20
 drivers/usb/serial/option.c                    |  143 +------------
 drivers/usb/serial/ti_usb_3410_5052.c          |    6=20
 drivers/usb/serial/ti_usb_3410_5052.h          |    4=20
 drivers/usb/storage/usb.c                      |   89 ++------
 drivers/usb/storage/usb.h                      |    7=20
 drivers/video/omap2/dss/dpi.c                  |    5=20
 fs/ecryptfs/inode.c                            |    2=20
 fs/eventpoll.c                                 |  264 ++++++++++++++++++++=
++---
 fs/namei.c                                     |    4=20
 fs/nfs/nfs4proc.c                              |   23 +-
 fs/nfs/nfs4state.c                             |    2=20
 fs/nfs/nfs4xdr.c                               |    5=20
 fs/signalfd.c                                  |   15 +
 include/asm-generic/poll.h                     |    2=20
 include/linux/eventpoll.h                      |    1=20
 include/linux/fs.h                             |    1=20
 include/linux/nfs_xdr.h                        |    2=20
 include/linux/signalfd.h                       |    5=20
 include/linux/usb/ch11.h                       |   10=20
 include/net/flow.h                             |   10=20
 include/net/route.h                            |    4=20
 include/net/sch_generic.h                      |    9=20
 include/target/target_core_base.h              |    1=20
 include/target/target_core_transport.h         |    4=20
 kernel/fork.c                                  |    5=20
 kernel/irq/autoprobe.c                         |    4=20
 kernel/irq/chip.c                              |   42 +++
 kernel/irq/internals.h                         |    2=20
 kernel/irq/manage.c                            |    2=20
 mm/nommu.c                                     |    7=20
 net/core/dev.c                                 |   10=20
 net/core/netpoll.c                             |    2=20
 net/ipv4/arp.c                                 |    3=20
 net/ipv4/ip_options.c                          |    2=20
 net/ipv4/tcp_input.c                           |   45 ++--
 net/ipv4/tcp_ipv4.c                            |    5=20
 net/mac80211/main.c                            |    4=20
 net/netfilter/ipvs/ip_vs_core.c                |    2=20
 net/sched/sch_choke.c                          |    3=20
 net/sched/sch_netem.c                          |    7=20
 net/sched/sch_sfb.c                            |    3=20
 scripts/package/builddeb                       |   12 -
 security/tomoyo/.gitignore                     |    2=20
 sound/pci/hda/patch_conexant.c                 |   11 -
 sound/pci/hda/patch_realtek.c                  |   19 +
 sound/soc/codecs/wm8962.c                      |    2=20
 98 files changed, 891 insertions(+), 533 deletions(-)

Alan Stern (2):
      usb-storage: fix freezing of the scanning thread
      scsi_pm: Fix bug in the SCSI power management handler

Alex Deucher (1):
      drm/radeon/kms: fix MSI re-arm on rv370+

Andreas Herrmann (1):
      x86/amd: Fix L1i and L2 cache sharing information for AMD family 15h =
processors

Andrew Lunn (1):
      USB: Serial: ti_usb_3410_5052: Add Abbot Diabetes Care cable id

Andy Grover (1):
      target: Allow control CDBs with data > 1 page

Anton Blanchard (1):
      powerpc/perf: power_pmu_start restores incorrect values, breaking fre=
quency events

Ben Hutchings (1):
      builddeb: Don't create files in /tmp with predictable names

Bruno Thomsen (1):
      USB: Added Kamstrup VID/PIDs to cp210x serial driver.

Chris D Schimp (2):
      hwmon: (max6639) Fix FAN_FROM_REG calculation
      hwmon: (max6639) Fix PPR register initialization to set both channels

Christian Riesch (1):
      davinci_emac: Do not free all rx dma descriptors during init

Dan Carpenter (1):
      cdrom: use copy_to_user() without the underscores

David Howells (1):
      NOMMU: Lock i_mmap_mutex for access to the VMA prio list

David Lv (1):
      via-velocity: S3 resume fix.

David S. Miller (1):
      net: Make qdisc_skb_cb upper size bound explicit.

Elric Fu (1):
      USB: Set hub depth after USB3 hub reset

Eric Dumazet (3):
      3c59x: shorten timer period for slave devices
      netpoll: netpoll_poll_dev() should access dev->flags
      gro: more generic L2 header check

Greg Kroah-Hartman (2):
      Security: tomoyo: add .gitignore file
      Linux 3.2.9

Guenter Roeck (1):
      hwmon: (ads1015) Fix file leak in probe function

Guo-Fu Tseng (1):
      jme: Fix FIFO flush issue

Hagen Paul Pfeifer (2):
      net_sched: Bug in netem reordering
      veth: Enforce minimum size of VETH_INFO_PEER

Huajun Li (1):
      scsi_scan: Fix 'Poison overwritten' warning caused by using freed 'sh=
ost'

Janne Grunau (1):
      hdpvr: fix race conditon during start of streaming

Jarod Wilson (1):
      imon: don't wedge hardware after early callbacks

Jason Baron (1):
      epoll: limit paths

Javi Merino (1):
      ARM: 7326/2: PL330: fix null pointer dereference in pl330_chan_ctrl()

Johan Rudholm (1):
      mmc: core: check for zero length ioctl data

Julian Anastasov (1):
      ipv4: reset flowi parameters on route connect

Lars-Peter Clausen (1):
      regmap: Fix cache defaults initialization from raw cache defaults

Li Wei (1):
      ipv4: Fix wrong order of ip_rt_get_source() and update iph->daddr.

Mark Brown (1):
      ASoC: wm8962: Fix sidetone enumeration texts

Martin Schwidefsky (1):
      S390: correct ktime to tod clock comparator conversion

Miklos Szeredi (1):
      vfs: fix d_inode_lookup() dentry ref leak

Mohammed Shafi Shajakhan (1):
      mac80211: Fix a rwlock bad magic bug

Neal Cardwell (3):
      tcp: allow tcp_sacktag_one() to tag ranges not aligned with skbs
      tcp: fix range tcp_shifted_skb() passes to tcp_sacktag_one()
      tcp: fix tcp_shifted_skb() adjustment of lost_cnt_hint for FACK

Nicolas Ferre (1):
      ARM: at91: USB AT91 gadget registration for module

Nikolaus Schulz (1):
      hwmon: (f75375s) Fix register write order when setting fans to full s=
peed

Oleg Nesterov (2):
      epoll: introduce POLLFREE to flush ->signalfd_wqh before kfree()
      epoll: ep_unregister_pollwait() can use the freed pwq->whead

Oliver Hartkopp (1):
      can: sja1000: fix isr hang when hw is unplugged under load

Pavel Roskin (1):
      ath9k: stop on rates with idx -1 in ath9k rate control's .tx_status

Rabin Vincent (1):
      ARM: 7325/1: fix v7 boot with lockdep enabled

Roland Dreier (1):
      IPoIB: Stop lying about hard_header_len and use skb->cb to stash LL a=
ddresses

Rui li (1):
      USB: option: cleanup zte 3g-dongle's pid in option.c

Russell King (2):
      ARM: omap: fix oops in drivers/video/omap2/dss/dpi.c
      ARM: omap: fix oops in arch/arm/mach-omap2/vp.c when pmic is not found

Sarah Sharp (5):
      USB: Remove duplicate USB 3.0 hub feature #defines.
      USB: Fix handoff when BIOS disables host PCI device.
      xhci: Fix oops caused by more USB2 ports than USB3 ports.
      xhci: Fix encoding for HS bulk/control NAK rate.
      USB: Don't fail USB3 probe on missing legacy PCI IRQ.

Shawn Lu (1):
      tcp_v4_send_reset: binding oif to iif in no sock case

Simon Horman (1):
      ipvs: fix matching of fwmark templates during scheduling

Stephen Boyd (1):
      ARM: 7321/1: cache-v7: Disable preemption when reading CCSIDR

Takashi Iwai (3):
      ALSA: hda - Fix redundant jack creations for cx5051
      ALSA: hda/realtek - Fix overflow of vol/sw check bitmap
      ALSA: hda/realtek - Fix surround output regression on Acer Aspire 5935

Thomas Gleixner (2):
      genirq: Unmask oneshot irqs when thread was not woken
      genirq: Handle pending irqs in irq_startup()

Thomas Graf (1):
      net: Don't proxy arp respond if iif =3D=3D rt->dst.dev if private VLA=
N is disabled

Tim Gardner (1):
      ipheth: Add iPhone 4S

Trond Myklebust (2):
      NFSv4: Fix an Oops in the NFSv4 getacl code
      NFSv4: Ensure we throw out bad delegation stateids on NFS4ERR_BAD_STA=
TEID

Tyler Hicks (1):
      eCryptfs: Copy up lower inode attrs after setting lower xattr

Weston Andros Adamson (1):
      NFSv4: fix server_scope memory leak

Yinghai Lu (1):
      PCI: workaround hard-wired bus number V2


--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPTsU/AAoJEDjbvchgkmk+az0QAJ5cTAUetSccK0dad83bN527
Y8x8sEGZMcPZuur3/zHemdOrisUCzc9FkKZKfBixePwqevzsCftNjiRU8dPsl/ra
PKAqkV9hVV7YsXZ5h9Gkawn7ztlzkdgg6uRcP2IqLXLnE65k8QKZ3XwnU9THCF3D
IsXxUvbhF97ONv1+m5GeXA0u2LZsrDdB5O2UawXPG0+m7V9TRc+pLKdLu8mh8ANG
29UjCUMb4F3YgT/x8RUtzDS7BntbgXcjYD6YTkM8xm3bnzndyvLllCsn+rYRin0F
80wGqqcd7wPE+jgP07nKrYO9Od/J6BskkGAAmxjiXmH4k+BmkQ7pgMYqRaqE0GBs
aV4lEmAQ9cRBlV/X2UIMiT0UOnrsSv3oP+vPBIkf0YBlFz1IWN/r6/sUpjO27v0J
3OTFP7mFN5WyV7NuUEGT2WZMNEkoGh8FFSTAM3xOU0p5ZYjSXh4q42havjNuToaM
kh1JWbD5szz98Od/bqWmQaicJ/O4VSzovJVIwXGUM5yhNzEO9UoKnsddDi35xlQv
4gAJxiLxLeRt/3IkqLxCGFEXnRGKO2H75VfpefCU+ytxqhqdKRHl3aXSYR7O6Zj0
GZDnTt+nqli5+2UuZKAFNvlN8ZwWbzKgZ5jUZ8kb2g3DUFk3L4XiZz/jmKf6ggtg
DlC9ZEDPxK4Ko1X3OMDr
=HlO2
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
