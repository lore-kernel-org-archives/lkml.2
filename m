Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab2JBSR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 14:17:57 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53012 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753767Ab2JBSRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 14:17:49 -0400
X-Sasl-enc: yz6DuqJ1CxyIMCfOPxibwf+Vbqn2JfD5fuLOjdGzSk1/ 1349201868
Date: Tue, 2 Oct 2012 11:17:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.44
Message-ID: <20121002181747.GA9108@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.44 kernel.

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

 Makefile                                 |    2=20
 arch/alpha/include/asm/atomic.h          |    4 -
 arch/arm/Kconfig                         |   52 ++++++-------
 arch/arm/boot/compressed/head.S          |    1=20
 arch/arm/include/asm/mutex.h             |  119 +-------------------------=
-----
 arch/x86/kernel/cpu/mcheck/mce.c         |    9 ++
 arch/x86/pci/fixup.c                     |   17 ++++
 arch/x86/xen/setup.c                     |    4 +
 drivers/acpi/processor_core.c            |    6 +
 drivers/ata/ahci.c                       |    2=20
 drivers/ata/libata-core.c                |    1=20
 drivers/base/power/runtime.c             |    5 -
 drivers/block/cciss_scsi.c               |    1=20
 drivers/bluetooth/btusb.c                |   10 +-
 drivers/cpufreq/powernow-k8.c            |   63 ++++++++--------
 drivers/dma/at_hdmac.c                   |   13 +++
 drivers/gpu/drm/i915/intel_hdmi.c        |    2=20
 drivers/gpu/drm/radeon/radeon_atombios.c |    2=20
 drivers/hwmon/ads7871.c                  |    9 ++
 drivers/hwmon/fam15h_power.c             |   15 +++
 drivers/hwmon/twl4030-madc-hwmon.c       |    9 +-
 drivers/input/serio/i8042-x86ia64io.h    |    6 +
 drivers/isdn/isdnloop/isdnloop.c         |   12 ---
 drivers/md/md.c                          |    9 +-
 drivers/media/rc/rc-main.c               |    5 -
 drivers/misc/sgi-xp/xpc_uv.c             |   84 ++++++++++++++++-----
 drivers/mmc/core/sd.c                    |    6 -
 drivers/mmc/host/mxs-mmc.c               |    4 -
 drivers/mmc/host/sdhci-esdhc.h           |    6 -
 drivers/mmc/host/sdhci.c                 |    5 -
 drivers/mtd/ubi/vtbl.c                   |    4 -
 drivers/net/can/janz-ican3.c             |    4 -
 drivers/net/can/mcp251x.c                |   11 ++
 drivers/net/can/ti_hecc.c                |    2=20
 drivers/net/e1000e/82571.c               |    3=20
 drivers/net/netconsole.c                 |    1=20
 drivers/net/sfc/efx.c                    |    6 +
 drivers/net/sfc/efx.h                    |   14 ++-
 drivers/net/sfc/ethtool.c                |   16 ++--
 drivers/net/sfc/nic.h                    |    5 +
 drivers/net/sfc/tx.c                     |   19 ++++
 drivers/net/usb/asix.c                   |    4 +
 drivers/net/wireless/rt2x00/rt2400pci.c  |    9 ++
 drivers/net/wireless/rt2x00/rt2400pci.h  |    1=20
 drivers/net/wireless/rt2x00/rt2500pci.c  |    9 ++
 drivers/net/wireless/rt2x00/rt2500usb.c  |   11 ++
 drivers/net/wireless/rt2x00/rt2500usb.h  |   17 ++--
 drivers/net/wireless/rt2x00/rt2800pci.c  |    9 ++
 drivers/net/wireless/rt2x00/rt2800usb.c  |    9 ++
 drivers/net/wireless/rt2x00/rt61pci.c    |    9 ++
 drivers/net/wireless/rt2x00/rt61pci.h    |    1=20
 drivers/net/wireless/rt2x00/rt73usb.c    |    9 ++
 drivers/net/wireless/rt2x00/rt73usb.h    |    3=20
 drivers/platform/x86/asus-laptop.c       |    8 +-
 drivers/platform/x86/asus-nb-wmi.c       |    4 +
 drivers/rtc/rtc-rs5c348.c                |    7 +
 drivers/rtc/rtc-twl.c                    |    5 +
 drivers/scsi/bnx2i/bnx2i_hwi.c           |    3=20
 drivers/scsi/hpsa.c                      |    3=20
 drivers/scsi/mpt2sas/mpt2sas_base.c      |    7 +
 drivers/spi/spi_fsl_spi.c                |    6 +
 drivers/staging/comedi/drivers/das08.c   |    2=20
 drivers/staging/lirc/lirc_sir.c          |   60 +++++++++++++++
 drivers/staging/rtl8712/recv_linux.c     |    7 -
 drivers/staging/speakup/main.c           |    2=20
 drivers/staging/vt6656/dpc.c             |    2=20
 drivers/staging/vt6656/rxtx.c            |   38 ++++-----
 drivers/target/target_core_transport.c   |    9 +-
 drivers/tty/serial/pch_uart.c            |   21 +++--
 drivers/usb/core/devices.c               |    2=20
 drivers/usb/core/hcd.c                   |    6 -
 drivers/usb/core/quirks.c                |    4 +
 drivers/usb/host/ehci-q.c                |   12 ++-
 drivers/usb/host/pci-quirks.c            |   42 +++++++++-
 drivers/usb/host/pci-quirks.h            |    1=20
 drivers/usb/host/xhci-ring.c             |   39 ++++++----
 drivers/usb/host/xhci.c                  |    2=20
 drivers/usb/serial/ftdi_sio.c            |   22 +++++
 drivers/usb/serial/ftdi_sio_ids.h        |   29 +++++++
 drivers/usb/serial/option.c              |    6 +
 drivers/video/console/fbcon.c            |    9 ++
 drivers/watchdog/hpwdt.c                 |    3=20
 fs/dcache.c                              |    4 -
 fs/ecryptfs/inode.c                      |    5 +
 fs/nfs/inode.c                           |    2=20
 fs/nfs/nfs3proc.c                        |    2=20
 fs/nfs/nfs4proc.c                        |    4 -
 fs/nfs/nfs4xdr.c                         |    3=20
 fs/nfs/super.c                           |    2=20
 fs/squashfs/super.c                      |    2=20
 fs/stat.c                                |    2=20
 include/asm-generic/mutex-xchg.h         |   11 ++
 include/linux/dcache.h                   |    2=20
 include/linux/init_task.h                |   12 ++-
 include/linux/kobject.h                  |    2=20
 include/linux/ktime.h                    |    7 -
 include/linux/memory.h                   |    2=20
 include/linux/netdevice.h                |    2=20
 include/linux/nfs_fs.h                   |    5 -
 include/linux/perf_event.h               |    2=20
 include/linux/sched.h                    |    5 +
 include/linux/time.h                     |   29 +++++++
 include/net/sock.h                       |    2=20
 include/trace/events/kmem.h              |    4 -
 kernel/async.c                           |   13 ++-
 kernel/events/core.c                     |   62 ++++++++--------
 kernel/exit.c                            |   16 ++++
 kernel/sched.c                           |   32 ++++----
 kernel/time/timekeeping.c                |   36 ++++++++-
 kernel/workqueue.c                       |   34 +++-----
 mm/memory_hotplug.c                      |   16 ++--
 mm/page_alloc.c                          |    2=20
 net/atm/common.c                         |    1=20
 net/atm/pvc.c                            |    1=20
 net/bluetooth/hci_sock.c                 |    2=20
 net/bluetooth/l2cap_sock.c               |    1=20
 net/bluetooth/rfcomm/sock.c              |    1=20
 net/bluetooth/rfcomm/tty.c               |    2=20
 net/core/dev.c                           |   14 ++-
 net/core/drop_monitor.c                  |  113 +++++++++++++++-----------=
---
 net/core/net_namespace.c                 |    4 -
 net/core/sock.c                          |    1=20
 net/dccp/ccids/ccid3.c                   |    1=20
 net/ipv4/ipmr.c                          |   14 +++
 net/ipv4/tcp.c                           |    4 -
 net/ipv4/tcp_cong.c                      |    3=20
 net/ipv4/tcp_output.c                    |   21 +++--
 net/ipv6/addrconf.c                      |    4 -
 net/l2tp/l2tp_core.c                     |    3=20
 net/l2tp/l2tp_core.h                     |    1=20
 net/llc/af_llc.c                         |    3=20
 net/netfilter/ipvs/ip_vs_ctl.c           |    1=20
 net/netlink/af_netlink.c                 |    4 -
 net/packet/af_packet.c                   |    1=20
 net/rds/recv.c                           |    3=20
 net/sched/act_gact.c                     |   14 ++-
 net/socket.c                             |    1=20
 net/wireless/reg.c                       |   12 ++-
 sound/pci/ice1712/prodigy_hifi.c         |    3=20
 139 files changed, 1031 insertions(+), 544 deletions(-)

AceLan Kao (1):
      asus-nb-wmi: add some video toggle keys

Al Cooper (1):
      mmc: Prevent 1.8V switch for SD hosts that don't support UHS modes.

Al Viro (1):
      perf_event: Switch to internal refcount, fix race with close()

Alan Cox (3):
      ahci: Add alternate identifier for the 88SE9172
      x86: Fix boot on Twinhead H12Y
      pch_uart: Fix missing break for 16 byte fifo

Alan Stern (2):
      USB: add device quirk for Joss Optical touchboard
      USB: Fix race condition when removing host controllers

Alexey Khoroshilov (1):
      net/core: Fix potential memory leak in dev_set_alias()

Amerigo Wang (1):
      netconsole: remove a redundant netconsole_target_put()

Andi Kleen (1):
      MCE: Fix vm86 handling for 32bit mce handler

Andreas Herrmann (1):
      hwmon: (fam15h_power) Tweak runavg_range on resume

Anisse Astier (1):
      Input: i8042 - disable mux on Toshiba C850D

Artem Bityutskiy (1):
      UBI: fix a horrible memory deallocation bug

Atsushi Nemoto (1):
      drivers/rtc/rtc-rs5c348.c: fix hour decoding in 12-hour mode

Ben Hutchings (4):
      net: Allow driver to limit number of GSO segments per skb
      sfc: Fix maximum number of TSO segments and minimum TX queue size
      tcp: Apply device TSO segment limit earlier
      ipv6: addrconf: Avoid calling netdevice notifiers with RCU read-side =
lock

Beno=EEt Locher (1):
      can: mcp251x: avoid repeated frame bug

Bj=F8rn Mork (3):
      USB: option: replace ZTE K5006-Z entry with vendor class rule
      kobject: fix oops with "input0: bad kobj_uevent_env content in show_u=
event()"
      USB: ftdi_sio: do not claim CDC ACM function

Chris Boot (1):
      e1000e: Disable ASPM L1 on 82574

Christopher Brannon (1):
      Staging: speakup: fix an improperly-declared variable.

Corentin Chary (1):
      asus-laptop: HRWS/HWRS typo

Dan Carpenter (1):
      xhci: Fix a logical vs bitwise AND bug

Daniel J Blueman (1):
      libata: Prevent interface errors with Seagate FreeAgent GoFlex

Dave Airlie (1):
      fbcon: fix race condition between console lock and cursor timer (v1.1)

Douglas Bagnall (1):
      media: Avoid sysfs oops when an rc_dev's raw device is absent

Eddie Wai (1):
      SCSI: bnx2i: Fixed NULL ptr deference for 1G bnx2 Linux iSCSI offload

Eric Dumazet (2):
      staging: r8712u: fix bug in r8712_recv_indicatepkt()
      drop_monitor: dont sleep in atomic context

Francesco Ruggeri (1):
      net: ipv4: ipmr_expire_timer causes crash when removing net namespace

Gertjan van Wingerde (2):
      rt2x00: Fix word size of rt2500usb MAC_CSR19 register.
      rt2x00: Fix rfkill polling prior to interface start.

Greg Kroah-Hartman (1):
      Linux 3.0.44

Guenter Roeck (2):
      hwmon: (twl4030-madc-hwmon) Initialize uninitialized structure elemen=
ts
      hwmon: (ads7871) Add 'name' sysfs attribute

Gustavo Padovan (1):
      Bluetooth: Use USB_VENDOR_AND_INTERFACE() for Broadcom devices

Henrik Rydberg (1):
      Bluetooth: Add support for Apple vendor-specific devices

Herton Ronaldo Krzesinski (1):
      spi/spi-fsl-spi: reference correct pdata in fsl_spi_cs_control

Hiroaki SHIMODA (1):
      net_sched: gact: Fix potential panic in tcf_gact().

Horst Schirmeier (1):
      USB: ftdi_sio: PID for NZR SEM 16+ USB

Ian Abbott (1):
      staging: comedi: das08: Correct AO output for das08jr-16-ao

Ira W. Snyder (1):
      can: janz-ican3: fix support for older hardware revisions

Jarod Wilson (1):
      media: lirc_sir: make device registration work

Jianguo Wu (1):
      mm/ia64: fix a memory block size bug

John Stultz (3):
      time: Improve sanity checking of timekeeping inputs
      time: Avoid making adjustments if we haven't accumulated anything
      time: Move ktime_t overflow checking into timespec_valid_strict

Keng-Yu Lin (1):
      Intel xhci: Only switch the switchable ports

Kenth Eriksson (1):
      spi/mpc83xx: fix NULL pdata dereference bug

Kevin Hilman (1):
      drivers/rtc/rtc-twl.c: ensure all interrupts are disabled during probe

Konrad Rzeszutek Wilk (1):
      xen/boot: Disable NUMA for PV guests.

Lai Jiangshan (1):
      workqueue: UNBOUND -> REBIND morphing in rebind_workers() should be a=
tomic

Lauri Hintsala (1):
      mmc: mxs-mmc: fix deadlock in SDIO IRQ case

Li Haifeng (1):
      mm/page_alloc: fix the page address of higher page's buddy calculation

Li Zhong (1):
      Fix a dead loop in async_synchronize_full()

Linus Torvalds (1):
      vfs: make O_PATH file descriptors usable for 'fstat()'

Luis R. Rodriguez (1):
      cfg80211: fix possible circular lock on reg_regdb_search()

Malcolm Priestley (1):
      staging: vt6656: [BUG] - Failed connection, incorrect endian.

Manoj Iyer (2):
      xhci: Recognize USB 3.0 devices as superspeed at powerup
      Bluetooth: btusb: Add vendor specific ID (0a5c:21f4) BCM20702A0

Marc Kleine-Budde (1):
      can: ti_hecc: fix oops during rmmod

Mathias Krause (11):
      atm: fix info leak in getsockopt(SO_ATMPVC)
      atm: fix info leak via getsockname()
      Bluetooth: HCI - Fix info leak in getsockopt(HCI_FILTER)
      Bluetooth: HCI - Fix info leak via getsockname()
      Bluetooth: RFCOMM - Fix info leak in ioctl(RFCOMMGETDEVLIST)
      Bluetooth: RFCOMM - Fix info leak via getsockname()
      Bluetooth: L2CAP - Fix info leak via getsockname()
      llc: fix info leak via getsockname()
      dccp: fix info leak via getsockopt(DCCP_SOCKOPT_CCID_TX_INFO)
      ipvs: fix info leak in getsockopt(IP_VS_SO_GET_TIMEOUT)
      net: fix info leak in compat dev_ifconf()

Matteo Frigo (1):
      ALSA: ice1724: Use linear scale for AK4396 volume control.

Matthew Garrett (1):
      xhci: Make handover code more robust

Matthew Leach (1):
      ARM: 7532/1: decompressor: reset SCTLR.TRE for VMSA ARMv7 cores

Mel Gorman (1):
      Redefine ATOMIC_INIT and ATOMIC64_INIT to drop the casts

Miklos Szeredi (1):
      vfs: dcache: use DCACHE_DENTRY_KILLED instead of DCACHE_DISCONNECTED =
in d_kill()

Moiz Sonasath (1):
      usb: host: xhci: fix compilation error for non-PCI based stacks

Neil Horman (3):
      drop_monitor: fix sleeping in invalid context warning
      drop_monitor: Make updating data->skb smp safe
      drop_monitor: prevent init path from scheduling on the wrong cpu

NeilBrown (1):
      md: Don't truncate size at 4TB for RAID0 and Linear

Nicholas Bellinger (1):
      target: Fix ->data_length re-assignment bug with SCSI overflow

Nicolas Ferre (2):
      dmaengine: at_hdmac: fix comment in atc_prep_slave_sg()
      dmaengine: at_hdmac: check that each sg data length is non-null

Pablo Neira Ayuso (1):
      netlink: fix possible spoofing from non-root processes

Pavankumar Kondeti (1):
      EHCI: Update qTD next pointer in QH overlay region during unlink

Peter Zijlstra (1):
      sched: Fix race in task_group()

Phillip Lougher (1):
      Squashfs: fix mount time sanity check for corrupted superblock

Rafael J. Wysocki (2):
      PM / Runtime: Fix rpm_resume() return value for power.no_callbacks set
      PM / Runtime: Clear power.deferred_resume on success in rpm_suspend()

Robin Holt (1):
      drivers/misc/sgi-xp/xpc_uv.c: SGI XPC fails to load when cpu 0 is out=
 of IRQ resources

Rustad, Mark D (1):
      net: Statically initialize init_net.dev_base_head

Sarah Sharp (1):
      xhci: Fix bug after deq ptr set to link TRB.

Shawn Guo (1):
      mmc: sdhci-esdhc: break out early if clock is 0

Stephen M. Cameron (2):
      cciss: fix handling of protocol error
      SCSI: hpsa: fix handling of protocol error

Subhash Jadavani (1):
      mmc: sd: Handle SD3.0 cards not supporting UHS-I bus speed mode

S=F8ren Holm (1):
      asix: Support DLink DUB-E100 H/W Ver C1

Tejun Heo (2):
      workqueue: reimplement work_on_cpu() using system_wq
      cpufreq/powernow-k8: workqueue user shouldn't migrate the kworker to =
another CPU

Tetsuyuki Kobayashi (1):
      ARM: fix bad applied patch for arch/arm/Kconfig of stable 3.0.y tree.

Thomas Renninger (1):
      cpufreq / ACPI: Fix not loading acpi-cpufreq driver regression

Tomoya MORINAGA (2):
      pch_uart: Fix rx error interrupt setting issue
      pch_uart: Fix parity setting issue

Toshi Kani (1):
      hpwdt: Fix kdump issue in hpwdt

Trond Myklebust (2):
      NFS: Fix the initialisation of the readdir 'cookieverf' array
      NFS: Fix a problem with the legacy binary mount code

Tvrtko Ursulin (1):
      drm/radeon/kms: extend the Fujitsu D3003-S2 board connector quirk to =
cover later silicon stepping

Tyler Hicks (1):
      eCryptfs: Copy up attributes of the lower target inode after rename

Wang Xingchao (1):
      drm/i915: HDMI - Clear Audio Enable bit for Hot Plug

Weiping Pan (1):
      rds: set correct msg_namelen

Wen Congyang (1):
      tracing: Don't call page_to_pfn() if page is NULL

Weston Andros Adamson (1):
      NFS: return error from decode_getfh in decode open

Will Deacon (2):
      mutex: Place lock in contended state after fastpath_lock failure
      ARM: 7467/1: mutex: use generic xchg-based implementation for ARMv6+

Wu Fengguang (1):
      isdnloop: fix and simplify isdnloop_init()

Yasunori Goto (1):
      sched: Fix ancient race in do_exit()

danborkmann@iogearbox.net (1):
      af_packet: remove BUG statement in tpacket_destruct_skb

qiuxishi (1):
      memory hotplug: fix section info double registration bug

sreekanth.reddy@lsi.com (1):
      SCSI: mpt2sas: Fix for issue - Unable to boot from the drive connecte=
d to HBA

xeb@mail.ru (1):
      l2tp: avoid to use synchronize_rcu in tunnel free function

=C9ric Piel (1):
      USB: ftdi-sio: add support for more Physik Instrumente devices


--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQay/LAAoJEDjbvchgkmk+cEUP/3kBtKUd0bnqMupIn8jW06/Z
/Lkk5UGzVRPvTe95U64aP5bnyrYYR0D2U2A3/6L5DXWGsxlvYMWwDydOxei2TMLW
lJr4OWbG7LfrSjfcPkJlwyrONxfSQp0RdZpGlvBoGC+tKKHt2nOGzBDfVTSVLgGQ
9S1n2/VBKNSghUAmWW4p2IDWKGxDE/mo9TFTP8jlgaWzf4/8Abv5VT4sZ896IprI
EHxU/XtyLKoXociKTluTaD1IBpw6o5OBezy1GLuXnyp+RZdBqlA+pY2PZqb2AWyG
ljYbyd7Zhv0gzUaC1WWFJqZHeJ7tnW3ToDEi4Bbg9tVjy8mSqMN2802wOfSU0FMV
B8VBqSLJyNrslDH91VDoTcJS/6RkBgmCh0NkexCw8t4yN/xb+9wgP8VSbX/jUu68
eGjOrzs81AQZjYBRu03Jvn9fU6cjaE2Z+6NWwMmiqiiVOPyAaVkRgDbr9ikkHI9k
ioF3r1Nr06LJvd+yu/ihZ2v3kmsSb8kkZVlrBGenUxIqXZf1iKhtauZ5bLMRhz+g
UaRJ44hqQPq/Z5e1f8hXKzMXUETKaqcr+MdKsu9mPqyjGJlqtVgpSnY5cMQSx6kc
RSIzFk9LuAkr1QXZKzQId+jHpCzUJ+ndJBDrwzUWKVyyLNTvVlImQAqGzllOchZP
s2DYhgcNLRIoNd1jYIkg
=Bl5J
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
