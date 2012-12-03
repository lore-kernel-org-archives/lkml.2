Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318Ab2LCVz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 16:55:26 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61354 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab2LCVzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 16:55:25 -0500
Date: Mon, 3 Dec 2012 13:55:21 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.54
Message-ID: <20121203215521.GA8438@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.54 kernel.

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

 Documentation/dvb/get_dvb_firmware          |    2 -
 Documentation/networking/ifenslave.c        |    2 +
 Makefile                                    |    2 -
 arch/parisc/kernel/signal32.c               |    6 +++-
 arch/parisc/kernel/sys_parisc.c             |    2 +
 arch/sparc/kernel/signal_64.c               |    4 ---
 arch/x86/include/asm/ptrace.h               |   15 +++---------
 arch/x86/kernel/cpu/mcheck/therm_throt.c    |   29 +++++------------------
 arch/x86/kernel/microcode_amd.c             |    4 +++
 arch/x86/kernel/ptrace.c                    |   28 ++++++++++++++++++++++
 drivers/ata/sata_svw.c                      |   35 +++++++++++++++++++++++=
+++++
 drivers/block/DAC960.c                      |   18 ++++++++------
 drivers/gpu/drm/radeon/radeon_agp.c         |    5 +++-
 drivers/input/mouse/bcm5974.c               |    3 ++
 drivers/isdn/gigaset/bas-gigaset.c          |   19 ++++++++++++---
 drivers/md/dm.c                             |    8 +++++-
 drivers/mmc/host/sdhci-s3c.c                |    2 -
 drivers/mtd/devices/slram.c                 |    2 -
 drivers/net/ixgbe/ixgbe_82599.c             |    2 +
 drivers/net/ixgbe/ixgbe_common.c            |    1=20
 drivers/net/ixgbe/ixgbe_main.c              |    6 ++++
 drivers/net/ixgbe/ixgbe_type.h              |    3 ++
 drivers/net/wireless/mwifiex/sdio.c         |   11 ++++----
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c |    1=20
 drivers/platform/x86/acer-wmi.c             |    1=20
 drivers/scsi/isci/request.c                 |    2 -
 drivers/usb/serial/mct_u232.c               |   14 ++++++-----
 drivers/video/riva/fbdev.c                  |    5 +---
 fs/jbd/transaction.c                        |    2 +
 kernel/futex.c                              |   18 +++++++++++++-
 kernel/watchdog.c                           |    4 +--
 net/can/bcm.c                               |    3 ++
 net/mac80211/ibss.c                         |    8 +++---
 sound/pci/hda/patch_realtek.c               |    4 +++
 sound/pcmcia/pdaudiocf/pdaudiocf.c          |    2 -
 sound/pcmcia/vx/vxpocket.c                  |    2 -
 sound/usb/midi.c                            |    8 ++++--
 37 files changed, 202 insertions(+), 81 deletions(-)

Al Viro (2):
      PARISC: fix user-triggerable panic on parisc
      sparc64: not any error from do_sigaltstack() should fail rt_sigreturn=
()

Albert Pool (1):
      rtlwifi: rtl8192cu: Add new USB ID

Bing Zhao (1):
      mwifiex: report error to MMC core if we cannot suspend

Boris Ostrovsky (1):
      x86, microcode, AMD: Add support for family 16h processors

Chuansheng Liu (1):
      watchdog: using u64 in get_sample_period()

Clemens Ladisch (1):
      ALSA: ua101, usx2y: fix broken MIDI output

Danny Kukawka (3):
      drivers/block/DAC960: fix DAC960_V2_IOCTL_Opcode_T -Wenum-compare war=
ning
      drivers/block/DAC960: fix -Wuninitialized warning
      riva/fbdev: fix several -Wuninitialized

Darren Hart (1):
      futex: avoid wake_futex() for a PI futex_q

David Henningsson (1):
      ALSA: hda - Add support for Realtek ALC292

David Milburn (1):
      sata_svw: check DMA start bit before reset

David S. Miller (1):
      ifenslave: Fix unused variable warnings.

Duncan Roe (1):
      ALSA: hda - Fix missing beep on ASUS X43U notebook

Emil Tantilov (2):
      ixgbe: add support for new 82599 device
      ixgbe: add support for new 82599 device id

Fenghua Yu (1):
      x86, mce, therm_throt: Don't report power limit and package level the=
rmal throttle events in mcelog

Greg Kroah-Hartman (1):
      Linux 3.0.54

Jaehoon Chung (1):
      mmc: sdhci-s3c: fix the wrong number of max bus clocks

James Bottomley (1):
      PARISC: fix virtual aliasing issue in get_shared_area()

Jan Kara (1):
      jbd: Fix lock ordering bug in journal_unmap_buffer()

Jens Axboe (1):
      dm: fix deadlock with request based dm and queue request_fn recursion

Jiri Engelthaler (1):
      mtd: slram: invalid checking of absolute end address

Johan Hovold (1):
      USB: mct_u232: fix broken close

Jussi Pakkanen (1):
      Input: bcm5974 - set BUTTONPAD property

Kailang Yang (1):
      ALSA: hda - Add new codec ALC283 ALC290 support

Maciej Patelczyk (1):
      SCSI: isci: copy fis 0x34 response into proper buffer

Mauro Carvalho Chehab (1):
      get_dvb_firmware: fix download site for tda10046 firmware

Merlin Schumacher (1):
      acer-wmi: support for P key on TM8372

Oliver Hartkopp (1):
      can: bcm: initialize ifindex for timeouts without previous frame rece=
ption

Paul Bolle (1):
      radeon: add AGPMode 1 quirk for RV250

Robert Richter (1):
      x86-32: Fix invalid stack address while in softirq

Simon Wunderlich (1):
      mac80211: deinitialize ibss-internals after emptiness check

Takashi Iwai (1):
      ALSA: pcmcia - Use pcmcia_request_irq()

Tilman Schmidt (1):
      bas_gigaset: fix pre_reset handling

joshua.a.hay@intel.com (1):
      ixgbe: add support for X540-AT1


--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQvR/JAAoJEDjbvchgkmk++/wQAKfskwma879LIpKsu6FqXBMr
jc4EmM4YFhr0ndX+/KhAmjyT3ic3Kg5lMsuCwEUAUx9GvVOUmC4N2w1p0lozDM2b
ctInId8FJKE26l6TGeGctTK/f6tTyzaMmElZN3IFzmrpCaLLa678XshO5sWIb/0r
QIwtLpzpmi+Edvp6KLXgR2znRs7gFBr00km+G4Nsuo5hjdzGdQNzp98XEaeQ0K+e
zoxw3r1z9YorKODEsHYQe7ve8IjVGPkmeqi3mu4Qw3UOmTQ5h12QzSMvH3eyJDiG
MSgV4k/JcdxlqwlGF06BzCDqTUhmKpEQMmtz4rQ2oRdkEKOVANnByg7yILm7vO4b
GdGhz5tEe0HtsjqKmubUx6ju/u+WYQsE7GFilYImvA/ssHYsIolEMjACVvTUX2hO
3FCMxLBhwtSlYLZb2dwkrDjuU0jXgqFkHFMTD3tLYu2Aj9k679SgHZKdyEqctHsi
5k0OSiusLuGisT9eOBOVul3WUhLxyG4Ja3Bt0rZClMHrywRZVnU9mwj7DVAJBT6r
8+D2FfxrjyMhKkURVOLDhdJX8rQL7KvMA/loBPavx55Fu2CRBPM7NjhHZD7zO7Sa
D9wYXWd1tBqz/JyEibNQ15BKEJyqMitB/njon0jrtThwvwU6FdOKYIq4B+mdBfUC
tR44Myz3KRV6TpiKhtmG
=IS66
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
