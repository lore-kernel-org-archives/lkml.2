Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423603Ab2LGBXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:23:47 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48893 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423341Ab2LGBXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 20:23:45 -0500
Message-ID: <1354843413.20838.23.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.35
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Fri, 07 Dec 2012 01:23:33 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-PDPkkSQVy7reQRcXLsDy"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PDPkkSQVy7reQRcXLsDy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.35 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

Ben.

------------

 Documentation/cgroups/memory.txt                |    4 ++
 Documentation/dvb/get_dvb_firmware              |    2 +-
 Makefile                                        |    2 +-
 arch/arm/Kconfig                                |    1 +
 arch/arm/mach-dove/include/mach/pm.h            |    2 +-
 arch/arm/mach-dove/irq.c                        |   14 ++++-
 arch/arm/mach-kirkwood/pcie.c                   |   11 +++-
 arch/m68k/include/asm/signal.h                  |    6 +-
 arch/parisc/kernel/signal32.c                   |    6 +-
 arch/parisc/kernel/sys_parisc.c                 |    2 +
 arch/s390/include/asm/compat.h                  |    2 +-
 arch/s390/include/asm/ptrace.h                  |    4 +-
 arch/s390/kernel/compat_signal.c                |   14 ++++-
 arch/s390/kernel/signal.c                       |   14 ++++-
 arch/s390/mm/gup.c                              |    2 +-
 arch/sparc/kernel/signal_64.c                   |    4 +-
 arch/x86/include/asm/ptrace.h                   |   15 ++---
 arch/x86/kernel/cpu/amd.c                       |   14 +++++
 arch/x86/kernel/cpu/mcheck/therm_throt.c        |   29 +++-------
 arch/x86/kernel/microcode_amd.c                 |    4 ++
 arch/x86/kernel/ptrace.c                        |   30 ++++++++++
 arch/x86/kernel/setup.c                         |   17 +++++-
 arch/x86/mm/init.c                              |   67 +++++++++++++------=
----
 block/blk-exec.c                                |    9 ++-
 drivers/gpu/drm/i915/i915_drv.h                 |    2 +
 drivers/gpu/drm/i915/intel_bios.c               |   36 ++++++++++++
 drivers/gpu/drm/i915/intel_display.c            |   30 ++++++++--
 drivers/gpu/drm/i915/intel_sdvo.c               |   22 +++++++-
 drivers/gpu/drm/radeon/atombios_encoders.c      |    2 +-
 drivers/gpu/drm/radeon/evergreen.c              |    2 +
 drivers/gpu/drm/radeon/radeon_agp.c             |    5 +-
 drivers/gpu/drm/ttm/ttm_page_alloc.c            |    5 +-
 drivers/hid/hid-ids.h                           |    3 +
 drivers/hid/usbhid/hid-quirks.c                 |    1 +
 drivers/idle/intel_idle.c                       |   37 +++++++++++++
 drivers/input/mouse/bcm5974.c                   |    3 +
 drivers/input/serio/i8042.c                     |   23 +++++---
 drivers/isdn/gigaset/bas-gigaset.c              |   19 ++++++-
 drivers/md/dm.c                                 |    8 ++-
 drivers/md/md.c                                 |   11 ++--
 drivers/mtd/devices/slram.c                     |    2 +-
 drivers/mtd/ofpart.c                            |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c  |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c   |    3 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h   |    2 +
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c |    6 +-
 drivers/net/wireless/mwifiex/cmdevt.c           |   11 +++-
 drivers/net/wireless/mwifiex/sdio.c             |   11 ++--
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c     |    1 +
 drivers/pci/setup-bus.c                         |    4 +-
 drivers/pci/setup-res.c                         |    5 +-
 drivers/platform/x86/acer-wmi.c                 |    1 +
 drivers/scsi/isci/request.c                     |    2 +-
 drivers/usb/host/xhci-ring.c                    |    7 +--
 drivers/usb/host/xhci.c                         |    8 +--
 drivers/usb/serial/option.c                     |    9 +++
 drivers/usb/serial/usb-serial.c                 |    6 +-
 drivers/watchdog/iTCO_wdt.c                     |   35 ++++++++++++
 fs/gfs2/lops.c                                  |   18 ++----
 fs/gfs2/trans.c                                 |    8 +++
 fs/jbd/transaction.c                            |    2 +
 fs/jffs2/file.c                                 |   39 +++++++------
 fs/reiserfs/inode.c                             |   10 +++-
 fs/reiserfs/stree.c                             |    4 ++
 fs/reiserfs/super.c                             |   60 +++++++++++++++----=
-
 fs/ubifs/find.c                                 |   12 +++-
 fs/ubifs/lprops.c                               |    6 ++
 fs/ubifs/ubifs.h                                |    3 +
 fs/xfs/xfs_buf.c                                |   14 ++++-
 include/linux/ptp_clock_kernel.h                |    3 +-
 kernel/futex.c                                  |   59 +++++++++++++------=
-
 kernel/watchdog.c                               |    4 +-
 kernel/workqueue.c                              |    4 +-
 mm/memcontrol.c                                 |   21 +++++--
 mm/memory-failure.c                             |    8 +++
 mm/shmem.c                                      |    2 +-
 mm/sparse.c                                     |   10 ++--
 mm/vmscan.c                                     |   27 ++++++---
 net/can/bcm.c                                   |    3 +
 net/core/dev.c                                  |    4 +-
 net/core/dev_addr_lists.c                       |    3 +-
 net/ipv4/ip_sockglue.c                          |   33 +++++++----
 net/ipv4/netfilter/nf_nat_standalone.c          |    6 +-
 net/ipv6/ipv6_sockglue.c                        |    1 +
 net/mac80211/ibss.c                             |    8 +--
 net/mac80211/sta_info.c                         |    5 ++
 net/netfilter/nf_conntrack_proto_tcp.c          |   29 ++++------
 net/wireless/reg.c                              |    5 +-
 security/device_cgroup.c                        |    6 +-
 security/selinux/netnode.c                      |    3 +-
 sound/pci/hda/patch_realtek.c                   |    3 +
 sound/soc/codecs/wm8978.c                       |    2 +-
 sound/soc/soc-dapm.c                            |    2 +-
 sound/usb/midi.c                                |    8 ++-
 95 files changed, 741 insertions(+), 295 deletions(-)

Al Viro (2):
      sparc64: not any error from do_sigaltstack() should fail rt_sigreturn=
()
      fix user-triggerable panic on parisc

Albert Pool (1):
      rtlwifi: rtl8192cu: Add new USB ID

Alex Deucher (2):
      drm/radeon: fix logic error in atombios_encoders.c
      drm/radeon: properly track the crtc not_enabled case evergreen_mc_sto=
p()

Andre Przywara (1):
      x86, amd: Disable way access filter on Piledriver CPUs

Andreas Schwab (1):
      m68k: fix sigset_t accessor functions

Arend van Spriel (1):
      brcm80211: smac: only print block-ack timeout message at trace level

Arik Nemtsov (1):
      mac80211: sync acccess to tx_filtered/ps_tx_buf queues

Artem Bityutskiy (2):
      UBIFS: introduce categorized lprops counter
      UBIFS: fix mounting problems after power cuts

Ben Hutchings (2):
      intel_idle: enable IVB Xeon support
      Linux 3.2.35

Benjamin Marzinski (1):
      GFS2: Test bufdata with buffer locked and gfs2_log_lock held

Bing Zhao (2):
      mwifiex: fix system hang issue in cmd timeout error case
      mwifiex: report error to MMC core if we cannot suspend

Boris Ostrovsky (1):
      x86, microcode, AMD: Add support for family 16h processors

Chuansheng Liu (1):
      watchdog: using u64 in get_sample_period()

Clemens Ladisch (1):
      ALSA: ua101, usx2y: fix broken MIDI output

Dan Williams (2):
      USB: option: add Novatel E362 and Dell Wireless 5800 USB IDs
      USB: option: add Alcatel X220/X500D USB IDs

Darren Hart (1):
      futex: avoid wake_futex() for a PI futex_q

Dave Chinner (1):
      xfs: drop buffer io reference when a bad bio is built

Dave Jones (1):
      selinux: fix sel_netnode_insert() suspicious rcu dereference

David Henningsson (1):
      ALSA: hda - Add support for Realtek ALC292

Dmitry Torokhov (1):
      Input: i8042 - also perform controller reset when suspending

Emil Tantilov (1):
      ixgbe: add support for new 82599 device id

Eric Millbrandt (1):
      ASoC: wm8978: pll incorrectly configured when codec is master

Fenghua Yu (1):
      x86, mce, therm_throt: Don't report power limit and package level the=
rmal throttle events in mcelog

H. Peter Anvin (1):
      x86-32: Export kernel_stack_pointer() for modules

Hannes Frederic Sowa (1):
      ipv6: setsockopt(IPIPPROTO_IPV6, IPV6_MINHOPCOUNT) forgot to set retu=
rn value

Heiko Carstens (1):
      s390/gup: add missing TASK_SIZE check to get_user_pages_fast()

Hugh Dickins (1):
      tmpfs: change final i_blocks BUG to WARNING

Jacob Keller (1):
      ptp: update adjfreq callback description

Jacob Shin (2):
      x86: Exclude E820_RESERVED regions and memory holes above 4 GB from d=
irect mapping.
      x86, mm: Find_early_table_space based on ranges that are actually bei=
ng mapped

James Bottomley (1):
      fix virtual aliasing issue in get_shared_area()

Jan Kara (5):
      reiserfs: Fix lock ordering during remount
      reiserfs: Protect reiserfs_quota_on() with write lock
      reiserfs: Protect reiserfs_quota_write() with write lock
      reiserfs: Move quota calls out of write lock
      jbd: Fix lock ordering bug in journal_unmap_buffer()

Jan Safrata (1):
      usb: use usb_serial_put in usb_serial_probe errors

Jani Nikula (1):
      drm/i915/sdvo: clean up connectors on intel_sdvo_init() failures

Jason Gunthorpe (1):
      ARM: Kirkwood: Update PCI-E fixup

Jens Axboe (1):
      dm: fix deadlock with request based dm and queue request_fn recursion

Jianguo Wu (1):
      mm/vmemmap: fix wrong use of virt_to_page

Jiri Engelthaler (1):
      mtd: slram: invalid checking of absolute end address

Jiri Pirko (1):
      net: correct check in dev_addr_del()

Johannes Berg (1):
      wireless: allow 40 MHz on world roaming channels 12/13

Johannes Weiner (1):
      mm: vmscan: fix endless loop in kswapd balancing

Jozsef Kadlecsik (2):
      netfilter: Mark SYN/ACK packets as invalid from original direction
      netfilter: Validate the sequence number of dataless ACK packets as we=
ll

Jussi Pakkanen (1):
      Input: bcm5974 - set BUTTONPAD property

Kailang Yang (1):
      ALSA: hda - Add new codec ALC283 ALC290 support

Len Brown (1):
      intel_idle: initial IVB support

Maciej Patelczyk (1):
      isci: copy fis 0x34 response into proper buffer

Marek Vasut (1):
      HID: add quirk for Freescale i.MX28 ROM recovery

Martin Schwidefsky (1):
      s390/signal: set correct address space control

Mauro Carvalho Chehab (1):
      get_dvb_firmware: fix download site for tda10046 firmware

Merlin Schumacher (1):
      acer-wmi: support for P key on TM8372

Michal Hocko (1):
      memcg: oom: fix totalpages calculation for memory.swappiness=3D=3D0

Mike Galbraith (1):
      workqueue: exit rescuer_thread() as TASK_RUNNING

Misael Lopez Cruz (1):
      ASoC: dapm: Use card_list during DAPM shutdown

Naoya Horiguchi (1):
      mm: soft offline: split thp at the beginning of soft_offline_page()

Oliver Hartkopp (1):
      can: bcm: initialize ifindex for timeouts without previous frame rece=
ption

Paul Bolle (1):
      radeon: add AGPMode 1 quirk for RV250

Robert Richter (1):
      x86-32: Fix invalid stack address while in softirq

Roland Dreier (1):
      block: Don't access request after it might be freed

Russell King - ARM Linux (2):
      Dove: Attempt to fix PMU/RTC interrupts
      Dove: Fix irq_to_pmu()

Sachin Kamat (1):
      mtd: ofpart: Fix incorrect NULL check in parse_ofoldpart_partitions()

Sarah Sharp (2):
      xhci: Remove warnings about MSI and MSI-X capabilities.
      xhci: Remove scary warnings about transfer issues.

Seth Heasley (1):
      watchdog: iTCO_wdt: add Intel Lynx Point DeviceIDs

Simon Wunderlich (1):
      mac80211: deinitialize ibss-internals after emptiness check

Takashi Iwai (1):
      drm/i915: Check VBIOS value for determining LVDS dual channel mode, t=
oo

Tejun Heo (1):
      device_cgroup: fix RCU usage

Thomas Betker (1):
      jffs2: Fix lock acquisition order bug in jffs2_write_begin

Thomas Gleixner (1):
      futex: Handle futex_pi OWNER_DIED take over correctly

Tilman Schmidt (1):
      bas_gigaset: fix pre_reset handling

Tom Herbert (1):
      net-rps: Fix brokeness causing OOO packets

Ulrich Weber (1):
      netfilter: nf_nat: don't check for port change on ICMP tuples

Xi Wang (1):
      ipv4: avoid undefined behavior in do_ip_setsockopt()

Yinghai Lu (2):
      x86, mm: Undo incorrect revert in arch/x86/mm/init.c
      PCI : Calculate right add_size

Zhao Yakui (1):
      ttm: Clear the ttm page allocated from high memory zone correctly

joshua.a.hay@intel.com (1):
      ixgbe: add support for X540-AT1

majianpeng (2):
      md: Reassigned the parameters if read_seqretry returned true in func =
md_is_badblock.
      md: Avoid write invalid address if read_seqretry returned true.



--=-PDPkkSQVy7reQRcXLsDy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUMFFFee/yOyVhhEJAQrgrRAAnakK/QcNo/m8G3FmMWPfRM6NJTMUHfZX
2BE8Gyz21cPexGztQ/CUp/C934NvbifzGIeVS5r1CQu6PXlW9kXDdmTeAxI77HPE
howaI9aImK5MXB6q0Qsf5YfWHsx/l5o1Ku0EdclM9r15gVGeJiMfT/4HJAUQqxdz
/Gef7QBsCidM43DgpAEG0oJCWQ9nUIGE68xmKXDrxbvKfcZl0+ucjHdmct1CC4mv
8zeKTLN2+Q4lLl6o5sf+r3ADcj4kHfnx1cR+YW8ktyD/PRkMGB+QjO8fCMp6rete
DT93cwAtMqZLW4aaVTMRI/qHTgH5Lmnm/EtxF1TDJzgNiSRHYWGxC1QOI+au7/in
Aoc3ZXqgmgrZdun++zqBaf7nfVjEujZgcUaN+/89d8o28Ob/pIH8MYx8lfUIp/JE
2zHWHor1ZqCxBVBtijiQYRt+UzrLohEN5dN6qcN1PLTJKzCbC8OkJkEazcMPKQBU
YNaphWL6rv/yIaYpbksCX1vTlsOkECMPhMYz68LWxMcMhiAWnpgg13XWdvCb8a5H
VQiWJp1W728wfUWTQnUzXitH7ggnLb37sVPHGALy2uBM5nd/Rgrw2UT6CjuK1oyd
6Vb5ne+NKqCg96IBCzneVq8Unjvj4zhV/eFObEUDhjcygaNV93dyFyX+qMAMh200
pLnFGYIET20=
=i9fi
-----END PGP SIGNATURE-----

--=-PDPkkSQVy7reQRcXLsDy--
