Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab1LETU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:20:56 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:35978 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753842Ab1LETUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:20:55 -0500
Date: Mon, 5 Dec 2011 11:23:27 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai.lu@oracle.com>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pciehp: Disable/enable link during slot power off/on
Message-ID: <20111205112327.24102fc8@jbarnes-desktop>
In-Reply-To: <4ED95AD0.7090003@oracle.com>
References: <4ED95AD0.7090003@oracle.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Uqsm4X8GNDWcZbBjciLb3D3"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Uqsm4X8GNDWcZbBjciLb3D3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 02 Dec 2011 15:10:08 -0800
Yinghai Lu <yinghai.lu@oracle.com> wrote:

>=20
> One system have repeater in system board to support gen2 hotplug.
>=20
> Found when EM is removed from some slots, /var/log/message will be full of
> "card present/not present" warning.
>=20
> It turns out root complex still try to train the link to repeater because
> repeater is not reset.
>=20
> This patch will disable link to make repeater could reset properly.
> Also could kill AER during EM removal.
>=20
> Recently when testing hotplug on one system under development, found if b=
oot
> the system without EM, and later hotplug does not work with Linux.
> But other OS is ok.
> The root cause is that bios left link disabled when slot is empty,
> and other OS is playing link disable bit in link ctrl during power on/off.
>=20
> So We could do the same thing to disable/enable link during power off/on.
>=20
> Signed-off-by: Yinghai Lu <yinghai.lu@oracle.com>
>=20

Kenji-san, any comment or chance to test?

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/Uqsm4X8GNDWcZbBjciLb3D3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJO3RovAAoJEIEoDkX4Qk9hnkoP/iG7pO4I0DXRoFKLoAnpNJLH
z5mpdcP9NakHheNO1h5BG5O5tYsQ16Vqwv5fiGgyd5feQGd0oRBXbXppUARWzOf+
S756KrmdZus30tWnvtT+m3WVEXHhkK7d8X5xJo8qW01lkGH4XwqBIXNpLCtYn4h2
ZHiaeZFVY9zWh17x63TMrgawq9hQA0ujcKB9fZGEUClUvr1W7xSIrqX+dz99bPJQ
Cng4iLc3ZoBjdVY7OGV8FFfOOJ+9cbkw4nTIMPOr5NL6vmOh0az6KmHYLSN3AiqK
zudl3TMs7/wI6onS54IIQ2tFz2fJ9laQU2q1chCBI86Oeqrj9zf8npombxeSMjU0
o6pJYUr2Sc5unpxwWeKRs7O65/YuZa/U+KvwzPdxN96QCDuvYfet0CImdriDwAZx
W2dS3vXHriCIBIqXbfP/ZsmJLpzhKrPSQV9uL3Hu78Zqb1p0RrzxaCV5rizOoHMu
1nZ+EW/ITBm2lAfw7XIbmcNk3qbNZAvQm5F6S3LlWzcNO1IMHz5Qo0bcMArSEeZg
CjNNDUEIB6zw7Gd0JoUx4UiXwTvZXeh4ZKY21jaST2nj8k2ZQIidFRYAYrHVRC9P
+g2fH9SDDUBZBdFRqx/Ib9p3p9zmk02KUfNn5wj8NMrlWsLnKDFBY7OXugsGYDEA
VehSPii/iiz5L9jtF58i
=Vyoc
-----END PGP SIGNATURE-----

--Sig_/Uqsm4X8GNDWcZbBjciLb3D3--
