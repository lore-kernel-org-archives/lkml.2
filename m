Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab1JYKnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 06:43:14 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:37794 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab1JYKnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 06:43:13 -0400
Date: Tue, 25 Oct 2011 21:42:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: Tree for Oct 25
Message-Id: <20111025214255.4381ace152ef032ebb9cc740@canb.auug.org.au>
In-Reply-To: <20111025203628.40a1b8a475e32053aa34dabe@canb.auug.org.au>
References: <20111025203628.40a1b8a475e32053aa34dabe@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Oct_2011_21_42_55_+1100_Y_3I+WNeD=r_VjV."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Oct_2011_21_42_55_+1100_Y_3I+WNeD=r_VjV.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 25 Oct 2011 20:36:28 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> It will not be put into the build system referred to below.

Linus convinced me that it may be useful to do the builds anyway, so the
results will start appearing at http://kisskb.ellerman.id.au/linux-next
over the next few hours.  Take the results with a grain of salt, some
failures may have been caused by my merge fixups (and sparc will fail due
to me applying a fix for a bug that no longer exists :-().

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__25_Oct_2011_21_42_55_+1100_Y_3I+WNeD=r_VjV.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOppKvAAoJEECxmPOUX5FEfogQAJS0cWKFUltVyf34Mofkz8Fi
bLzGhZxQBRCl7rjBmVxGYuOkcqphGa55boFDSb8pXs7xcDxhxbi13ud7CCVNaZMW
U/DSXp4GJMW7lPST31uRF9bg4vX84Rs/+/ai19uWeViqtOjNYpG/tdYn99onulA3
T0Bl3Vd/M+zANcmk1Z3Ukpf48aAO9/iC+oXsUrCv867L1H/IYdIfvisCq9tZmfmP
Cv87e56/510+1hLS30xLmZpMZdkWxOZXhvOytn7UhYwfY13d9ohzdtK9Lnsv33v+
5WYuAqdJb4vlS1k5M+r0c/Mw09df267qNOq77vlodVwncvVUkxOwhILL1d8MBQAE
gA3SApZzECV4IOqWnfNA+4zsZN4IIEUF3j0U5sopgvV6TmvVR1RupnASDu0Ud+Wr
eILhml5jN/fdQJlV7eI7aunNp1swyZZXGYBpRIz8veHYPIpOaM4DdtOCqSVhmZtS
OxynMSRvIz/JVVM8ISFMHN9/nmloHi5LAeC6HUIVfE9C5p2xaWJsX1qEKdKTxZuo
oca9sxozLUe8qEFgXW4Cvmx8kbnTIT+q7UGdPLuPUKdfmzocM5n+ePcqwCufgpAe
6+DspxWIOHH/EjvZnsrZvpF4WNZhLEQs/NSSvLxLq4Vk04eB+myicKPKZXELftdi
HwSx3cv8MPNMVrXZVs7V
=IIS7
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Oct_2011_21_42_55_+1100_Y_3I+WNeD=r_VjV.--
