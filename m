Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab2LPIcr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 03:32:47 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:59305 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab2LPIcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 03:32:46 -0500
Date: Sun, 16 Dec 2012 09:32:46 +0100
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, nik@nik-comp.linuxbox.cz
Subject: Re: [ 00/22] 3.0.57-stable review
Message-ID: <20121216083246.GA4657@nik-comp.linuxbox.cz>
References: <20121214222249.889051473@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <20121214222249.889051473@linuxfoundation.org>
"X-PGP-Key: http://nik.lbox.cz/downloads/nikola.ciprich.asc"
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 8415139 records (last update: 20121216)
X-Spam-Score: N/A (imported whitelist)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

LTP reports no new failed tests compared to 3.0.56

n.


On Fri, Dec 14, 2012 at 02:25:45PM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.0.57 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sun Dec 16 22:16:57 UTC 2012.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.57-rc1.gz
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
>     Linux 3.0.57-rc1
>=20
> Anton Blanchard <anton@samba.org>
>     powerpc: Keep thread.dscr and thread.dscr_inherit in sync
>=20
> Anton Blanchard <anton@samba.org>
>     powerpc: Update DSCR on all CPUs when writing sysfs dscr_default
>=20
> Dan Carpenter <dan.carpenter@oracle.com>
>     ftrace: Clear bits properly in reset_iter_read()
>=20
> Sarah Sharp <sarah.a.sharp@linux.intel.com>
>     xhci: Extend Fresco Logic MSI quirk.
>=20
> Alan Stern <stern@rowland.harvard.edu>
>     USB: OHCI: workaround for hardware bug: retired TDs not added to the =
Done Queue
>=20
> Zhang Rui <rui.zhang@intel.com>
>     ACPI / video: ignore BIOS initial backlight value for HP Folio 13-2000
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     ACPI / PNP: Do not crash due to stale pointer use during system resume
>=20
> Kamil Iskra <kamil@iskra.name>
>     ACPI / battery: Correct battery capacity values on Thinkpads
>=20
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     USB: mark uas driver as BROKEN
>=20
> Markus Becker <mab@comnets.uni-bremen.de>
>     USB: cp210x: add Virtenio Preon32 device id
>=20
> Peter Korsgaard <jacmet@sunsite.dk>
>     usb: ftdi_sio: fixup BeagleBone A5+ quirk
>=20
> Martin Teichmann <lkb.teichmann@gmail.com>
>     USB: ftdi_sio: Add support for Newport AGILIS motor drivers
>=20
> Bj=F8rn Mork <bjorn@mork.no>
>     USB: option: blacklist network interface on Huawei E173
>=20
> li.rui27@zte.com.cn <li.rui27@zte.com.cn>
>     USB: add new zte 3g-dongle's pid to option.c
>=20
> Jan Beulich <JBeulich@suse.com>
>     x86: hpet: Fix masking of MSI interrupts
>=20
> Mel Gorman <mgorman@suse.de>
>     tmpfs: fix shared mempolicy leak
>=20
> Dan Carpenter <dan.carpenter@oracle.com>
>     telephony: ijx: buffer overflow in ixj_write_cid()
>=20
> Boris Ostrovsky <boris.ostrovsky@amd.com>
>     x86,AMD: Power driver support for AMD's family 16h processors
>=20
> Marek Szyprowski <m.szyprowski@samsung.com>
>     mm: dmapool: use provided gfp flags for all dma_alloc_coherent() calls
>=20
> Tejun Heo <tj@kernel.org>
>     workqueue: convert BUG_ON()s in __queue_delayed_work() to WARN_ON_ONC=
E()s
>=20
> Benjamin Herrenschmidt <benh@kernel.crashing.org>
>     powerpc/ptrace: Fix build with gcc 4.6
>=20
> Paul Walmsley <paul@pwsan.com>
>     ARM: 7566/1: vfp: fix save and restore when running on pre-VFPv3 and =
CONFIG_VFPv3 set
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  Makefile                          |  4 +-
>  arch/arm/include/asm/hwcap.h      |  3 +-
>  arch/arm/include/asm/vfpmacros.h  | 12 +++---
>  arch/arm/vfp/vfpmodule.c          |  9 +++--
>  arch/powerpc/kernel/ptrace.c      | 18 +++++++--
>  arch/powerpc/kernel/sysfs.c       | 10 +++++
>  arch/powerpc/kernel/traps.c       |  3 +-
>  arch/x86/kernel/hpet.c            |  4 +-
>  drivers/acpi/battery.c            | 77 +++++++++++++++++++++++++++++++++=
++++++
>  drivers/acpi/video.c              | 14 +++++++
>  drivers/hwmon/fam15h_power.c      |  4 ++
>  drivers/pnp/pnpacpi/core.c        |  3 ++
>  drivers/telephony/ixj.c           | 24 ++++++------
>  drivers/usb/host/ohci-q.c         | 19 ++++++++++
>  drivers/usb/host/xhci-pci.c       |  7 +++-
>  drivers/usb/serial/cp210x.c       |  1 +
>  drivers/usb/serial/ftdi_sio.c     |  3 +-
>  drivers/usb/serial/ftdi_sio_ids.h |  6 +++
>  drivers/usb/serial/option.c       | 25 +++++++++++++
>  drivers/usb/storage/Kconfig       |  2 +-
>  include/linux/mempolicy.h         | 16 --------
>  kernel/trace/ftrace.c             |  2 +-
>  kernel/workqueue.c                |  4 +-
>  mm/dmapool.c                      | 31 ++++------------
>  mm/mempolicy.c                    | 22 -----------
>  mm/shmem.c                        | 22 ++++++-----
>  26 files changed, 236 insertions(+), 109 deletions(-)
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

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlDNhy4ACgkQ3xdJJrLygV5nvQCghVUfUB3tj1N7bgSJjGn5Qd5C
yAIAn2y/asVCQ30SPcmWYWcXFQr313TS
=6qy4
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
