Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab2ETSkU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 14:40:20 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60906 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756754Ab2ETSkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 14:40:19 -0400
Message-ID: <1337539215.1745.11.camel@koala>
Subject: Re: [PATCH] UBIFS: add ksa_pos to replay buds, read when replaying
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sun, 20 May 2012 21:40:15 +0300
In-Reply-To: <alpine.DEB.2.00.1205201418170.27583@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205201418170.27583@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-9er1qBiRnbqeAFWZUooY"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9er1qBiRnbqeAFWZUooY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-05-20 at 14:28 +0200, Joel Reardon wrote:
> This patch read the ksa_pos from data nodes to the replay buds when perfo=
rming
> a replay after unclean commit. This is critical for the correctness of th=
e key
> state map, because the keys that are assigned to uncommited data nodes wi=
ll be
> considered "unused" after mounting but will be considered "used" after
> replaying. The ksa_pos values stored in the replay bud are passed to the =
TNC
> using ubifs_tnc_add.
>=20
> This was tested by assigning distinct ksa_pos values and disabling commit=
ing.
> Data was written and then the drive was remounted. The ksa_pos values wer=
e
> read from the journal and outputted while replaying. When the file was la=
ter
> read, it was confirmed that the ksa_pos values were already loaded into t=
he
> TNC.
>=20
> Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>

Pushed to the "joel" branch as well.

--=20
Best Regards,
Artem Bityutskiy

--=-9er1qBiRnbqeAFWZUooY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPuTqPAAoJECmIfjd9wqK08sgQAKe0wqzhOfZHwhCvtaAzJKVE
5W6TYiRF8+MkdM2whHoJ2fWZrbtzPbyzgr/xCQNiExe9UY64qNLBbEyMgK5DXafp
GPBVZq0PYV8rdBPmCs2XBp8S83JmwMHxLVHTdXnwLSyOO16mo6ETyCbGo5dHEL2s
CMFQfpWPMKmk4ey14ihOEyxJOb4IJy+XoUiroqfJVoaMFBdPJTzjssP99Kh7ej44
vroGIqsjGq7KnIlvUW5A9LPQ6Y/ERx4TzZvN4sf6VEZVOn2U4U5ynj/sKrfbYyb3
k2I8gwEOzrtDDkc1RulH8iQb5T0U/nzs6A2sDE1TdPBuDzJ8fTezq/7ORVLXbbtR
p8Zi80oZyBAHJW/4W4Nh6l1aGFeZqAE0Q8yNwSQqayKGHHNRXBJwXu41zKwBEnM/
7ZGjBOiZO0t4VQf3j8idcxhlNmQsSfLKOsypv1GqXtAvO3W6JmGtkks7PTehezGG
WFOCPK2nguj/kiFTeSLivtRwRAvb5PWLdWLDNz6Ce7ci0cs6NqYsGntLlJFeKcUm
EDTIcXv1j0wQ7KgvCIBkeIApchLUkd9V3uQTxpZ1LkyfGBrxnMlNHVFpbr/zZ22d
zXQnErbmHg55BYOwlSVskF3AZvU1yu5h/UTumQuZN6AwkZ+NjHwfcShcuTOZZ8+b
W7PSh3PrdEDMXx+sTpXM
=5jg2
-----END PGP SIGNATURE-----

--=-9er1qBiRnbqeAFWZUooY--

