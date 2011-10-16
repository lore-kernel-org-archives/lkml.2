Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab1JPViI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 17:38:08 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:42171 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab1JPViH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 17:38:07 -0400
Date: Mon, 17 Oct 2011 06:38:01 +0900
From: Mattia Dongili <malattia@linux.it>
To: Valdis.Kletnieks@vt.edu
Cc: John Hughes <john@calvaedi.com>, linux-kernel@vger.kernel.org,
        Stelian Pop <stelian@popies.net>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>
Subject: Re: sony-laptop driver: Volume keys on Sony Vaio TX3 don't work
Message-ID: <20111016213800.GA12703@kamineko.org>
References: <4E9ABBF6.3000504@calvaedi.com>
 <4E9ADBD3.4070404@calvaedi.com>
 <4E9B182A.3020101@calvaedi.com>
 <74494.1318789218@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <74494.1318789218@turing-police.cc.vt.edu>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 3.1.0-rc4+ x86_64
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 16, 2011 at 02:20:18PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Sun, 16 Oct 2011 19:45:14 +0200, John Hughes said:
> > >> Even though sony-laptop has code to handle the volume-up/volume-down=
=20
> > >> keys they don't work.  Pressing volume-down gets treated as=20
> > >> SONYPI_EVENT_PKEY_P1 and volume-up as SONYPI_EVENT_PKEY_P2.
>=20
> > Here's a patch that makes the volume keys work for me.  Tested on=20
> > current git
>=20
> > diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/=
sony-laptop.c
>=20
> Do we know if this is applicable to all Sony laptops, or only a few busti=
cated
> models?

I believe the latter is the case, the old A series also had this
problem. Of course applying the patch will break other models (SZ is one
I'm sure about) so there is no actual winner here unless we figure out
how to properly decode keys on sonypi models (this problem is
specifically related to two phase hotkey decoding, see the irq handler).
=2E..I don't have any such old laptop anymore with me.

--=20
mattia
:wq!

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk6bTrgACgkQgpRPaOotLEEfXQCgzYMDpOiUPPnuZFlerM3AL4jX
kEoAnjHYd5WbUV8VANBiUcM7tHJ+T+82
=3ZuU
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
