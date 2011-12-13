Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab1LMM5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 07:57:30 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:41768 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab1LMM51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 07:57:27 -0500
Date: Tue, 13 Dec 2011 23:57:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, arnd@arndb.de, alan@lxorguk.ukuu.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 14/17] UAPI: Make linux/patchkey.h easier to parse
Message-Id: <20111213235714.8e1c456786e60acc691b899e@canb.auug.org.au>
In-Reply-To: <1323770653-19177-15-git-send-email-dhowells@redhat.com>
References: <1323770653-19177-1-git-send-email-dhowells@redhat.com>
	<1323770653-19177-15-git-send-email-dhowells@redhat.com>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Dec_2011_23_57_14_+1100_+jiGkaspZ3Ik/jZq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Dec_2011_23_57_14_+1100_+jiGkaspZ3Ik/jZq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Tue, 13 Dec 2011 10:04:10 +0000 David Howells <dhowells@redhat.com> wrot=
e:
>
> Make linux/patchkey.h easier to parse by:
>=20
>  (1) Switching the reinclusion guard and the indirect-inclusion checks in
>      linux/patchkey.h to put the guard around the outside.

Is this part missing, or no longer needed?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__13_Dec_2011_23_57_14_+1100_+jiGkaspZ3Ik/jZq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO50uqAAoJEECxmPOUX5FEEU0P+gNvfLUBHoB88/U1M/MZaCRl
zKxca6V+ECeYxkT9dDdQ9k3/2/L+ulPfGfo2aswk6jO4X/faVGDun4yH7zQil7/x
OX7FmTJKzMdk3T/3tKWzksvMM/1X2a5CegzxP6KCHlw7BvGCsVzYQdUvnAesPyRO
OKPi5CINFM40E3ZSa0OPiL1X8gxAkn22zdqJMcaCbh+gDTpLlsDRBJVCBH5ejvfJ
XS8Dt3pjYC68mns4jN4KwVk5HmUg0JxcG0WBSiDSjgxCwTW4u+pFl4z3qBSlPy0h
ZlBcRETuRKnd/9810vk72C4Ii6r8wMbfRlkvL8YcK/7+4rdv/7kf3Xh5y09ADea0
5XhOPPUk4zC6eYhGRKJbei3yPnoT+4s5jFylKhxFfYpyjX7TpkISNbqK9HOjZkwx
fEHP0T91Nty77T8tq1FEJ1bIPSL92c1CWZxinrOcpuhda68PAMqlPJN7AL8ndowZ
Ke94rHfcdEzOEkI4SHvZOUzP30Ro2o551DHjzj3ArfqAzOUHZl7O0SQs893YC3bb
tHNKa9s0ZxC2PBeR8bKyQ6AHnfFQ0qp+ALEZIEppG1PYsZflhtN14ZvEWnFHDwLF
N17DHKwkbrpFQI9rRMBz/3RBdL9o6C2yWL6X8qp9ZYFjEumxp35FL4nnSbKyGnoj
BMKIcYB8Y1yWNfZU3HZn
=uubS
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Dec_2011_23_57_14_+1100_+jiGkaspZ3Ik/jZq--
