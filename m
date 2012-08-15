Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab2HOPU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:20:58 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38748 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab2HOPUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:20:54 -0400
Date: Wed, 15 Aug 2012 08:20:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.9
Message-ID: <20120815152050.GA22187@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.9 kernel.

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

 MAINTAINERS                               |    2=20
 Makefile                                  |    2=20
 arch/arm/boot/dts/imx53-ard.dts           |   20 +
 arch/arm/configs/mxs_defconfig            |    1=20
 arch/arm/include/asm/cacheflush.h         |    8=20
 arch/arm/kernel/entry-armv.S              |  111 ++++++---
 arch/arm/kernel/process.c                 |    2=20
 arch/arm/kernel/smp.c                     |    3=20
 arch/arm/kernel/traps.c                   |    8=20
 arch/arm/mach-pxa/raumfeld.c              |    2=20
 arch/arm/mm/tlb-v7.S                      |   12 +
 arch/arm/vfp/entry.S                      |   16 -
 arch/arm/vfp/vfphw.S                      |   19 -
 arch/arm/vfp/vfpmodule.c                  |    8=20
 arch/ia64/include/asm/atomic.h            |    4=20
 arch/ia64/kernel/irq_ia64.c               |    1=20
 arch/x86/kernel/alternative.c             |    2=20
 arch/x86/kernel/microcode_core.c          |   31 +-
 drivers/acpi/processor_driver.c           |    2=20
 drivers/char/mspec.c                      |    2=20
 drivers/char/random.c                     |  352 +++++++++++++++++++------=
-----
 drivers/firmware/dmi_scan.c               |    3=20
 drivers/firmware/pcdp.c                   |    4=20
 drivers/hid/hid-chicony.c                 |    1=20
 drivers/hid/hid-core.c                    |    2=20
 drivers/hid/hid-cypress.c                 |    2=20
 drivers/hid/hid-ids.h                     |    5=20
 drivers/hid/hid-multitouch.c              |    5=20
 drivers/input/tablet/wacom_wac.c          |    2=20
 drivers/input/touchscreen/eeti_ts.c       |   21 +
 drivers/md/raid1.c                        |    5=20
 drivers/media/rc/ene_ir.c                 |    3=20
 drivers/mfd/ab3100-core.c                 |    5=20
 drivers/mfd/ezx-pcap.c                    |    2=20
 drivers/mfd/wm831x-otp.c                  |    8=20
 drivers/net/ethernet/intel/e1000e/82571.c |    4=20
 drivers/net/tun.c                         |    1=20
 drivers/net/wireless/ath/ath9k/hw.c       |    1=20
 drivers/net/wireless/ath/ath9k/hw.h       |    1=20
 drivers/net/wireless/ath/ath9k/pci.c      |    1=20
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   13 -
 drivers/net/wireless/rt2x00/rt61pci.c     |    3=20
 drivers/platform/x86/asus-wmi.c           |    7=20
 drivers/rtc/rtc-wm831x.c                  |   24 +-
 drivers/target/target_core_cdb.c          |   43 ++-
 drivers/usb/core/hub.c                    |    9=20
 drivers/video/smscufx.c                   |    2=20
 fs/exofs/ore.c                            |   14 -
 fs/nilfs2/ioctl.c                         |    4=20
 fs/nilfs2/super.c                         |    3=20
 fs/nilfs2/the_nilfs.c                     |    1=20
 fs/nilfs2/the_nilfs.h                     |    2=20
 include/linux/input/eeti_ts.h             |    1=20
 include/linux/irqdesc.h                   |    1=20
 include/linux/mfd/ezx-pcap.h              |    1=20
 include/linux/random.h                    |    6=20
 include/trace/events/random.h             |  134 +++++++++++
 kernel/irq/handle.c                       |    7=20
 kernel/irq/manage.c                       |   17 -
 mm/hugetlb.c                              |   25 +-
 mm/memory-failure.c                       |    6=20
 mm/mmu_notifier.c                         |   45 +--
 net/core/dev.c                            |    3=20
 net/core/rtnetlink.c                      |    1=20
 net/mac80211/mesh.c                       |    1=20
 net/sunrpc/clnt.c                         |    3=20
 net/sunrpc/rpcb_clnt.c                    |    4=20
 net/wireless/core.c                       |    5=20
 net/wireless/core.h                       |    1=20
 net/wireless/reg.c                        |   16 +
 net/wireless/util.c                       |    5=20
 sound/pci/hda/patch_conexant.c            |    1=20
 sound/pci/hda/patch_realtek.c             |    7=20
 73 files changed, 769 insertions(+), 330 deletions(-)

Alan Cox (1):
      x86, nops: Missing break resulting in incorrect selection on Intel

Alex Hung (1):
      asus-wmi: use ASUS_WMI_METHODID_DSTS2 as default DSTS ID.

Alexander Holler (1):
      video/smscufx: fix line counting in fb_write

Arnd Bergmann (2):
      ARM: pxa: remove irq_to_gpio from ezx-pcap driver
      Input: eeti_ts: pass gpio value instead of IRQ

Austin Hendrix (1):
      HID: multitouch: add support for Novatek touchscreen

Boaz Harrosh (1):
      ore: Fix out-of-bounds access in _ios_obj()

Borislav Petkov (1):
      x86, microcode: Sanitize per-cpu microcode reloading interface

Chris Bagwell (1):
      Input: wacom - Bamboo One 1024 pressure fix

Colin Cross (2):
      ARM: 7476/1: vfp: only clear vfp state for current cpu in vfp_pm_susp=
end
      ARM: 7477/1: vfp: Always save VFP state in vfp_pm_suspend on UP

Cyrus Lien (1):
      HID: add ASUS AIO keyboard model AK1D

Daniel Drake (1):
      cfg80211: process pending events when unregistering net device

David Henningsson (2):
      ALSA: hda - remove quirk for Dell Vostro 1015
      ALSA: hda - Fix double quirk for Quanta FL1 / Lenovo Ideapad

Felix Kaechele (1):
      ALSA: hda - add dock support for Thinkpad X230

Feng Tang (1):
      ACPI processor: Fix tick_broadcast_mask online/offline regression

Greg Kroah-Hartman (1):
      Linux 3.4.9

Greg Pearson (1):
      pcdp: use early_ioremap/early_iounmap to access pcdp table

H. Peter Anvin (1):
      random: mix in architectural randomness in extract_buf()

Javier Martinez Canillas (1):
      ARM: 7480/1: only call smp_send_stop() on SMP

Joe Perches (1):
      sunrpc: clnt: Add missing braces

Johannes Berg (2):
      mac80211: cancel mesh path timer
      iwlwifi: disable greenfield transmissions as a workaround

Joonsoo Kim (1):
      mm: fix wrong argument of migrate_huge_pages() in soft_offline_huge_p=
age()

Liang Li (1):
      cfg80211: fix interface combinations check for ADHOC(IBSS)

Linus Torvalds (1):
      random: create add_device_randomness() interface

Lionel Vaux (1):
      HID: add support for Cypress barcode scanner 04B4:ED81

Luis Henriques (1):
      media: ene_ir: Fix driver initialisation

Marek Vasut (1):
      ARM: mxs: Remove MMAP_MIN_ADDR setting from mxs_defconfig

Mark Brown (2):
      rtc: wm831x: Feed the write counter into device_add_randomness()
      mfd: wm831x: Feed the device UUID into device_add_randomness()

Mel Gorman (1):
      mm: hugetlbfs: close race during teardown of hugetlbfs shared page ta=
bles

Mohammed Shafi Shajakhan (1):
      ath9k: Add PID/VID support for AR1111

NeilBrown (1):
      md/raid1: don't abort a resync on the first badblock.

Philipp A. Mohrenweiser (1):
      ALSA: hda - add dock support for Thinkpad T430s

Roland Dreier (4):
      target: Add range checking to UNMAP emulation
      target: Fix reading of data length fields for UNMAP commands
      target: Fix possible integer underflow in UNMAP emulation
      target: Check number of unmap descriptors against our limit

Russell King (1):
      ARM: Fix undefined instruction exception handling

Ryusuke Konishi (1):
      nilfs2: fix deadlock issue between chcp and thaw ioctls

Shawn Guo (2):
      ARM: 7466/1: disable interrupt before spinning endlessly
      ARM: dts: imx53-ard: add regulators for lan9220

Shuah Khan (1):
      x86, microcode: microcode_core.c simple_strtoul cleanup

Stanislav Kinsbursky (2):
      SUNRPC: return negative value in case rpcbind client creation error
      tun: don't zeroize sock->file on detach

Stanislaw Gruszka (2):
      wireless: reg: restore previous behaviour of chan->max_power calculat=
ions
      rt61pci: fix NULL pointer dereference in config_lna_gain

Theodore Ts'o (9):
      random: make 'add_interrupt_randomness()' do something sane
      random: use lockless techniques in the interrupt path
      usb: feed USB device information to the /dev/random driver
      net: feed /dev/random with the MAC address when registering a device
      random: use the arch-specific rng in xfer_secondary_pool
      random: add new get_random_bytes_arch() function
      random: add tracepoints for easier debugging and verification
      MAINTAINERS: Theodore Ts'o is taking over the random driver
      random: remove rand_initialize_irq()

Tony Luck (3):
      Redefine ATOMIC_INIT and ATOMIC64_INIT to drop the casts
      random: Add comment to random_initialize()
      dmi: Feed DMI table to /dev/random driver

Tushar Dave (1):
      e1000e: NIC goes up and immediately goes down

Will Deacon (2):
      ARM: 7478/1: errata: extend workaround for erratum #720789
      ARM: 7479/1: mm: avoid NULL dereference when flushing gate_vma with V=
IVT caches

Xiao Guangrong (1):
      mm: mmu_notifier: fix freed page still mapped in secondary MMU


--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJQK75SAAoJEDjbvchgkmk+h8cP/AuczNnboHeSYnh47Lhkcas6
MEbVewfcsjbu37ANz+jfGfrUiIdbRhXmB2BEPanf7/f3YarfliPSx5jHDHRkoiUt
507sS5G3pQHIjUACWGv/yI2p9gPkOe+JH0fUqzLkmxHOhHpsylBviJH8JkPZ1PA2
/RkBdBQfOPijB+JohwxXCght6keixtZ1+lviCG0ilnaQwKaCZohg/OrcekzLM+x9
UdFdxrrmZ4YbkG+OYVHg/DgljEkv21J72W/Ks0o9I0pihS33QEcT4Dm9jLP9dlz1
fVbyL7zWIlD9NPKxI+SZSA++wjDGvz6T/vnSIOAiay4UfGfC0vfPdNFMMbiVhz7A
b4mu98NuX58gJf/lTIAlKYQsRv4XZU3QmxL/gx5NmwzVenlfjhuKe2g+QLrPcrt3
uW1x4gouj36sUoOjFwhMC4gKHbl6bTmCFbXFHwQxq18Ngm8WBGAZx5yrwmoHvBec
70hD5U3QsIp7hk5CIe+EcHL9L1pN6fOYQYm7dsvGHOgBZZpw2fHjxDp+xi4abKC6
AGnpZZz353rXj82oxNGATEcLSJxBTFGqh3TvkSH64Y/U9UoKWxM0KWKdx9D03v4A
J6t8KPsaKJsWMne/oV5ZhCXvPMPW77a0+AwhNFlrbRn3UBoLYqeN8N6CxVt+E28a
Dy/bjhEuANqtB9G5UWw1
=xYsh
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
