Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab2GPSX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 14:23:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50950 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab2GPSXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 14:23:53 -0400
Date: Mon, 16 Jul 2012 11:23:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.37
Message-ID: <20120716182348.GA30855@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.37 kernel.

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

 Documentation/stable_kernel_rules.txt        |    6 +
 Makefile                                     |    2=20
 arch/arm/kernel/smp.c                        |   12 ++-
 arch/powerpc/xmon/xmon.c                     |    2=20
 arch/x86/include/asm/cpufeature.h            |    2=20
 arch/x86/kernel/acpi/boot.c                  |   27 ++++---
 arch/x86/kernel/cpu/scattered.c              |    2=20
 arch/x86/kernel/reboot.c                     |    8 ++
 drivers/acpi/acpi_pad.c                      |    7 +
 drivers/acpi/sysfs.c                         |    4 -
 drivers/block/umem.c                         |   40 ++++++++++
 drivers/gpu/drm/drm_edid.c                   |    2=20
 drivers/gpu/drm/i915/i915_suspend.c          |    5 +
 drivers/gpu/drm/nouveau/nouveau_fbcon.c      |    2=20
 drivers/hwmon/applesmc.c                     |    4 -
 drivers/hwmon/coretemp.c                     |    2=20
 drivers/md/raid10.c                          |    6 +
 drivers/md/raid5.c                           |    8 +-
 drivers/media/dvb/siano/smsusb.c             |    2=20
 drivers/mtd/nand/cafe_nand.c                 |    2=20
 drivers/net/benet/be_main.c                  |    5 -
 drivers/net/bonding/bond_main.c              |    9 +-
 drivers/net/can/c_can/c_can.c                |    4 -
 drivers/net/dummy.c                          |    5 +
 drivers/net/sky2.c                           |   10 +-
 drivers/net/usb/ipheth.c                     |    5 +
 drivers/net/wireless/ath/ath9k/hw.c          |   16 +++-
 drivers/net/wireless/ath/ath9k/main.c        |    9 ++
 drivers/net/wireless/mwifiex/11n_rxreorder.c |    5 -
 drivers/net/wireless/mwifiex/11n_rxreorder.h |    7 +
 drivers/net/wireless/mwifiex/wmm.c           |    2=20
 drivers/net/wireless/rtl818x/rtl8187/leds.c  |    2=20
 drivers/oprofile/oprofile_perf.c             |    2=20
 drivers/pci/pci-driver.c                     |   12 +++
 drivers/pci/pci.c                            |    5 -
 drivers/pci/quirks.c                         |   26 ------
 drivers/rtc/rtc-mxc.c                        |    5 -
 drivers/target/tcm_fc/tfc_sess.c             |    3=20
 drivers/usb/class/cdc-wdm.c                  |    2=20
 drivers/usb/host/pci-quirks.c                |   13 +++
 drivers/usb/serial/cp210x.c                  |   11 ++
 drivers/usb/serial/option.c                  |   34 +++++++++
 drivers/vhost/vhost.c                        |    2=20
 fs/btrfs/tree-log.c                          |    6 +
 fs/ecryptfs/kthread.c                        |    2=20
 fs/ecryptfs/miscdev.c                        |   48 +++++++-----
 fs/nilfs2/gcinode.c                          |    2=20
 fs/nilfs2/segment.c                          |    2=20
 fs/open.c                                    |    6 -
 fs/ramfs/file-nommu.c                        |    1=20
 fs/udf/super.c                               |  102 ++++++++++++++++------=
-----
 include/linux/mmzone.h                       |    2=20
 include/linux/pci.h                          |    2=20
 include/net/cipso_ipv4.h                     |   29 +++++++
 include/net/sch_generic.h                    |    7 +
 kernel/trace/trace.c                         |    2=20
 mm/compaction.c                              |    5 +
 mm/madvise.c                                 |   16 +++-
 mm/vmscan.c                                  |    7 +
 net/bridge/br_if.c                           |    1=20
 net/bridge/br_netlink.c                      |    2=20
 net/bridge/br_private.h                      |    1=20
 net/core/ethtool.c                           |    1=20
 net/core/netpoll.c                           |   11 +-
 net/core/sock.c                              |    7 +
 net/ipv6/route.c                             |   41 ++++++++--
 net/l2tp/l2tp_eth.c                          |    2=20
 net/mac80211/rx.c                            |    5 +
 net/wireless/reg.c                           |    2=20
 sound/pci/hda/patch_realtek.c                |    1=20
 sound/soc/codecs/tlv320aic3x.c               |    4 -
 sound/soc/codecs/tlv320aic3x.h               |    1=20
 72 files changed, 477 insertions(+), 180 deletions(-)

Alan Stern (1):
      PCI: EHCI: fix crash during suspend on ASUS computers

Andy Lutomirski (1):
      mm: Hold a file reference in madvise_remove

Anton Blanchard (1):
      powerpc/xmon: Use cpumask iterator to avoid warning

Ben Skeggs (1):
      drm/nouveau/fbcon: using nv_two_heads is not a good idea

Beno=C3=AEt Th=C3=A9baudeau (1):
      drivers/rtc/rtc-mxc.c: fix irq enabled interrupts warning

Bj=C3=B8rn Mork (2):
      USB: cdc-wdm: fix lockup on error in wdm_read
      USB: option: add ZTE MF60

Bob Liu (1):
      fs: ramfs: file-nommu: add SetPageUptodate()

Chris Mason (1):
      Btrfs: run delayed directory updates during log replay

Craig Shelley (1):
      USB: CP210x Add 10 Device IDs

Dan Carpenter (2):
      can: c_can: precedence error in c_can_chip_config()
      mtd: cafe_nand: fix an & vs | mistake

Daniel Vetter (1):
      drm/edid: don't return stack garbage from supports_rb

David Henningsson (1):
      ALSA: hda - Add Realtek ALC280 codec support

David Rientjes (1):
      mm, thp: abort compaction if migration page cannot be charged to memcg

Davide Gerhard (1):
      ipheth: add support for iPad

Dmitry Shmygov (1):
      USB: option: add id for Cellient MEN-200

Eliad Peller (1):
      cfg80211: fix potential deadlock in regulatory

Eric Dumazet (5):
      net: l2tp_eth: fix kernel panic on rmmod l2tp_eth
      dummy: fix rcu_sched self-detected stalls
      bonding: Fix corrupted queue_mapping
      be2net: fix a race in be_xmit()
      netpoll: fix netpoll_send_udp() bugs

Feng Tang (3):
      ACPI: Add a quirk for "AMILO PRO V2030" to ignore the timer overriding
      ACPI: Make acpi_skip_timer_override cover all source_irq=3D=3D0 cases
      ACPI: Remove one board specific WARN when ignoring timer overriding

Forest Bond (1):
      USB: option: Add USB ID for Novatel Ovation MC551

Gaosen Zhang (1):
      USB: option: Add MEDIATEK product ids

Greg Kroah-Hartman (1):
      Linux 3.0.37

H. Peter Anvin (1):
      x86, cpufeature: Rename X86_FEATURE_DTS to X86_FEATURE_DTHERM

Hebbar, Gururaja (1):
      ASoC: tlv320aic3x: Fix codec pll configure bug

Henrik Rydberg (1):
      hwmon: (applesmc) Limit key length in warning messages

Jan Kara (3):
      udf: Use 'ret' instead of abusing 'i' in udf_load_logicalvol()
      udf: Avoid run away loop when partition table length is corrupted
      udf: Fortify loading of sparing table

Jason Wang (1):
      net: sock: validate data_len before allocating skb in sock_alloc_send=
_pskb()

Jiang Liu (1):
      memory hotplug: fix invalid memory access caused by stale kswapd poin=
ter

Johannes Berg (1):
      mac80211: correct behaviour on unrecognised action frames

Linus Torvalds (1):
      vfs: make O_PATH file descriptors usable for 'fchdir()'

Mark Rustad (1):
      tcm_fc: Resolve suspicious RCU usage warnings

Mel Gorman (1):
      stable: Allow merging of backports for serious user-visible performan=
ce issues

Michael Krufky (1):
      media: smsusb: add autodetection support for USB ID 2040:f5a0

Micha=C5=82 Miros=C5=82aw (1):
      ethtool: allow ETHTOOL_GSSET_INFO for users

Mohammed Shafi Shajakhan (2):
      ath9k: Fix softlockup in AR9485
      ath9k_hw: avoid possible infinite loop in ar9003_get_pll_sqsum_dvc

Nadav Har'El (1):
      vhost: don't forget to schedule()

NeilBrown (1):
      md/raid10: Don't try to recovery unmatched (and unused) chunks.

Panayiotis Karabassis (1):
      ath9k: enable serialize_regmode for non-PCIE AR9287

Paul Moore (1):
      cipso: handle CIPSO options correctly when NetLabel is disabled

Pavel Vasilyev (1):
      ACPI sysfs.c strlen fix

Russell King (1):
      ARM: fix rcu stalls on SMP platforms

Ryusuke Konishi (1):
      nilfs2: ensure proper cache clearing for gc-inodes

Sarah Sharp (1):
      xhci: Avoid dead ports when CONFIG_USB_XHCI_HCD=3Dn

Shaohua Li (1):
      raid5: delayed stripe fix

Stanislaw Gruszka (1):
      rtl8187: ->brightness_set can not sleep

Stone Piao (1):
      mwifiex: fix 11n rx packet drop issue

Stuart Hayes (1):
      acpi_pad: fix power_saving thread deadlock

Takashi Iwai (1):
      drm/i915: Fix eDP blank screen after S3 resume on HP desktops

Tao Guo (1):
      umem: fix up unplugging

Thomas Graf (1):
      ipv6: Move ipv6 proc file registration to end of init order

Tyler Hicks (3):
      eCryptfs: Gracefully refuse miscdev file ops on inherited/passed files
      eCryptfs: Fix lockdep warning in miscdev operations
      eCryptfs: Properly check for O_RDONLY flag before doing privileged op=
en

Vaibhav Nagarnaik (1):
      tracing: change CPU ring buffer state from tracing_cpumask

Will Deacon (1):
      oprofile: perf: use NR_CPUS instead or nr_cpumask_bits for static arr=
ay

Zhang Rui (1):
      ACPI, x86: fix Dell M6600 ACPI reboot regression via DMI

majianpeng (1):
      md/raid5: Do not add data_offset before call to is_badblock

stephen hemminger (2):
      bridge: Assign rtnl_link_ops to bridge devices created via ioctl (v2)
      sky2: fix checksum bit management on some chips


--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJQBFw0AAoJEDjbvchgkmk+xE0P/0YEE8PYsX5aVPImgO0lnbKw
n+2EPKQHyvOUBn02f+xBmgBnLdcFesdVzkdRX/7IsZbXTRRhchki/fNP535sN8GN
TUWDttsTngwfaCZJ87RYZxr6chg1eE7V8Dx1EP7LTlvo3jvLHs1L1vKdQaWv8914
VFFf6KVYrQmQ6ekPg3T2zz2qBFH11WTlylMKmhnIfwqfKPs4frJ9NCkvF6MyRZAq
liGZ5r034XgzocWDeUyKiSnD3tt2DdQnvGwBragynFmo+FyBfFUDo366xLWunanf
OVmiY9GNfzQgAnrS/lbFQ0RO/1aOxQps1SAAT/ltuKqDC7DFh/gzwRGvjrV/JxTh
UhjO64hK58vyZG6g/tkL9WzyXichTzN32fhkWiouxb6w230dIoHVG8ExPtHvsiKF
x+/gyzTe1dBE/h+A/nMbcyg6yL08vuFgejQMj+WZnPPcMpgVk2pHMG5wls4TK2Yh
xy9xd9Xqo+a05CG/0J2jOTOovtfzi3n6XcfuDcFDVtz6OR0VkBcG2fypFEr87rRz
+OYwPrR33Xc9vntwzzxKxyWFvkpu7jYpNl30/qdNcrl5B/5AUmoAHO/sK3G9VL3p
doiUOFfFl2g4Q8aML67ywYQGodhcfbdtscGnh/MDfaeUN1V2hmAgXXuPSdakJytC
LI8kUPSJfR0ZB4jnlZ7v
=1fg0
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
