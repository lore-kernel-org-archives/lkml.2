Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab2JJOaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 10:30:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36138 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932084Ab2JJOaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 10:30:07 -0400
Message-ID: <1349879393.6336.41.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.31
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Wed, 10 Oct 2012 15:29:53 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-e3Yt3uF8vi6mWpSjSK7Y"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-e3Yt3uF8vi6mWpSjSK7Y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.31 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

Ben.

------------

 Makefile                                           |    2 +-
 arch/arm/boot/compressed/head.S                    |    1 +
 arch/x86/kernel/alternative.c                      |    2 +-
 arch/x86/xen/enlighten.c                           |    4 +
 arch/x86/xen/setup.c                               |    4 +
 drivers/ata/libata-core.c                          |    1 +
 drivers/block/aoe/aoecmd.c                         |    1 +
 drivers/block/cciss_scsi.c                         |    1 +
 drivers/block/nbd.c                                |    9 ++
 drivers/bluetooth/ath3k.c                          |    7 ++
 drivers/bluetooth/btusb.c                          |   14 ++-
 drivers/cpufreq/powernow-k8.c                      |   63 +++++-----
 drivers/dma/at_hdmac.c                             |   13 +-
 drivers/dma/pl330.c                                |    5 +
 drivers/edac/sb_edac.c                             |    7 +-
 drivers/gpio/gpio-lpc32xx.c                        |    5 +
 drivers/gpu/drm/i915/i915_gem.c                    |    3 +-
 drivers/gpu/drm/i915/intel_hdmi.c                  |    2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c             |  126 ++++------------=
----
 drivers/hid/hid-core.c                             |   16 ++-
 drivers/hid/hid-logitech-dj.c                      |   83 ++++++++++---
 drivers/hid/hid-logitech-dj.h                      |    1 +
 drivers/hid/hidraw.c                               |  107 +++++++++-------=
-
 drivers/hwmon/ad7314.c                             |    8 ++
 drivers/hwmon/ads7871.c                            |    9 ++
 drivers/hwmon/fam15h_power.c                       |   15 ++-
 drivers/input/serio/i8042-x86ia64io.h              |    6 +
 drivers/iommu/intr_remapping.c                     |   18 ++-
 drivers/md/dm-table.c                              |   26 +++-
 drivers/md/dm.c                                    |   56 ++++++---
 drivers/md/raid10.c                                |    8 +-
 drivers/mmc/host/sdhci.c                           |    5 +-
 drivers/net/can/janz-ican3.c                       |    4 +-
 drivers/net/can/ti_hecc.c                          |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   12 +-
 drivers/net/ethernet/broadcom/tg3.c                |   14 ++-
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |    4 +
 drivers/net/ethernet/ti/davinci_cpdma.c            |    1 +
 drivers/net/ppp/pppoe.c                            |    2 +-
 drivers/net/usb/asix.c                             |    4 +
 drivers/net/usb/sierra_net.c                       |    2 +-
 drivers/net/wan/ixp4xx_hss.c                       |    1 +
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   26 ++--
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    6 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/def.h       |    1 +
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c        |   12 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c        |    8 +-
 drivers/pci/hotplug/acpiphp_glue.c                 |   13 +-
 drivers/platform/x86/asus-laptop.c                 |    8 +-
 drivers/rtc/rtc-twl.c                              |    5 +
 drivers/scsi/bnx2i/bnx2i_hwi.c                     |    3 +
 drivers/scsi/hpsa.c                                |    3 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c                |    7 ++
 drivers/target/target_core_transport.c             |    9 +-
 drivers/tty/serial/pch_uart.c                      |   19 ++-
 drivers/usb/core/devices.c                         |    2 +-
 drivers/usb/core/hcd.c                             |    6 +-
 drivers/usb/gadget/dummy_hcd.c                     |    8 +-
 drivers/watchdog/hpwdt.c                           |    3 +
 fs/cifs/cifs_unicode.c                             |    2 +-
 fs/dcache.c                                        |   10 +-
 fs/proc/proc_sysctl.c                              |    5 +-
 include/linux/dcache.h                             |    2 +
 include/linux/hid.h                                |    2 +-
 include/linux/hidraw.h                             |    4 +-
 include/linux/memory.h                             |    2 +-
 include/linux/xfrm.h                               |    2 +
 include/net/bluetooth/smp.h                        |    2 +-
 include/net/xfrm.h                                 |    3 +
 include/trace/events/kmem.h                        |    4 +-
 kernel/async.c                                     |   13 +-
 kernel/cpuset.c                                    |    3 +
 kernel/exit.c                                      |   16 +++
 kernel/sched.c                                     |   40 ++++++-
 kernel/workqueue.c                                 |   25 ++--
 mm/memory_hotplug.c                                |   16 ++-
 mm/page_alloc.c                                    |    2 +-
 net/8021q/vlan_core.c                              |    3 +-
 net/bluetooth/hci_conn.c                           |    4 +
 net/bluetooth/l2cap_core.c                         |   11 +-
 net/bluetooth/l2cap_sock.c                         |    2 +-
 net/bluetooth/smp.c                                |    4 +-
 net/core/dev.c                                     |   15 ++-
 net/core/net_namespace.c                           |    4 +-
 net/core/sock.c                                    |    3 +-
 net/ipv4/raw.c                                     |   14 ++-
 net/ipv4/tcp.c                                     |   10 +-
 net/ipv6/mip6.c                                    |   20 ++--
 net/ipv6/raw.c                                     |   21 ++--
 net/ipv6/route.c                                   |   11 +-
 net/l2tp/l2tp_eth.c                                |    2 +-
 net/netrom/af_netrom.c                             |    7 +-
 net/rds/recv.c                                     |    3 +
 net/sched/sch_cbq.c                                |    5 +-
 net/sched/sch_qfq.c                                |    5 +-
 net/sctp/output.c                                  |   21 +++-
 net/wireless/reg.c                                 |   12 +-
 net/xfrm/xfrm_input.c                              |    2 +-
 net/xfrm/xfrm_policy.c                             |    2 +-
 net/xfrm/xfrm_replay.c                             |   15 +++
 net/xfrm/xfrm_user.c                               |   57 ++++++---
 sound/soc/samsung/dma.c                            |    8 +-
 102 files changed, 793 insertions(+), 434 deletions(-)

Al Cooper (1):
      mmc: Prevent 1.8V switch for SD hosts that don't support UHS modes.

Alan Cox (2):
      dj: memory scribble in logi_dj
      netrom: copy_datagram_iovec can fail

Alan Stern (1):
      USB: Fix race condition when removing host controllers

Alex Deucher (1):
      Revert "drm/radeon: rework pll selection (v3)"

Alexey Khoroshilov (1):
      HID: hidraw: improve error handling in hidraw_init()

Andreas Herrmann (1):
      hwmon: (fam15h_power) Tweak runavg_range on resume

Anisse Astier (1):
      Input: i8042 - disable mux on Toshiba C850D

Antonio Quartulli (1):
      8021q: fix mac_len recomputation in vlan_untag()

Avi Kivity (1):
      x86/alternatives: Fix p6 nops on non-modular kernels

Ben Hutchings (1):
      Linux 3.2.31

Bjorn Helgaas (1):
      PCI: acpiphp: check whether _ADR evaluation succeeded

Chema Gonzalez (1):
      net: small bug on rxhash calculation

Chris Wilson (1):
      drm/i915: Reduce a pin-leak BUG into a WARN

Corentin Chary (1):
      asus-laptop: HRWS/HWRS typo

Daniel J Blueman (1):
      Prevent interface errors with Seagate FreeAgent GoFlex

Darren Hart (1):
      pch_uart: Add eg20t_port lock field, avoid recursive spinlocks

Dylan Reid (1):
      ASoC: samsung dma - Don't indicate support for pause/resume.

Ed L. Cashin (2):
      net: do not disable sg for packets requiring no checksum
      aoe: assert AoE packets marked as requiring no checksum

Eddie Wai (1):
      bnx2i: Fixed NULL ptr deference for 1G bnx2 Linux iSCSI offload

Eric Dumazet (6):
      net-sched: sch_cbq: avoid infinite loop
      net: guard tcp_set_keepalive() to tcp sockets
      ipv4: raw: fix icmp_filter()
      ipv6: raw: fix icmpv6_filter()
      ipv6: mip6: fix mip6_mh_filter()
      l2tp: fix a typo in l2tp_eth_dev_recv()

Florian Fainelli (1):
      ixp4xx_hss: fix build failure due to missing linux/module.h inclusion

Francesco Ruggeri (1):
      fs/proc: fix potential unregister_sysctl_table hang

Gao feng (1):
      ipv6: release reference of ip6_null_entry's dst entry in __ip6_del_rt

Giancarlo Formicuccia (1):
      Bluetooth: add support for atheros 0930:0219

Guenter Roeck (2):
      hwmon: (ads7871) Add 'name' sysfs attribute
      hwmon: (ad7314) Add 'name' sysfs attribute

Gustavo Padovan (1):
      Bluetooth: Use USB_VENDOR_AND_INTERFACE() for Broadcom devices

Hante Meuleman (2):
      brcmfmac: fix big endian bug in i-scan.
      brcmfmac: Fix big endian host configuration data.

Henrik Rydberg (1):
      Bluetooth: Add support for Apple vendor-specific devices

Ira W. Snyder (1):
      can: janz-ican3: fix support for older hardware revisions

Jeff Layton (1):
      cifs: fix return value in cifsConvertToUTF16

Jianguo Wu (1):
      mm/ia64: fix a memory block size bug

Jiri Kosina (2):
      HID: hidraw: add proper error handling to raw event reporting
      HID: fix return value of hidraw_report_event() when !CONFIG_HIDRAW

Kevin Hilman (1):
      drivers/rtc/rtc-twl.c: ensure all interrupts are disabled during prob=
e

Konrad Rzeszutek Wilk (2):
      xen/boot: Disable BIOS SMP MP table search.
      xen/boot: Disable NUMA for PV guests.

Larry Finger (1):
      rtlwifi: rtl8192ce: Log message that B_CUT device may not work

Lennart Sorensen (1):
      sierra_net: Endianess bug fix.

Li Haifeng (1):
      mm/page_alloc: fix the page address of higher page's buddy calculatio=
n

Li RongQing (1):
      xfrm: fix a read lock imbalance in make_blackhole

Li Zhong (1):
      Fix a dead loop in async_synchronize_full()

Luis R. Rodriguez (1):
      cfg80211: fix possible circular lock on reg_regdb_search()

Manoj Iyer (1):
      Bluetooth: btusb: Add vendor specific ID (0a5c:21f4) BCM20702A0

Marc Dionne (1):
      HID: logitech: don't use stack based dj_report structures

Marc Kleine-Budde (1):
      can: ti_hecc: fix oops during rmmod

Marek Vasut (1):
      Bluetooth: Support AR3011 in Acer Iconia Tab W500

Mathias Krause (8):
      xfrm_user: return error pointer instead of NULL
      xfrm_user: return error pointer instead of NULL #2
      xfrm_user: fix info leak in copy_to_user_auth()
      xfrm_user: fix info leak in copy_to_user_state()
      xfrm_user: fix info leak in copy_to_user_policy()
      xfrm_user: fix info leak in copy_to_user_tmpl()
      xfrm_user: don't copy esn replay window twice for new states
      xfrm_user: ensure user supplied esn replay window is valid

Matt Carlson (1):
      tg3: Fix TSO CAP for 5704 devs w / ASF enabled

Matthew Leach (1):
      ARM: 7532/1: decompressor: reset SCTLR.TRE for VMSA ARMv7 cores

Matthieu CASTET (1):
      HID: hidraw: fix list->buffer memleak

Mauro Carvalho Chehab (1):
      sb_edac: Avoid overflow errors at memory size calculation

Michal Kube=C4=8Dek (1):
      tcp: flush DMA queue before sk_wait_data if rcv_wnd is zero

Michal Schmidt (1):
      bnx2x: fix rx checksum validation for IPv6

Mike Snitzer (1):
      dm: handle requests beyond end of device instead of using BUG_ON

Miklos Szeredi (2):
      vfs: dcache: use DCACHE_DENTRY_KILLED instead of DCACHE_DISCONNECTED =
in d_kill()
      vfs: dcache: fix deadlock in tree traversal

Milan Broz (1):
      dm table: clear add_random unless all devices have it set

NeilBrown (1):
      md/raid10: fix "enough" function for detecting if array is failed.

Nestor Lopez Casado (2):
      HID: logitech: fix mask to enable DJ mode
      HID: Fix logitech-dj: missing Unifying device issue

Nicholas Bellinger (1):
      target: Fix ->data_length re-assignment bug with SCSI overflow

Nicolas Ferre (2):
      dmaengine: at_hdmac: fix comment in atc_prep_slave_sg()
      dmaengine: at_hdmac: check that each sg data length is non-null

Nikolay Aleksandrov (1):
      netxen: check for root bus in netxen_mask_aer_correctable

Paolo Valente (1):
      pkt_sched: fix virtual-start-time update in QFQ

Paul Clements (1):
      nbd: clear waiting_queue on shutdown

Peng Chen (1):
      Bluetooth: add support for atheros 0489:e057

Ratan Nalumasu (1):
      HID: hidraw: don't deallocate memory when it is in use

Roland Stigge (1):
      gpio-lpc32xx: Fix value handling of gpio_direction_output()

Rustad, Mark D (1):
      net: Statically initialize init_net.dev_base_head

Sachin Kamat (1):
      DMA: PL330: Check the pointer returned by kzalloc

Sebastian Andrzej Siewior (1):
      usb: gadget: dummy_hcd: fixup error probe path

Seth Forshee (1):
      irq_remap: disable IRQ remapping if any IOAPIC lacks an IOMMU

Srivatsa S. Bhat (1):
      CPU hotplug, cpusets, suspend: Don't modify cpusets during suspend/re=
sume

Steffen Klassert (1):
      xfrm: Workaround incompatibility of ESN and async crypto

Stephen M. Cameron (2):
      cciss: fix handling of protocol error
      hpsa: fix handling of protocol error

S=C3=B8ren holm (1):
      asix: Support DLink DUB-E100 H/W Ver C1

Tejun Heo (2):
      workqueue: reimplement work_on_cpu() using system_wq
      cpufreq/powernow-k8: workqueue user shouldn't migrate the kworker to =
another CPU

Thomas Graf (1):
      sctp: Don't charge for data in sndbuf again when transmitting packet

Toshi Kani (1):
      hpwdt: Fix kdump issue in hpwdt

Vinicius Costa Gomes (2):
      Bluetooth: Change signature of smp_conn_security()
      Bluetooth: Fix sending a HCI Authorization Request over LE links

Wang Xingchao (1):
      drm/i915: HDMI - Clear Audio Enable bit for Hot Plug

Weiping Pan (1):
      rds: set correct msg_namelen

Wen Congyang (1):
      tracing: Don't call page_to_pfn() if page is NULL

Xiaodong Xu (1):
      pppoe: drop PPPOX_ZOMBIEs in pppoe_release

Yasunori Goto (1):
      sched: Fix ancient race in do_exit()

Yevgeniy Melnichuk (1):
      Bluetooth: Add support for Sony Vaio T-Series

htbegin (1):
      net: ethernet: davinci_cpdma: decrease the desc count when cleaning u=
p the remaining packets

qiuxishi (1):
      memory hotplug: fix section info double registration bug

sreekanth.reddy@lsi.com (1):
      mpt2sas: Fix for issue - Unable to boot from the drive connected to H=
BA



--=-e3Yt3uF8vi6mWpSjSK7Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUHWGYee/yOyVhhEJAQrffhAA0mv2+JHGwh6fSJrYwecLwi2KmyXVeFuJ
pef4ET2RigCDjGkiivxsclgMwL52QLWp3f4e7TCDzFGmFqSkV5lLSVcKBhEpKC7P
m0in7/F2Mp1uyHaFkq/NqiI5uOE6KncdW6j+0Uhqvie4TTV+hoY/7nBqA+PFB9hL
+p+GdlpoBnqStI8cFJgKcvs/Q/llW57THxTtFEVi9ZWwhOapvC9hL90EW9OJoWz3
Qm1KYCB3mFQOKcVCyiK/b1+NVEO0OCMEuY0kBEPrIP7yCcRvRLgBq1Yi3jxk7KI4
J/das2No4rybJdrsPI0gPHTGDnanEcI7ME/NOgaIFyrifYdPH08UZSSdbJVJ+2P8
OGlXtYrx4diy/HIqxsglmGKhzI4O9az+7QlA4ta/Pc9XQqFd9BR5VRgrsn/e9G+r
D8+GMQiuBYrwMLJ6lAhWC4nzUv0QViAKoz8jKMDSPiU9efKLvSdlcY+YSSKjryB6
U0QgDTaWTUgmQbeOzXR9eFtLNkkM2IN2b8cGrdrLg4RUECk6zgh1h2BG3Yg91cq3
R11JZQoErdIz3/qcgYBNUA0oqNGrwNwsWxsuKK9an1bvDxkHZ9+p3Q/SdOJqkZ9h
H1m7qe0VudTMJF8lL+8iht2yaBF/woUMewwENnKtX6DrEajpeVF5tRa1t+tJqbAg
txltlnBG/aE=
=by3g
-----END PGP SIGNATURE-----

--=-e3Yt3uF8vi6mWpSjSK7Y--
