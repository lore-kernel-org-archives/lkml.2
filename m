Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab1JXFHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 01:07:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:58658 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019Ab1JXFHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 01:07:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,396,1315206000"; 
   d="asc'?scan'208";a="65579298"
Subject: Re: -next: NET_VENDOR_8390 dependencies
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 23 Oct 2011 22:07:22 -0700
In-Reply-To: <CAMuHMdW6hC1JchxVL9-4f58a8Vg7cF+97BbKePxjEDHY3H8wNw@mail.gmail.com>
References: <CAMuHMdW6hC1JchxVL9-4f58a8Vg7cF+97BbKePxjEDHY3H8wNw@mail.gmail.com>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-EFcc7WH1LVdV0FTMYrcl"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1319432843.10258.11.camel@jtkirshe-mobl>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EFcc7WH1LVdV0FTMYrcl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2011-10-23 at 14:21 -0700, Geert Uytterhoeven wrote:
> drivers/net/ethernet/8390/Kconfig:
>=20
> config NET_VENDOR_8390
>         bool "National Semi-conductor 8390 devices"
>         default y
>         depends on NET_VENDOR_NATSEMI && (AMIGA_PCMCIA || PCI || SUPERH |=
| \
>                    ISA || MCA || EISA || MAC || M32R || MACH_TX49XX || \
>                    MCA_LEGACY || H8300 || ARM || MIPS || ZORRO || PCMCIA =
|| \
>                    EXPERIMENTAL)
>         ---help---
>           If you have a network (Ethernet) card belonging to this class, =
say Y
>           and read the Ethernet-HOWTO, available from
>           <http://www.tldp.org/docs.html#howto>.
>=20
>           Note that the answer to this question doesn't directly affect t=
he
>           kernel: saying N will just cause the configurator to skip all
>           the questions about Western Digital cards. If you say Y, you wi=
ll be
>           asked for your specific card in the following questions.
>=20
> So NET_VENDOR_8390 depends on NET_VENDOR_NATSEMI.
>=20
> drivers/net/ethernet/natsemi/Kconfig:
>=20
> config NET_VENDOR_NATSEMI
>         bool "National Semi-conductor devices"
>         default y
>         depends on MCA || MAC || MACH_JAZZ || PCI || XTENSA_PLATFORM_XT20=
00
>         ---help---
>           If you have a network (Ethernet) card belonging to this class, =
say Y
>           and read the Ethernet-HOWTO, available from
>           <http://www.tldp.org/docs.html#howto>.
>=20
>           Note that the answer to this question doesn't directly affect t=
he
>           kernel: saying N will just cause the configurator to skip all
>           the questions about National Semi-conductor devices. If you say=
 Y,
>           you will be asked for your specific card in the following quest=
ions.
>=20
> But NET_VENDOR_NATSEMI will never be true for several of the other
> dependencies of NET_VENDOR_8390 (e.g. AMIGA_PCMCIA, EISA, H8300, ARM,
> ZORRO, PCMCIA)?
>=20

You are correct, I will put together a patch to fix that.  Thanks!

--=-EFcc7WH1LVdV0FTMYrcl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCgAGBQJOpPKKAAoJEOVv75VaS+3Op58P/2ovL0Gp45bCSCDv9hAe+iNg
CoWkoJzEv69OAmmLZRjwiZHNZ2hUk+DuIlAss3JCVDQHfbx7ICXquN1zKGLwfPed
KlqzpC8vHP06RdCg0UQJZoD7THMTAflMLm6cx9vKW9TFq10sjvV2iZJlFDq5+vT2
aTsZ3GIkwS65gHuyE/XaPZoRtaP01Je5R3oUZaVJ5YgrwVgOePC1YYd4/c1Iv8jE
Q3jUS0TfIy1Lq7dsjy9ZZ3RGyIwrQguIdI8ocpjuVLxmT68Kq/f4A3qhizSj0Do4
uKf5JWBZsU/6x8u6OzpHiIkAclEJAPSTk2O5gc1OhuyZkQiR0Gl51CPNDY7pLI8m
9s5+596EmQ/rEosVVduvbnkYFjX8LT8cDZtRHxKMGCXTT6q1UXTu8qCLWnbhbMAs
2foJNYkV4ZifzMkGY44qyUKi9/UBzc+sp2rMMf4BNjUfWPitjoM+dcpRaY/FQQqh
l/jUCeD3UvYHlg8+qT2dtXl1w40TZo/R/j94rJnG3nMozx0EzCg6jZXLId1jsF4P
XgYFVBSeC7zNZ+W9MAFStiQ80zaKBdXeWvC3oaC62ynS+H9gbG/OMasks2Qhty3V
BBwGS6WegINoqB7SjRcegUFR0bCeGyDWhE5zD/yrp+WaKKX/Wl+sWwaoZFbGMPQt
CUVRUb/3zUvB6+Vt0rJ5
=trgz
-----END PGP SIGNATURE-----

--=-EFcc7WH1LVdV0FTMYrcl--

