Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab2CAAjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 19:39:51 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:41574 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757900Ab2CAAjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 19:39:47 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.129.166 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Wed, 29 Feb 2012 16:38:35 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.23
Message-ID: <20120301003835.GA31431@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.23 kernel.

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

 Makefile                                       |    2=20
 arch/arm/include/asm/assembler.h               |    5=20
 arch/arm/mm/cache-v7.S                         |    6=20
 arch/powerpc/kernel/perf_event.c               |    8=20
 arch/x86/include/asm/i387.h                    |  284 ++++++++++++++++++++=
-----
 arch/x86/include/asm/processor.h               |    1=20
 arch/x86/include/asm/thread_info.h             |    2=20
 arch/x86/kernel/cpu/intel_cacheinfo.c          |   44 +++
 arch/x86/kernel/process_32.c                   |   25 --
 arch/x86/kernel/process_64.c                   |   29 --
 arch/x86/kernel/traps.c                        |   41 ++-
 arch/x86/kernel/xsave.c                        |   12 -
 arch/x86/kvm/vmx.c                             |    2=20
 drivers/cdrom/cdrom.c                          |    8=20
 drivers/gpu/drm/radeon/r100.c                  |    4=20
 drivers/gpu/drm/radeon/rs600.c                 |    4=20
 drivers/hwmon/ads1015.c                        |    3=20
 drivers/hwmon/f75375s.c                        |    5=20
 drivers/hwmon/max6639.c                        |   22 +
 drivers/infiniband/ulp/ipoib/ipoib.h           |    6=20
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   55 +---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    9=20
 drivers/media/video/hdpvr/hdpvr-video.c        |    3=20
 drivers/mmc/card/block.c                       |   82 +++----
 drivers/net/3c59x.c                            |    2=20
 drivers/net/davinci_emac.c                     |    6=20
 drivers/net/jme.c                              |   10=20
 drivers/net/jme.h                              |    2=20
 drivers/net/usb/ipheth.c                       |    5=20
 drivers/net/veth.c                             |    4=20
 drivers/net/via-velocity.c                     |    3=20
 drivers/net/wireless/ath/ath9k/rc.c            |    2=20
 drivers/pci/probe.c                            |    5=20
 drivers/scsi/scsi_pm.c                         |   16 +
 drivers/scsi/scsi_priv.h                       |    1=20
 drivers/scsi/scsi_scan.c                       |    4=20
 drivers/usb/core/hcd-pci.c                     |    5=20
 drivers/usb/core/hcd.c                         |    6=20
 drivers/usb/core/hub.c                         |   30 +-
 drivers/usb/host/pci-quirks.c                  |   11=20
 drivers/usb/host/xhci-hub.c                    |    2=20
 drivers/usb/host/xhci-mem.c                    |   32 ++
 drivers/usb/host/xhci.c                        |    5=20
 drivers/usb/serial/cp210x.c                    |    2=20
 drivers/usb/serial/option.c                    |  143 +-----------
 drivers/usb/serial/ti_usb_3410_5052.c          |    6=20
 drivers/usb/serial/ti_usb_3410_5052.h          |    4=20
 drivers/usb/storage/usb.c                      |   89 ++-----
 drivers/usb/storage/usb.h                      |    7=20
 fs/ecryptfs/inode.c                            |    2=20
 fs/eventpoll.c                                 |  264 ++++++++++++++++++++=
---
 fs/nfs/nfs4state.c                             |    2=20
 fs/signalfd.c                                  |   15 +
 include/asm-generic/poll.h                     |    2=20
 include/linux/eventpoll.h                      |    1=20
 include/linux/fs.h                             |    1=20
 include/linux/signalfd.h                       |    5=20
 include/linux/usb/ch11.h                       |   10=20
 include/net/flow.h                             |   10=20
 include/net/inet_sock.h                        |    2=20
 include/net/route.h                            |    4=20
 include/net/sch_generic.h                      |    9=20
 kernel/fork.c                                  |    5=20
 kernel/irq/autoprobe.c                         |    4=20
 kernel/irq/chip.c                              |   42 ++-
 kernel/irq/internals.h                         |    2=20
 kernel/irq/manage.c                            |    2=20
 mm/nommu.c                                     |    7=20
 net/core/dev.c                                 |   10=20
 net/core/netpoll.c                             |    2=20
 net/ipv4/arp.c                                 |    3=20
 net/ipv4/ip_forward.c                          |    2=20
 net/ipv4/ip_options.c                          |    4=20
 net/ipv4/route.c                               |   97 +++++---
 net/ipv4/tcp_input.c                           |   45 ++-
 net/ipv4/tcp_ipv4.c                            |    5=20
 net/ipv6/ip6mr.c                               |    8=20
 net/mac80211/main.c                            |    4=20
 net/netfilter/ipvs/ip_vs_core.c                |    2=20
 net/sched/sch_choke.c                          |    3=20
 net/sched/sch_netem.c                          |    7=20
 net/sched/sch_sfb.c                            |    3=20
 scripts/package/builddeb                       |   12 -
 sound/pci/hda/patch_conexant.c                 |   11=20
 sound/soc/codecs/wm8962.c                      |    2=20
 85 files changed, 1061 insertions(+), 612 deletions(-)

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

Anton Blanchard (1):
      powerpc/perf: power_pmu_start restores incorrect values, breaking fre=
quency events

Ben Greear (2):
      ipv6-multicast: Fix memory leak in input path.
      ipv6-multicast: Fix memory leak in IPv6 multicast.

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

David S. Miller (1):
      net: Make qdisc_skb_cb upper size bound explicit.

Elric Fu (1):
      USB: Set hub depth after USB3 hub reset

Eric Dumazet (4):
      gro: more generic L2 header check
      3c59x: shorten timer period for slave devices
      netpoll: netpoll_poll_dev() should access dev->flags
      ipv4: fix redirect handling

Flavio Leitner (1):
      route: fix ICMP redirect validation

Greg Kroah-Hartman (1):
      Linux 3.0.23

Guenter Roeck (1):
      hwmon: (ads1015) Fix file leak in probe function

Guo-Fu Tseng (1):
      jme: Fix FIFO flush issue

Hagen Paul Pfeifer (2):
      net_sched: Bug in netem reordering
      via-velocity: S3 resume fix.

Huajun Li (1):
      scsi_scan: Fix 'Poison overwritten' warning caused by using freed 'sh=
ost'

Janne Grunau (1):
      hdpvr: fix race conditon during start of streaming

Jason Baron (1):
      epoll: limit paths

Johan Rudholm (1):
      mmc: core: check for zero length ioctl data

Julian Anastasov (1):
      ipv4: reset flowi parameters on route connect

Li Wei (3):
      ipv4: fix for ip_options_rcv_srr() daddr update.
      ipv4: Save nexthop address of LSRR/SSRR option to IPCB.
      ipv4: Fix wrong order of ip_rt_get_source() and update iph->daddr.

Linus Torvalds (10):
      i387: math_state_restore() isn't called from asm
      i387: make irq_fpu_usable() tests more robust
      i387: fix sense of sanity check
      i387: fix x86-64 preemption-unsafe user stack save/restore
      i387: move TS_USEDFPU clearing out of __save_init_fpu and into callers
      i387: don't ever touch TS_USEDFPU directly, use helper functions
      i387: do not preload FPU state at task switch time
      i387: move AMD K7/K8 fpu fxsave/fxrstor workaround from save to resto=
re
      i387: move TS_USEDFPU flag from thread_info to task_struct
      i387: re-introduce FPU state preloading at context switch time

Mark Brown (1):
      ASoC: wm8962: Fix sidetone enumeration texts

Mohammed Shafi Shajakhan (1):
      mac80211: Fix a rwlock bad magic bug

Neal Cardwell (3):
      tcp: allow tcp_sacktag_one() to tag ranges not aligned with skbs
      tcp: fix range tcp_shifted_skb() passes to tcp_sacktag_one()
      tcp: fix tcp_shifted_skb() adjustment of lost_cnt_hint for FACK

Nikolaus Schulz (1):
      hwmon: (f75375s) Fix register write order when setting fans to full s=
peed

Oleg Nesterov (2):
      epoll: introduce POLLFREE to flush ->signalfd_wqh before kfree()
      epoll: ep_unregister_pollwait() can use the freed pwq->whead

Pavel Roskin (1):
      ath9k: stop on rates with idx -1 in ath9k rate control's .tx_status

Rabin Vincent (1):
      ARM: 7325/1: fix v7 boot with lockdep enabled

Roland Dreier (1):
      IPoIB: Stop lying about hard_header_len and use skb->cb to stash LL a=
ddresses

Rui li (1):
      USB: option: cleanup zte 3g-dongle's pid in option.c

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

Takashi Iwai (1):
      ALSA: hda - Fix redundant jack creations for cx5051

Thomas Gleixner (2):
      genirq: Unmask oneshot irqs when thread was not woken
      genirq: Handle pending irqs in irq_startup()

Thomas Graf (2):
      veth: Enforce minimum size of VETH_INFO_PEER
      net: Don't proxy arp respond if iif =3D=3D rt->dst.dev if private VLA=
N is disabled

Tim Gardner (1):
      ipheth: Add iPhone 4S

Trond Myklebust (1):
      NFSv4: Ensure we throw out bad delegation stateids on NFS4ERR_BAD_STA=
TEID

Tyler Hicks (1):
      eCryptfs: Copy up lower inode attrs after setting lower xattr

Yinghai Lu (1):
      PCI: workaround hard-wired bus number V2


--gKMricLos+KVdGMg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPTsULAAoJEDjbvchgkmk+99EQAMyZDUhUOm35o3qA2tWWxZZb
RxtuqgZ47+WWXyV46Fb9mD0GnRSL1P/WPDXWl2SH+13+HGKvBLAnhJHywyAtalU0
Fy42Fi3Zu4DZAGEaJP60Pm55Wov9BOOkGbCpwxxkDjwP7NEdFUUrgx81POPOpYCi
5j9INip6BB3N25rp462s66WpjVdXeO0Ei+07Giu3ASi5fNZANOSvZvT5LVSwn8ta
N0p83IZ6ZPPexcfXSSqvAgEOf7pTDdUJOi+6mvekNKYMvNRgaQT3ukAfnVV5wRAs
UBjBUPU3DkLRldkj8IxD59n8wRM/aQoXIsUCAs2R6w7oQb/5eRQinzrttBpD34qX
x7yMZLC4DVQvFH4qpJjyAG98t380h1lfhjvA0vjCfFwVpCf2KavYyOhEbaj4LxFW
G4bv1H+Y5KWvFVvd1bKumL5CekWTf2cfc0Ie5O6XGWgl86ysu1w2sJgNIaHUCOEN
iXUPALKxKEAscwTBj8gFqhKo0urNOEYp7XqNtQPHYsbf1Sm4d91WlWCxYNKIl0MF
3JO4t7DE8qMClri4OCVK8AAfeZHVkRasi9WOTjw/FUfqiseTQ3xdrtnPZLX5/+kB
++rgXc26YgGHDA8l+eAscuWsArakObLGieP9OajkxhWWynCNCDnTkrq9N0ya2aSy
hLEDqvVUSHEgMA0H0nvs
=9HxV
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
