Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab1KYUyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 15:54:10 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39066 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab1KYUyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 15:54:08 -0500
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        syed rafiuddin <rafiuddin.sayed@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 8/9] bq27x00: Add miscdevice for each battery with ioctl for reading registers
Date: Fri, 25 Nov 2011 21:54:04 +0100
Message-ID: <33058541.3DK13LYaLI@pali-elitebook>
User-Agent: KMail/4.7.3 (Linux/3.2.0-1-generic; KDE/4.7.3; x86_64; ; )
In-Reply-To: <20111125204626.GA25003@oksana.dev.rtsoft.ru>
References: <1316531933-7159-1-git-send-email-pali.rohar@gmail.com> <7780165.E3DXgdWAv1@pali-elitebook> <20111125204626.GA25003@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2662651.PunVPAgCBg"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2662651.PunVPAgCBg
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Saturday 26 November 2011 00:46:26 Anton Vorontsov wrote:
> On Fri, Nov 25, 2011 at 09:30:28PM +0100, Pali Roh=E1r wrote:
> [...]
>=20
> > This interface is not only for BME. Also some popular bq27200.sh sc=
ript
> > which print bq registers in human readable form needs this interfac=
e
> > (with LD_PRELOAD library).
> >=20
> > Link for that shell script http://enivax.net/jk/n900/bq.tar
>=20
> That might be a good excuse to have the raw interface. Although,
> as this is for debugging purposes only, the same effect can be
> accomplished by unloading bq module and using i2c userspace
> interface directly... I guess.
>=20

Yes, unloading bq module and then starting script working. But I think =
that we=20
could have some interface how to access directly to i2c when some i2c m=
odule=20
for chip is loaded.

--=20
Pali Roh=E1r
pali.rohar@gmail.com
--nextPart2662651.PunVPAgCBg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk7QAGwACgkQi/DJPQPkQ1LtowCgw1v9Azk9C3flDna/Q1XI15wk
KK0AnRupK25vliCh6ELTCSSs/Iu7fRzl
=IRoF
-----END PGP SIGNATURE-----

--nextPart2662651.PunVPAgCBg--

