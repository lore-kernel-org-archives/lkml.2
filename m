Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030576Ab2LGOAO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 09:00:14 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:33126 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030557Ab2LGOAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 09:00:11 -0500
Date: Fri, 7 Dec 2012 14:59:55 +0100
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 00/11] 3.0.56-stable review
Message-ID: <20121207135939.GA27442@pcnci.linuxbox.cz>
References: <20121207005613.189054768@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R3G7APHDIzY6R/pk"
Content-Disposition: inline
In-Reply-To: <20121207005613.189054768@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 8327130 records (last update: 20121207)
X-Spam-Score: N/A (imported whitelist)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R3G7APHDIzY6R/pk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

version passed LTP with no new failed tests.

nik



On Thu, Dec 06, 2012 at 04:56:56PM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.0.56 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sun Dec  9 00:55:07 UTC 2012.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.56-rc1.gz
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
>     Linux 3.0.56-rc1
>=20
> Jan Kara <jack@suse.cz>
>     scsi: Silence unnecessary warnings about ioctl to partition
>=20
> Chris Wilson <chris@chris-wilson.co.uk>
>     drm/i915: Add no-lvds quirk for Supermicro X7SPA-H
>=20
> Calvin Walton <calvin.walton@kepstin.ca>
>     i915: Quirk no_lvds on Gigabyte GA-D525TUD ITX motherboard
>=20
> Alan Cox <alan@linux.intel.com>
>     ACPI: missing break
>=20
> Michal Kubecek <mkubecek@suse.cz>
>     route: release dst_entry.hh_cache when handling redirects
>=20
> Mike Galbraith <efault@gmx.de>
>     Revert "sched, autogroup: Stop going ahead if autogroup is disabled"
>=20
> Mike Galbraith <mgalbraith@suse.de>
>     workqueue: exit rescuer_thread() as TASK_RUNNING
>=20
> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>     mm: soft offline: split thp at the beginning of soft_offline_page()
>=20
> Jianguo Wu <wujianguo@huawei.com>
>     mm/vmemmap: fix wrong use of virt_to_page
>=20
> Russell King - ARM Linux <linux@arm.linux.org.uk>
>     Dove: Fix irq_to_pmu()
>=20
> Russell King - ARM Linux <linux@arm.linux.org.uk>
>     Dove: Attempt to fix PMU/RTC interrupts
>=20
>=20
> -------------
>=20
> Diffstat:
>=20
>  Makefile                             |  4 ++--
>  arch/arm/mach-dove/include/mach/pm.h |  2 +-
>  arch/arm/mach-dove/irq.c             | 14 +++++++++++++-
>  block/scsi_ioctl.c                   |  5 ++++-
>  drivers/acpi/processor_driver.c      |  1 +
>  drivers/gpu/drm/i915/intel_lvds.c    | 16 ++++++++++++++++
>  kernel/sched_autogroup.c             |  4 ----
>  kernel/sched_autogroup.h             |  5 -----
>  kernel/workqueue.c                   |  4 +++-
>  mm/memory-failure.c                  |  8 ++++++++
>  mm/sparse.c                          | 10 ++++------
>  net/ipv4/route.c                     |  4 ++++
>  12 files changed, 56 insertions(+), 21 deletions(-)
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
28.rijna 168, 709 00 Ostrava

tel.:   +420 591 166 214
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--R3G7APHDIzY6R/pk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlDB9lsACgkQ3xdJJrLygV5p5ACg5OfHeprwZbNTLVBvSPn0x+LD
XVgAnioNo7SIBBrBBAHPp3LSxhLJsFCw
=8la0
-----END PGP SIGNATURE-----

--R3G7APHDIzY6R/pk--
