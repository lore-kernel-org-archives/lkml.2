Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933390Ab1J1VAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 17:00:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:45310 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933326Ab1J1VAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 17:00:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,420,1315206000"; 
   d="asc'?scan'208";a="31188163"
Subject: Re: -next: NET_VENDOR_8390 dependencies
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 28 Oct 2011 14:00:43 -0700
In-Reply-To: <CAMuHMdU3H63vx8436fdm_WBuPBwqNxHtPiAO9j6RhMn0VCAy2w@mail.gmail.com>
References: <CAMuHMdW6hC1JchxVL9-4f58a8Vg7cF+97BbKePxjEDHY3H8wNw@mail.gmail.com>
	 <CAMuHMdU3H63vx8436fdm_WBuPBwqNxHtPiAO9j6RhMn0VCAy2w@mail.gmail.com>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-3ZcPwSe+JCs8gslJz0f0"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1319835643.10258.160.camel@jtkirshe-mobl>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3ZcPwSe+JCs8gslJz0f0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2011-10-28 at 13:35 -0700, Geert Uytterhoeven wrote:
> On Sun, Oct 23, 2011 at 23:21, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > drivers/net/ethernet/8390/Kconfig:
> >
> > config NET_VENDOR_8390
> >        depends on NET_VENDOR_NATSEMI && (AMIGA_PCMCIA || PCI ||
> SUPERH || \
> >                   ISA || MCA || EISA || MAC || M32R || MACH_TX49XX
> || \
> >                   MCA_LEGACY || H8300 || ARM || MIPS || ZORRO ||
> PCMCIA || \
> >                   EXPERIMENTAL)
>=20
> > So NET_VENDOR_8390 depends on NET_VENDOR_NATSEMI.
>=20
> > config NET_VENDOR_NATSEMI
> >        depends on MCA || MAC || MACH_JAZZ || PCI ||
> XTENSA_PLATFORM_XT2000
>=20
> > But NET_VENDOR_NATSEMI will never be true for several of the other
> > dependencies of NET_VENDOR_8390 (e.g. AMIGA_PCMCIA, EISA, H8300,
> ARM,
> > ZORRO, PCMCIA)?
>=20
> There's a similar issue with:
>=20
> config NET_VENDOR_I825XX
>         depends on NET_VENDOR_INTEL && (ISA || ISA_DMA_API || ARM || \
>                    ARCH_ACORN || MCA || MCA_LEGACY || SNI_RM || SUN3
> || \
>                    GSC || BVME6000 || MVME16x || EXPERIMENTAL)
>=20
> But:
>=20
> config NET_VENDOR_INTEL
>         depends on PCI || PCI_MSI
>=20
> Gr{oetje,eeting}s,
>=20
>                         Geert=20

Thanks Geert, I will put together a patch to resolve both issues.

--=-3ZcPwSe+JCs8gslJz0f0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCgAGBQJOqxf7AAoJEOVv75VaS+3OocEP/1RPtZdEIse9XE06IYNHDjw/
RnriZMJnbTKzftj74O0V39BvyZt3rfgN+Wxx5ZRICTB/SbAQaUJm2k2Azc2vyBsx
coQzjvlzYPQaYNrZYic/aoKr+izCEq7kVSIuuRb2AoAumF8AjQU+4CsVkQiLacu6
laBdpDj+3vMj3AMB1izWK6oo+u+DUiYKQ+k7CuVBw0qLKiGghkRUNRJMLpXhDWmL
qiJYXx2deHh37wYziIeZyxzGtvL3NO66Y0K/psj4DedlDRFo5zibE8TET+TtKugr
ztNjfQ+8pliuiojo13FVfHwWorst48o/geXxiIbsNObZZAq3IREb4itt7VsTv+Nx
2hU9eEtAQrkHAqAif8VwYncgA3zYZf/Jrl2l0nYHGhCv7A90YVO+8qdSoRM4EMBe
nnGFPIfQXPK0OEF/Vjfx+DWuG+K1xXiyHzko11ncC3bD8UgakPhxeEfku8aykVqU
xoR1zNvb6Ve5RTC/DNJpAo3llqRKAXMq7twKHQCFOEob9t3+g+T1w75SxVLA8dNm
PDyH1+sNpiNVbOICUEX+yRCg+wRZfG7pY95X008nUA1NTaAAcBwPB0+PJ6MSASOT
hpp6OQ/qL303vry4jaWNBNcgo9z0e3Ch/ifuZ5nE1Bxm4P4o7cJTVDbC63ZX/bz6
y2IRJE3+xff8iwsLN19P
=LSzz
-----END PGP SIGNATURE-----

--=-3ZcPwSe+JCs8gslJz0f0--

