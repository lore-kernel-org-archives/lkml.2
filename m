Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab2LBThH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 14:37:07 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:55581 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814Ab2LBThF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 14:37:05 -0500
Date: Sun, 2 Dec 2012 20:36:57 +0100
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 00/37] 3.0.54-stable review
Message-ID: <20121202193657.GA13040@nik-comp.linuxbox.cz>
References: <20121130183857.166228045@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <20121130183857.166228045@linuxfoundation.org>
"X-PGP-Key: http://nik.lbox.cz/downloads/nikola.ciprich.asc"
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 8265391 records (last update: 20121202)
X-Spam-Score: N/A (imported whitelist)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

checked this release using linux test project. I don't see any new failures
compared to previous release. I still have some tests failed, which I want
to figure out why (some seem to be missing tools, etc) and fix.
I'd like to check each new release and report.

following tests are currently failing for me:

sysctl03                       FAIL       4   =20
gf18                           FAIL       1   =20
aio01                          FAIL       2   =20
aio02                          FAIL       2   =20
ksm03                          FAIL       6   =20
su01                           FAIL       126 =20
Numa-testcases                 FAIL       1   =20
mail                           FAIL       1   =20

I'll report further when I got this fixed (as well as with results for
other releases).

cheers

nik


On Fri, Nov 30, 2012 at 10:45:47AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.0.54 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sun Dec  2 18:36:43 UTC 2012.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.54-rc1.gz
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h
>=20
> -------------
> Pseudo-Shortlog of commits:
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 3.0.54-rc1
>=20
> Jaehoon Chung <jh80.chung@samsung.com>
>     mmc: sdhci-s3c: fix the wrong number of max bus clocks
>=20
> Jussi Pakkanen <jussi.pakkanen@canonical.com>
>     Input: bcm5974 - set BUTTONPAD property
>=20
> Fenghua Yu <fenghua.yu@intel.com>
>     x86, mce, therm_throt: Don't report power limit and package level the=
rmal throttle events in mcelog
>=20
> Merlin Schumacher <merlin.schumacher@gmail.com>
>     acer-wmi: support for P key on TM8372
>=20
> Chuansheng Liu <chuansheng.liu@intel.com>
>     watchdog: using u64 in get_sample_period()
>=20
> Johan Hovold <jhovold@gmail.com>
>     USB: mct_u232: fix broken close
>=20
> Mauro Carvalho Chehab <mchehab@redhat.com>
>     get_dvb_firmware: fix download site for tda10046 firmware
>=20
> Emil Tantilov <emil.s.tantilov@intel.com>
>     ixgbe: add support for new 82599 device id
>=20
> Emil Tantilov <emil.s.tantilov@intel.com>
>     ixgbe: add support for new 82599 device
>=20
> David Milburn <dmilburn@redhat.com>
>     sata_svw: check DMA start bit before reset
>=20
> joshua.a.hay@intel.com <joshua.a.hay@intel.com>
>     ixgbe: add support for X540-AT1
>=20
> Tilman Schmidt <tilman@imap.cc>
>     bas_gigaset: fix pre_reset handling
>=20
> David Henningsson <david.henningsson@canonical.com>
>     ALSA: hda - Add support for Realtek ALC292
>=20
> Duncan Roe <duncan_roe@acslink.net.au>
>     ALSA: hda - Fix missing beep on ASUS X43U notebook
>=20
> Kailang Yang <kailang@realtek.com>
>     ALSA: hda - Add new codec ALC283 ALC290 support
>=20
> Al Viro <viro@zeniv.linux.org.uk>
>     sparc64: not any error from do_sigaltstack() should fail rt_sigreturn=
()
>=20
> Jan Kara <jack@suse.cz>
>     jbd: Fix lock ordering bug in journal_unmap_buffer()
>=20
> Oliver Hartkopp <socketcan@hartkopp.net>
>     can: bcm: initialize ifindex for timeouts without previous frame rece=
ption
>=20
> Paul Bolle <pebolle@tiscali.nl>
>     radeon: add AGPMode 1 quirk for RV250
>=20
> Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
>     mac80211: deinitialize ibss-internals after emptiness check
>=20
> Darren Hart <dvhart@linux.intel.com>
>     futex: avoid wake_futex() for a PI futex_q
>=20
> Jens Axboe <axboe@kernel.dk>
>     dm: fix deadlock with request based dm and queue request_fn recursion
>=20
> Jiri Engelthaler <engycz@gmail.com>
>     mtd: slram: invalid checking of absolute end address
>=20
> Al Viro <viro@ZenIV.linux.org.uk>
>     PARISC: fix user-triggerable panic on parisc
>=20
> James Bottomley <James.Bottomley@HansenPartnership.com>
>     PARISC: fix virtual aliasing issue in get_shared_area()
>=20
> David Henningsson <david.henningsson@canonical.com>
>     ALSA: hda - Cirrus: Correctly clear line_out_pins when moving to spea=
ker
>=20
> Clemens Ladisch <clemens@ladisch.de>
>     ALSA: ua101, usx2y: fix broken MIDI output
>=20
> Maciej Patelczyk <maciej.patelczyk@intel.com>
>     SCSI: isci: copy fis 0x34 response into proper buffer
>=20
> Bing Zhao <bzhao@marvell.com>
>     mwifiex: report error to MMC core if we cannot suspend
>=20
> Albert Pool <albertpool@solcon.nl>
>     rtlwifi: rtl8192cu: Add new USB ID
>=20
> Boris Ostrovsky <boris.ostrovsky@amd.com>
>     x86, microcode, AMD: Add support for family 16h processors
>=20
> Robert Richter <robert.richter@amd.com>
>     x86-32: Fix invalid stack address while in softirq
>=20
> David S. Miller <davem@davemloft.net>
>     ifenslave: Fix unused variable warnings.
>=20
> Danny Kukawka <danny.kukawka@bisect.de>
>     riva/fbdev: fix several -Wuninitialized
>=20
> Danny Kukawka <danny.kukawka@bisect.de>
>     drivers/block/DAC960: fix -Wuninitialized warning
>=20
> Danny Kukawka <danny.kukawka@bisect.de>
>     drivers/block/DAC960: fix DAC960_V2_IOCTL_Opcode_T -Wenum-compare war=
ning
>=20
> Takashi Iwai <tiwai@suse.de>
>     ALSA: pcmcia - Use pcmcia_request_irq()
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  Documentation/dvb/get_dvb_firmware          |  2 +-
>  Documentation/networking/ifenslave.c        |  2 ++
>  Makefile                                    |  4 ++--
>  arch/parisc/kernel/signal32.c               |  6 ++++--
>  arch/parisc/kernel/sys_parisc.c             |  2 ++
>  arch/sparc/kernel/signal_64.c               |  4 +---
>  arch/x86/include/asm/ptrace.h               | 15 ++++-----------
>  arch/x86/kernel/cpu/mcheck/therm_throt.c    | 29 +++++++----------------=
------
>  arch/x86/kernel/microcode_amd.c             |  4 ++++
>  arch/x86/kernel/ptrace.c                    | 28 +++++++++++++++++++++++=
+++++
>  drivers/ata/sata_svw.c                      | 35 +++++++++++++++++++++++=
++++++++++++
>  drivers/block/DAC960.c                      | 18 ++++++++++--------
>  drivers/gpu/drm/radeon/radeon_agp.c         |  5 ++++-
>  drivers/input/mouse/bcm5974.c               |  3 +++
>  drivers/isdn/gigaset/bas-gigaset.c          | 19 ++++++++++++++++---
>  drivers/md/dm.c                             |  8 +++++++-
>  drivers/mmc/host/sdhci-s3c.c                |  2 +-
>  drivers/mtd/devices/slram.c                 |  2 +-
>  drivers/net/ixgbe/ixgbe_82599.c             |  2 ++
>  drivers/net/ixgbe/ixgbe_common.c            |  1 +
>  drivers/net/ixgbe/ixgbe_main.c              |  6 ++++++
>  drivers/net/ixgbe/ixgbe_type.h              |  3 +++
>  drivers/net/wireless/mwifiex/sdio.c         | 11 ++++++-----
>  drivers/net/wireless/rtlwifi/rtl8192cu/sw.c |  1 +
>  drivers/platform/x86/acer-wmi.c             |  1 +
>  drivers/scsi/isci/request.c                 |  2 +-
>  drivers/usb/serial/mct_u232.c               | 14 ++++++++------
>  drivers/video/riva/fbdev.c                  |  5 ++---
>  fs/jbd/transaction.c                        |  2 ++
>  kernel/futex.c                              | 18 +++++++++++++++++-
>  kernel/watchdog.c                           |  4 ++--
>  net/can/bcm.c                               |  3 +++
>  net/mac80211/ibss.c                         |  8 ++++----
>  sound/pci/hda/patch_cirrus.c                |  1 +
>  sound/pci/hda/patch_realtek.c               |  4 ++++
>  sound/pcmcia/pdaudiocf/pdaudiocf.c          |  2 +-
>  sound/pcmcia/vx/vxpocket.c                  |  2 +-
>  sound/usb/midi.c                            |  8 ++++++--
>  38 files changed, 204 insertions(+), 82 deletions(-)
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 00 Ostrava

tel.:   +420 591 166 214
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlC7rdkACgkQ3xdJJrLygV7BsACcDqZ9bmraNb8RozoqZ4TuTeM4
sZkAnjSr51zsPQGYwuT4X4nu/hKZ4H2t
=BEUP
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
