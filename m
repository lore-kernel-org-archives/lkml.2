Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab2DPJb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 05:31:29 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:32832 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752464Ab2DPJb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 05:31:28 -0400
Date: Mon, 16 Apr 2012 12:30:30 +0300
From: Felipe Balbi <balbi@ti.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Greg Ungerer <gerg@uclinux.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] m68k: Make sure {read,write}s[bwl]() are always defined
Message-ID: <20120416093029.GJ30878@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1334516410-5777-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+RZeZVNR8VILNfK"
Content-Disposition: inline
In-Reply-To: <1334516410-5777-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+RZeZVNR8VILNfK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 15, 2012 at 09:00:10PM +0200, Geert Uytterhoeven wrote:
> If CONFIG_ATARI_ROM_ISA is defined (e.g. allmodconfig), musb fails to
> compile with:
>=20
> In file included from drivers/usb/musb/musb_core.h:68,
>                  from drivers/usb/musb/musb_core.c:104:
> drivers/usb/musb/musb_io.h:45: error: conflicting types for =E2=80=98raw_=
insl=E2=80=99
> arch/m68k/include/asm/raw_io.h:200: error: previous definition of =E2=80=
=98raw_insl=E2=80=99 was here
> drivers/usb/musb/musb_io.h:47: error: conflicting types for =E2=80=98raw_=
insw=E2=80=99
> arch/m68k/include/asm/raw_io.h:121: error: previous definition of =E2=80=
=98raw_insw=E2=80=99 was here
> drivers/usb/musb/musb_io.h:52: error: conflicting types for =E2=80=98raw_=
outsl=E2=80=99
> arch/m68k/include/asm/raw_io.h:240: error: previous definition of =E2=80=
=98raw_outsl=E2=80=99 was here
> drivers/usb/musb/musb_io.h:54: error: conflicting types for =E2=80=98raw_=
outsw=E2=80=99
> arch/m68k/include/asm/raw_io.h:161: error: previous definition of =E2=80=
=98raw_outsw=E2=80=99 was here
> make[4]: *** [drivers/usb/musb/musb_core.o] Error 1
>=20
> This happens because musb_io.h provides default implementations for
> {read,write}s[bwl]() on most platforms, some of which conflict with their
> Atari ROM ISA counterparts.
>=20
> To avoid adding a check for CONFIG_ATARI_ROM_ISA to musb_io.h, make sure
> {read,write}s[bwl]() are always defined on m68k, and disable the default
> implementations in musb_io.h on m68k, like is already done for several
> other architectures.
>=20
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Ungerer <gerg@uclinux.org>

Go ahea Geert, here's my ack.

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--x+RZeZVNR8VILNfK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPi+a1AAoJEIaOsuA1yqREBpsP/2kV7VPQdJv/en3pp2/KJLHH
+2NsE6h79UBdSZoeC0vodCnU6m/ncUJYbtn0bLalcSTD6nceKWj5IsGZWCKJI/LI
wgVOYlXrV4GJD+7pq2y96KlrUAg9HQDN6DZtzVKWa35naqO/wT0viaGAYwraqhuu
o3r3OE6giv/sSD17nNCp9REep4ZAdmPbBbbu4V9smAuZr3pr7j5yyza7iM8PfDAB
upViOOIixQrBuFRQw7JQPGDktAMBT6PumiUaal7O3hoTjSMu6T4vn0c5V5WFkzVi
k8WenYzOOryINcsX+hyP/1VLxibyCLuw67KpOMNC4em0sheX/VKGpnW8zr3TGH7R
uxQeb2zbVVnYNjzprlSRNIaqhbl8wP59xZhVyW6DP1EjwDHnkeiIUf3mzXjlVQil
07rJqd2VmBExX7jIfZAnHmK1mxZ84H27gOZ4/8jJhXy9WaXK2NcjZuykjFrCqI1c
ziNmP3WaFmAY2K/84r4TL+wzzXe4Ucl4ztWZdRXAN8yCaUeDNmiv5B02qslzHqI9
DAIEVuvzo9S6rw44guQOEaZJCNzt3iilymn4K/tRGy5JS0b3iAesbFzlE4swNZjt
qf9h+hW0LkxFm0JBcAQsok8R3SkXdXHv+e9rweW3J7Tzszz1+ac+t6+r1cJ9p+Jn
G9XCCieVDzfW6MXjH8ae
=5ILI
-----END PGP SIGNATURE-----

--x+RZeZVNR8VILNfK--
