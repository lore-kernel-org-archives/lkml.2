Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387Ab1D0M7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 08:59:37 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41728 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329Ab1D0M7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 08:59:36 -0400
Date: Wed, 27 Apr 2011 08:59:31 -0400
From: Eric B Munson <emunson@mgebm.net>
To: David Laight <David.Laight@ACULAB.COM>
Cc: benh@kernel.crashing.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@elte.hu, acme@ghostprotocols.net, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, anton@samba.org, stable@kernel.org
Subject: Re: [PATCH V4] POWER: perf_event: Skip updating kernel counters if
 register value shrinks
Message-ID: <20110427125930.GB2936@mgebm.net>
References: <20110427121902.GA2936@mgebm.net>
 <AE90C24D6B3A694183C094C60CF0A2F6D8AD03@saturn3.aculab.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Content-Disposition: inline
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6D8AD03@saturn3.aculab.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 27 Apr 2011, David Laight wrote:

> > But it isn't, and it doesn't have trouble with 2^32 - 1. =20
>=20
> what about:
> prev =3D 0x00000001
> val  =3D 0xffffffff

Result is 0xfffffffe and we are fine.
>=20
> 	David
>=20
>=20

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNuBMyAAoJEH65iIruGRnNPtwH/3T5/zvmHE2lShhDQxFFqP+R
mLxZZERXWvuFK/ZTK6dAfrtUJTzPcYjtcnHWJV6xaFekMpk7WST3N9aXUu6RMHIC
JnLrieUbi64dWymjVSjLU5wJRvvLUDCqoKIaR6/zu9QBUiucfWOV4RhAbJh+zqKz
mNWYrObmcjWrdwYsql7or1olXsjCWIr28bFO29Ep3xOKS+oXlLUh2Kt4ktsYDtg1
Fppbl1XrpKq0ZkH+LLNU+D6QEzrcyqK2VBrzjSE6UukXc712iW8AQePf5u1TXQE4
NhNrY39WMDmDalXjdLJdbGaTRsVbD0PBOOeqCepmlS1F6bk4goRmaI9zTLOg2yQ=
=cH+J
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--
