Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab0CaBwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 21:52:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34502 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757959Ab0CaBwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 21:52:31 -0400
Date: Wed, 31 Mar 2010 12:52:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Julia Lawall <julia@diku.dk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/12] arch/powerpc/kernel: Add missing unlock
Message-Id: <20100331125225.3714c9f6.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.1003291733150.21896@ask.diku.dk>
References: <Pine.LNX.4.64.1003291733150.21896@ask.diku.dk>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__31_Mar_2010_12_52_25_+1100_6WvQH3F2B.u.+QJk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__31_Mar_2010_12_52_25_+1100_6WvQH3F2B.u.+QJk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Julia,

On Mon, 29 Mar 2010 17:33:34 +0200 (CEST) Julia Lawall <julia@diku.dk> wrot=
e:
>
> From: Julia Lawall <julia@diku.dk>
>=20
> Add an unlock before exiting the function.

Thanks for this.

> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__31_Mar_2010_12_52_25_+1100_6WvQH3F2B.u.+QJk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuyqtkACgkQjjKRsyhoI8wchQCeO0mO1cTe2HbjLlJ0XKe7lA7z
Uc4AmgM1Ki+gVC52iFCoEMNOVkFAUsGO
=hDu/
-----END PGP SIGNATURE-----

--Signature=_Wed__31_Mar_2010_12_52_25_+1100_6WvQH3F2B.u.+QJk--
