Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388Ab1LETh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:37:29 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48411 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab1LETh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:37:28 -0500
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        syed rafiuddin <rafiuddin.sayed@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 8/9] bq27x00: Add miscdevice for each battery with ioctl for reading registers
Date: Mon, 05 Dec 2011 20:37:23 +0100
Message-ID: <5110851.ffWC54aKVq@pali-elitebook>
User-Agent: KMail/4.7.3 (Linux/3.2.0-3-generic; KDE/4.7.3; x86_64; ; )
In-Reply-To: <20111127115416.GA2579@sirena.org.uk>
References: <1316531933-7159-1-git-send-email-pali.rohar@gmail.com> <20111125220448.GA2078@oksana.dev.rtsoft.ru> <20111127115416.GA2579@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart9731082.LbaIvOQOFu"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart9731082.LbaIvOQOFu
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Sunday 27 November 2011 11:54:16 Mark Brown wrote:
> On Sat, Nov 26, 2011 at 02:04:48AM +0400, Anton Vorontsov wrote:
> > What would be more practical, is to allow I2C core to provide
> > userspace interface even for already bound I2C devices.
> >=20
> > That could be some kind of CONFIG_I2C_UNSAFE_DEBUG: when
> > selected I2C core would allow access to all I2C devices. But still,=

> > the niche for such a feature is tiny, so I doubt that it is worth
> > doing at all.
>=20
> I don't know if it's applicable here but if this is a device that has=

> registers that fit within regmap then the regmap API provides a debug=
fs
> interface for dumping the register map as standard.

I do not know regmap api, but I need interface which is easy readable f=
rom C=20
or shell scripts and which can read some registers (numbers 0-N).

These patches I written for Nokia N900. Now I need interface available =
in=20
kernel 2.6.28, which is only version working with Maemo (default N900 s=
ystem).=20
Of course upstreaming *all* N900 drivers is needed, because I belive th=
at one=20
day I will download vanilla kernel and run it on N900.


Anton Vorontsov, is simple debugfs interface (files - or only one file =
- which=20
have names of register numbers) acceptable for upstreaming (instead thi=
s=20
miscdevice with ioctl)?

--=20
Pali Roh=E1r
pali.rohar@gmail.com
--nextPart9731082.LbaIvOQOFu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk7dHXMACgkQi/DJPQPkQ1JgiQCZAXUfKOXKgvZiita2A/aeqYzq
yv8AoIZEwXUdeyNV6gxj6l7FHgmu4x5a
=VAeE
-----END PGP SIGNATURE-----

--nextPart9731082.LbaIvOQOFu--

