Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab2LPTwg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 14:52:36 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:44454 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab2LPTwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 14:52:34 -0500
Date: Sun, 16 Dec 2012 20:52:34 +0100
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 00/27] 3.7.1-stable review
Message-ID: <20121216195234.GB4657@nik-comp.linuxbox.cz>
References: <20121214222251.229078963@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i9LlY+UWpKt15+FH"
Content-Disposition: inline
In-Reply-To: <20121214222251.229078963@linuxfoundation.org>
"X-PGP-Key: http://nik.lbox.cz/downloads/nikola.ciprich.asc"
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 8420754 records (last update: 20121216)
X-Spam-Score: N/A (imported whitelist)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i9LlY+UWpKt15+FH
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

compared to 3.7.0, LTP reports no new failed tests..
n.


On Fri, Dec 14, 2012 at 03:01:13PM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.7.1 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sun Dec 16 22:16:56 UTC 2012.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.7.1-rc1.gz
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
>     Linux 3.7.1-rc1
>=20
> Kevin McKinney <klmckinney1@gmail.com>
>     Staging: bcm: Add two products and remove an existing product.
>=20
> Eric Dumazet <edumazet@google.com>
>     rcu: Fix batch-limit size problem
>=20
> Alan Stern <stern@rowland.harvard.edu>
>     USB: EHCI: bugfix: urb->hcpriv should not be NULL
>=20
> Zheng Liu <gnehzuil.liu@gmail.com>
>     perf test: fix a build error on builtin-test
>=20
> Dan Williams <dcbw@redhat.com>
>     cdc-acm: implement TIOCSSERIAL to avoid blocking close(2)
>=20
> Steven Rostedt <srostedt@redhat.com>
>     ring-buffer: Fix race between integrity check and readers
>=20
> Steven Rostedt <srostedt@redhat.com>
>     ring-buffer: Fix NULL pointer if rb_set_head_page() fails
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
> Lan Tianyu <tianyu.lan@intel.com>
>     ACPI / video: Add "Asus UL30VT" to ACPI video detect blacklist
>=20
> Zhang Rui <rui.zhang@intel.com>
>     ACPI / video: ignore BIOS initial backlight value for HP Folio 13-2000
>=20
> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     ACPI / PNP: Do not crash due to stale pointer use during system resume
>=20
> Lan Tianyu <tianyu.lan@intel.com>
>     ACPI / PM: Add Sony Vaio VPCEB1S1E to nonvs blacklist.
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
> Rene Buergel <rene.buergel@sohard.de>
>     ezusb: add dependency to USB
>=20
> Dan Carpenter <dan.carpenter@oracle.com>
>     telephony: ijx: buffer overflow in ixj_write_cid()
>=20
> Boris Ostrovsky <boris.ostrovsky@amd.com>
>     x86,AMD: Power driver support for AMD's family 16h processors
>=20
> Linus Walleij <linus.walleij@linaro.org>
>     clk: ux500: fix bit error
>=20
> Marek Szyprowski <m.szyprowski@samsung.com>
>     mm: dmapool: use provided gfp flags for all dma_alloc_coherent() calls
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  Makefile                            |  4 +-
>  arch/x86/kernel/hpet.c              |  4 +-
>  drivers/acpi/battery.c              | 77 +++++++++++++++++++++++++++++++=
++++++++
>  drivers/acpi/sleep.c                |  8 ++++
>  drivers/acpi/video.c                | 14 +++++++
>  drivers/acpi/video_detect.c         |  8 ++++
>  drivers/clk/ux500/u8500_clk.c       |  2 +-
>  drivers/hwmon/fam15h_power.c        |  4 ++
>  drivers/pnp/pnpacpi/core.c          |  3 ++
>  drivers/staging/bcm/InterfaceInit.c |  3 +-
>  drivers/staging/bcm/InterfaceInit.h |  2 +-
>  drivers/staging/telephony/ixj.c     | 24 ++++++------
>  drivers/usb/class/cdc-acm.c         | 38 +++++++++++++++++++
>  drivers/usb/host/ehci-q.c           | 12 ++----
>  drivers/usb/host/ehci-sched.c       |  4 +-
>  drivers/usb/host/ohci-q.c           | 19 ++++++++++
>  drivers/usb/host/xhci-pci.c         |  7 +++-
>  drivers/usb/misc/Kconfig            |  1 +
>  drivers/usb/serial/cp210x.c         |  1 +
>  drivers/usb/serial/ftdi_sio.c       |  3 +-
>  drivers/usb/serial/ftdi_sio_ids.h   |  6 +++
>  drivers/usb/serial/option.c         | 25 +++++++++++++
>  drivers/usb/storage/Kconfig         |  2 +-
>  kernel/rcutree.c                    | 15 ++++----
>  kernel/trace/ftrace.c               |  2 +-
>  kernel/trace/ring_buffer.c          | 16 ++++++--
>  mm/dmapool.c                        | 31 ++++------------
>  tools/perf/builtin-test.c           | 38 ++++++-------------
>  28 files changed, 278 insertions(+), 95 deletions(-)
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

--i9LlY+UWpKt15+FH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlDOJoIACgkQ3xdJJrLygV43mACgx381IFj+oNXpE29m0WY0cXQ3
z4wAoNbkhlifNNR+6PdCIOD9RtnN345D
=57oh
-----END PGP SIGNATURE-----

--i9LlY+UWpKt15+FH--
