Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab2HOPUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:20:37 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38748 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab2HOPUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:20:03 -0400
Date: Wed, 15 Aug 2012 08:19:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.5.2
Message-ID: <20120815151958.GA14327@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.5.2 kernel.

All users of the 3.5 kernel series must upgrade.

The updated 3.5.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.5.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Documentation/security/Yama.txt              |   14 -
 MAINTAINERS                                  |    2=20
 Makefile                                     |    2=20
 arch/arm/boot/dts/imx53-ard.dts              |   20 +
 arch/arm/configs/mxs_defconfig               |    1=20
 arch/arm/include/asm/cacheflush.h            |    8=20
 arch/arm/kernel/entry-armv.S                 |  111 +++++---
 arch/arm/kernel/process.c                    |    2=20
 arch/arm/kernel/smp.c                        |    3=20
 arch/arm/kernel/traps.c                      |    8=20
 arch/arm/mach-imx/clk-imx31.c                |    2=20
 arch/arm/mach-imx/clk-imx51-imx53.c          |    1=20
 arch/arm/mach-pxa/raumfeld.c                 |    2=20
 arch/arm/mm/tlb-v7.S                         |   12=20
 arch/arm/vfp/entry.S                         |   16 -
 arch/arm/vfp/vfphw.S                         |   19 -
 arch/arm/vfp/vfpmodule.c                     |    8=20
 arch/ia64/include/asm/atomic.h               |    4=20
 arch/ia64/kernel/irq_ia64.c                  |    1=20
 arch/sh/mm/fault.c                           |    8=20
 arch/x86/kernel/alternative.c                |    2=20
 arch/x86/syscalls/syscall_64.tbl             |    2=20
 block/blk-ioc.c                              |    1=20
 drivers/acpi/processor_driver.c              |    2=20
 drivers/block/virtio_blk.c                   |   25 -
 drivers/char/mspec.c                         |    2=20
 drivers/char/random.c                        |  352 +++++++++++++++++-----=
-----
 drivers/firmware/dmi_scan.c                  |    3=20
 drivers/firmware/pcdp.c                      |    4=20
 drivers/hid/hid-chicony.c                    |    1=20
 drivers/hid/hid-core.c                       |    2=20
 drivers/hid/hid-cypress.c                    |    2=20
 drivers/hid/hid-ids.h                        |    5=20
 drivers/hid/hid-multitouch.c                 |    5=20
 drivers/input/mouse/synaptics.c              |   22 +
 drivers/input/tablet/wacom_wac.c             |    2=20
 drivers/input/touchscreen/eeti_ts.c          |   21 -
 drivers/isdn/hardware/mISDN/avmfritz.c       |    7=20
 drivers/isdn/mISDN/layer2.c                  |    2=20
 drivers/md/raid1.c                           |    5=20
 drivers/media/rc/ene_ir.c                    |    3=20
 drivers/media/video/m5mols/m5mols_controls.c |    4=20
 drivers/media/video/videobuf-dma-contig.c    |   53 ++--
 drivers/mfd/ab3100-core.c                    |    5=20
 drivers/mfd/ezx-pcap.c                       |    2=20
 drivers/mfd/wm831x-otp.c                     |    8=20
 drivers/net/ethernet/intel/e1000e/82571.c    |    4=20
 drivers/net/tun.c                            |    1=20
 drivers/net/wireless/ath/ath9k/hw.c          |    1=20
 drivers/net/wireless/ath/ath9k/hw.h          |    1=20
 drivers/net/wireless/ath/ath9k/pci.c         |    1=20
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c    |   13=20
 drivers/net/wireless/rt2x00/rt61pci.c        |    3=20
 drivers/platform/x86/asus-wmi.c              |    7=20
 drivers/rtc/rtc-wm831x.c                     |   24 +
 drivers/target/target_core_cdb.c             |   43 ++-
 drivers/usb/core/hub.c                       |    9=20
 drivers/video/smscufx.c                      |    2=20
 fs/exofs/ore.c                               |   14 -
 fs/nilfs2/ioctl.c                            |    4=20
 fs/nilfs2/super.c                            |    3=20
 fs/nilfs2/the_nilfs.c                        |    1=20
 fs/nilfs2/the_nilfs.h                        |    2=20
 include/linux/input/eeti_ts.h                |    1=20
 include/linux/irqdesc.h                      |    1=20
 include/linux/mfd/ezx-pcap.h                 |    1=20
 include/linux/random.h                       |    6=20
 include/linux/security.h                     |    2=20
 include/trace/events/random.h                |  134 ++++++++++
 kernel/irq/handle.c                          |    7=20
 kernel/irq/manage.c                          |   17 -
 kernel/printk.c                              |    2=20
 lib/vsprintf.c                               |    3=20
 mm/hugetlb.c                                 |   25 +
 mm/internal.h                                |    2=20
 mm/memory-failure.c                          |    6=20
 mm/mmu_notifier.c                            |   45 +--
 mm/page_alloc.c                              |    4=20
 mm/sparse.c                                  |    3=20
 mm/vmscan.c                                  |   38 ++
 net/core/dev.c                               |    3=20
 net/core/rtnetlink.c                         |    1=20
 net/mac80211/mesh.c                          |    1=20
 net/sunrpc/clnt.c                            |    3=20
 net/sunrpc/rpcb_clnt.c                       |    4=20
 net/wireless/core.c                          |    5=20
 net/wireless/core.h                          |    1=20
 net/wireless/reg.c                           |   16 +
 net/wireless/util.c                          |    2=20
 security/selinux/hooks.c                     |   15 -
 security/yama/yama_lsm.c                     |   41 +++
 sound/pci/hda/patch_conexant.c               |    1=20
 sound/pci/hda/patch_realtek.c                |    7=20
 93 files changed, 926 insertions(+), 390 deletions(-)

Al Viro (1):
      selinux: fix selinux_inode_setxattr oops

Alan Cox (1):
      x86, nops: Missing break resulting in incorrect selection on Intel

Alex Hung (1):
      asus-wmi: use ASUS_WMI_METHODID_DSTS2 as default DSTS ID.

Alexander Holler (1):
      video/smscufx: fix line counting in fb_write

Arnd Bergmann (2):
      ARM: pxa: remove irq_to_gpio from ezx-pcap driver
      Input: eeti_ts: pass gpio value instead of IRQ

Asias He (3):
      virtio-blk: Call del_gendisk() before disable guest kick
      virtio-blk: Reset device after blk_cleanup_queue()
      virtio-blk: Use block layer provided spinlock

Austin Hendrix (1):
      HID: multitouch: add support for Novatek touchscreen

Boaz Harrosh (1):
      ore: Fix out-of-bounds access in _ios_obj()

Chris Bagwell (1):
      Input: wacom - Bamboo One 1024 pressure fix

Colin Cross (2):
      ARM: 7476/1: vfp: only clear vfp state for current cpu in vfp_pm_susp=
end
      ARM: 7477/1: vfp: Always save VFP state in vfp_pm_suspend on UP

Cyrus Lien (1):
      HID: add ASUS AIO keyboard model AK1D

Dan Rosenberg (1):
      lib/vsprintf.c: kptr_restrict: fix pK-error in SysRq show-all-timers(=
Q)

Daniel Drake (1):
      cfg80211: process pending events when unregistering net device

David Henningsson (2):
      ALSA: hda - remove quirk for Dell Vostro 1015
      ALSA: hda - Fix double quirk for Quanta FL1 / Lenovo Ideapad

Fabio Estevam (1):
      ARM: clk-imx31: Fix the keypad clock name

Felix Kaechele (1):
      ALSA: hda - add dock support for Thinkpad X230

Feng Tang (1):
      ACPI processor: Fix tick_broadcast_mask online/offline regression

Greg Kroah-Hartman (1):
      Linux 3.5.2

Greg Pearson (1):
      pcdp: use early_ioremap/early_iounmap to access pcdp table

H. Peter Anvin (2):
      x86-64, kcmp: The kcmp system call can be common
      random: mix in architectural randomness in extract_buf()

Hugh Dickins (1):
      memcg: further prevent OOM with too many dirty pages

Javier Martinez Canillas (1):
      ARM: 7480/1: only call smp_send_stop() on SMP

Jeff Mahoney (1):
      printk: Fix calculation of length used to discard records

Joe Perches (1):
      sunrpc: clnt: Add missing braces

Johannes Berg (2):
      mac80211: cancel mesh path timer
      iwlwifi: disable greenfield transmissions as a workaround

Joonsoo Kim (1):
      mm: fix wrong argument of migrate_huge_pages() in soft_offline_huge_p=
age()

Karsten Keil (2):
      mISDN: Bugfix only few bytes are transfered on a connection
      mISDN: Bugfix for layer2 fixed TEI mode

Kees Cook (1):
      Yama: higher restrictions should block PTRACE_TRACEME

Lad, Prabhakar (1):
      media: videobuf-dma-contig: restore buffer mapping for uncached bufers

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

Michal Hocko (1):
      memcg: prevent OOM with too many dirty pages

Mohammed Shafi Shajakhan (1):
      ath9k: Add PID/VID support for AR1111

NeilBrown (1):
      md/raid1: don't abort a resync on the first badblock.

Olof Johansson (1):
      block: uninitialized ioc->nr_tasks triggers WARN_ON

Paul Mundt (1):
      sh: Fix up recursive fault in oops with unset TTB.

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

Seth Forshee (1):
      Input: synaptics - handle out of bounds values from the hardware

Shawn Guo (3):
      ARM: 7466/1: disable interrupt before spinning endlessly
      ARM: imx: enable emi_slow_gate clock for imx5
      ARM: dts: imx53-ard: add regulators for lan9220

Stanislav Kinsbursky (2):
      SUNRPC: return negative value in case rpcbind client creation error
      tun: don't zeroize sock->file on detach

Stanislaw Gruszka (2):
      wireless: reg: restore previous behaviour of chan->max_power calculat=
ions
      rt61pci: fix NULL pointer dereference in config_lna_gain

Sylwester Nawrocki (1):
      media: m5mols: Correct reported ISO values

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

Xishi Qiu (1):
      mm: setup pageblock_order before it's used by sparsemem


--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJQK74eAAoJEDjbvchgkmk+b9QP/2tex+DE/UCdyrIXKb9HReDh
H+5rfheaSDVsDPgxgyLW1Jy6BztrPRNx56Qwg2Ia5eMTQHtTQ6jg+WAi0xcvFGT6
uzK5C0sXUUAwY2saSFWuTq3OH6mJkCfprMrWhOmlXFxKY8TivWcI/xqEnn4W+Fw1
GL1ZtWljVQBaHh+wygbGfRQwI9fO6kQWwviBSWGZRxk9ZMlJ6qb1LIKAlDrlPNw3
y+2VOieUudG+kEi3jRvEFfoUxsKtvAISD3yLczo58mbF4JIS6Z76GuYl2CR7S+xr
xBzR9jNCM9WRhASQJUI3hxfoDS1u8ftcA/oHR6WT8iGTb/mE46m8Ko3yO9RuWtJE
V2bLRe0pf8ToDJY3ZvBTAGiEnSWAFoWCB6LKmgy3HFRot5vCcXZK35u9toC7PdF2
9Bsl7SmMGBs3Norw2bv4cCJ6dWIcjgVOY+FdEt/vIoCCcPtb/evel+fTnyqGDmFe
+k3xSSO00BOMCtTQJU93o2JRIsyxG85A5SQ5V5h3bNVFMiokA33LUipIhpmDitu6
yZPensbKSJcx7wyte4GyRjYv4ry7l5k+EMbBWX2QNupiYJLAbOyqFL4F/f4DUJBo
47ItKHuOibyYlJz8GBKfMoTyt1sxj24arrraN6is2MOxvPu8gO0PsSFVrfDJsoMm
90IfeaggLepCWqNbCN0C
=lifx
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
