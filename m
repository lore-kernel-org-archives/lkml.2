Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab2GSUQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 16:16:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41477 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab2GSUQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 16:16:44 -0400
Date: Thu, 19 Jul 2012 13:16:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.4.6
Message-ID: <20120719201641.GA2151@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.6 kernel.

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
 arch/arm/plat-samsung/adc.c                       |    8=20
 drivers/acpi/acpica/nspredef.c                    |    2=20
 drivers/acpi/processor_core.c                     |    6=20
 drivers/clk/clk.c                                 |    9=20
 drivers/hid/hid-apple.c                           |    6=20
 drivers/hid/hid-core.c                            |    7=20
 drivers/hid/hid-ids.h                             |    6=20
 drivers/hwmon/it87.c                              |    2=20
 drivers/input/joystick/xpad.c                     |    6=20
 drivers/input/mouse/bcm5974.c                     |   20 +
 drivers/md/raid1.c                                |    3=20
 drivers/media/dvb/dvb-core/dvbdev.c               |    1=20
 drivers/media/video/cx231xx/cx231xx-audio.c       |    4=20
 drivers/media/video/cx231xx/cx231xx-vbi.c         |    2=20
 drivers/mtd/nand/nandsim.c                        |   12=20
 drivers/net/bonding/bond_debugfs.c                |    2=20
 drivers/net/bonding/bond_main.c                   |    9=20
 drivers/net/ethernet/intel/e1000e/82571.c         |    3=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    3=20
 drivers/net/wireless/iwlegacy/4965-mac.c          |    4=20
 drivers/net/wireless/iwlegacy/common.c            |   14 -
 drivers/net/wireless/rt2x00/rt2x00usb.c           |    2=20
 drivers/platform/x86/intel_ips.c                  |   22 +
 drivers/rpmsg/virtio_rpmsg_bus.c                  |    2=20
 fs/buffer.c                                       |   22 +
 fs/fifo.c                                         |    9=20
 fs/locks.c                                        |    2=20
 include/linux/Kbuild                              |    1=20
 include/linux/hrtimer.h                           |   10=20
 include/linux/sched.h                             |    8=20
 kernel/hrtimer.c                                  |   53 ++--
 kernel/sched/core.c                               |  275 ++++++++++++++++-=
-----
 kernel/sched/idle_task.c                          |    1=20
 kernel/sched/sched.h                              |    2=20
 kernel/time/tick-sched.c                          |    2=20
 kernel/time/timekeeping.c                         |   64 ++++-
 net/mac80211/mlme.c                               |    6=20
 net/wireless/util.c                               |    2=20
 39 files changed, 459 insertions(+), 155 deletions(-)

Anders Kaseorg (1):
      fifo: Do not restart open() if it already found a partner

Bob Moore (1):
      ACPICA: Fix possible fault in return package object repair code

Dave Jones (1):
      Remove easily user-triggerable BUG from generic_setlease

David Dillow (1):
      media: cx231xx: don't DMA to random addresses

Deepak Sikri (1):
      stmmac: Fix for nfs hang on multiple reboot

Eliad Peller (1):
      mac80211: destroy assoc_data correctly if assoc fails

Emmanuel Grumbach (1):
      iwlegacy: don't mess up the SCD when removing a key

Eric W. Biederman (2):
      bonding: debugfs and network namespaces are incompatible
      bonding: Manage /proc/net/bonding/ entries from the netdev events

Federico Fuga (1):
      rpmsg: fix dependency on initialization order

Greg Kroah-Hartman (1):
      Linux 3.4.6

Henrik Rydberg (1):
      Input: bcm5974 - Add support for 2012 MacBook Pro Retina

Herton Ronaldo Krzesinski (1):
      mtd: nandsim: don't open code a do_div helper

Ilia Katsnelson (1):
      Input: xpad - add signature for Razer Onza Tournament Edition

Jean Delvare (1):
      hwmon: (it87) Preserve configuration register bits on init

Jeff Moyer (1):
      block: fix infinite loop in __getblk_slow

John Stultz (3):
      hrtimer: Provide clock_was_set_delayed()
      timekeeping: Fix leapsecond triggered load spike issue
      hrtimer: Update hrtimer base offsets each hrtimer_interrupt

Michal Kazior (1):
      cfg80211: check iface combinations only when iface is running

NeilBrown (1):
      md/raid1: fix use-after-free bug in RAID1 data-check code.

Pawel Moll (1):
      clk: Check parent for NULL in clk_change_rate

Peter Zijlstra (1):
      sched/nohz: Rewrite and fix load-avg computation -- again

Ryan Bourgeois (1):
      HID: add support for 2012 MacBook Pro Retina

Samuel Ortiz (1):
      NFC: Export nfc.h to userland

Santosh Nayak (1):
      media: dvb-core: Release semaphore on error path dvb_register_device()

Stanislaw Gruszka (2):
      rt2x00usb: fix indexes ordering on RX queue kick
      iwlegacy: always monitor for stuck queues

Takashi Iwai (1):
      intel_ips: blacklist HP ProBook laptops

Thomas Gleixner (4):
      timekeeping: Maintain ktime_t based offsets for hrtimers
      hrtimers: Move lock held region in hrtimer_interrupt()
      timekeeping: Provide hrtimer update function
      timekeeping: Add missing update call in timekeeping_resume()

Thomas Renninger (1):
      cpufreq / ACPI: Fix not loading acpi-cpufreq driver regression

Todd Poynor (1):
      ARM: SAMSUNG: fix race in s3c_adc_start for ADC

Tushar Dave (1):
      e1000e: Correct link check logic for 82571 serdes

Yuri Khan (2):
      Input: xpad - handle all variations of Mad Catz Beat Pad
      Input: xpad - add Andamiro Pump It Up pad


--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJQCGspAAoJEDjbvchgkmk+/DQQAL+Bo2piyCAaOOrdGfep7vYl
KyTeYCkqC0mMArpuT1C4JRdGLEJgRy/zMk3FCHH5w4B4QQPYGkb8OgS7NI3R95Pv
Otmnd7JIm+XP3NJjtEJSFMnfharWwZ3tG2z7ePi9N41wBDqTKWNd6drb0w5uQ2HM
w2RhzdfOeVLXf8fPGlLz8HvC3k1xj7udWhYxg/fvO+W1tMgLt9ef2izcFmpQduUH
pJKfJa6OkzQJBdEAXVtaaQbUpq/FTFxD4NRQMJah20vrt+pexQbz8je+BvOLTmwz
OLYLQkofqhEj54yq+2Rnr1FIBLaxdKTCIXfpNONa93i6yGeBRiq1RYO4cxV2KXUK
frdoNHFF07AMZnjaRSGFv29RSTWfrhc4EQO4MpfM42pUioDINwLa1dvb0+aujSNQ
qpyCmpjqayer+LN+nFI15JfgngldA5KfclBaqHyaYgs7/QJGIkau8QMDbuY+2j6O
sMRhKwVR9/E7ovC4qpx5q4PWIIE0ldmhRq12EreiddIWIlYISaqdmZVV0PPwYSkF
U6vpy7w9Sib5IBBxx+nj9OVlM8eyeDiCooor7OisF/A+501p51XFWhtlEPgUhKKn
+H/8S7TYX9IbUZXyyKolyxUFmF3cWIeCCtdH4XCUDeTZm+6OZQbaJ6/k9S7IzVJe
gyuP7wrFelglTjVQo09m
=kE0I
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
