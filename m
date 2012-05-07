Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab2EGD4v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 23:56:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47769 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab2EGD4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 23:56:51 -0400
Date: Mon, 7 May 2012 13:56:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pierre Carrier <pierre@spotify.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/1] lib/vsprintf.c: "%#o",0 becomes '0' instead of '00'
Message-Id: <20120507135642.4f9e2cea233dadc19bfe5761@canb.auug.org.au>
In-Reply-To: <1336353614-7944-1-git-send-email-pierre@spotify.com>
References: <20120507101949.e18a8f3e222b178eeb699cf6@canb.auug.org.au>
	<1336353614-7944-1-git-send-email-pierre@spotify.com>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__7_May_2012_13_56_42_+1000_dIH+81ztHkNa68sD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_May_2012_13_56_42_+1000_dIH+81ztHkNa68sD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon,  7 May 2012 03:20:14 +0200 Pierre Carrier <pierre@spotify.com> wrot=
e:
>
> number()'s behaviour is slighly changed:
> 0 becomes "0" instead of "00" when using the flag SPECIAL and base 8.
>=20
> Before:
> Number\Format  %o    %#o  %x    %#x
>             0     0   00    0   0x0
>             1     1   01    1   0x1
>            16    20  020   10  0x10
>=20
> After:
> Number\Format  %o    %#o  %x    %#x
>             0     0    0    0   0x0
>             1     1   01    1   0x1
>            16    20  020   10  0x10
>=20
> Signed-off-by: Pierre Carrier <pierre@spotify.com>

Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__7_May_2012_13_56_42_+1000_dIH+81ztHkNa68sD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPp0f6AAoJEECxmPOUX5FE2nAP/RS7PlyBwXAR7c0JCMYxJt1R
8xS4nb9D5j8hxpCv03EDhsxJBpl7vpnAxfro2sRRvKh1cd3eJSxdF5csHcii8LHH
DnSpdNqXPzjKRoMnPaXTUfuHEls6UqYFwmLrgUHUZZqGnSpGcEJpK3NuUetz3jrs
pGf6cNQcDa44250wMAhEriLLvrwc4k3veHfPM4Qx2n8Rq3GgtXUan1QZ4wqOWi1o
lFcsgjlVO75sc2ceV/jg8uOSSDNG/P2cYMgf3eO6lOUh4t9cNBs8k2LquWkoJ9tU
r0jNs7sb0ZML4NJF18xoz3b0g139SRNPsgSPq/v0j3gEE2AWSuViivlZOjRlro2g
0BGEwHOQ6Tal51vJ1HawKtDk+NtqdQNhQaEEdvbEl8TCWNQcg0py9LfFzOErkrDD
igI2nQKw8HL9eu6nHEuD01qpHDOJNnComdUm1xGuvm6ZBxKuF4qoSj4IGfHP8UKW
Czu3+U8ZLZKq9ESrD/SLQpy7Hy3CcxRwRl8UwYZEcgo24zmqBs8SxrOKPbThWnxj
cUas1Mc72eU2L/+WPkKLvzicn+GkB4IAVBeiONc3ewhCRy01SjFcWoAg1ESofVJd
vsXWy3gKPvXQm6gkHi/p2GGQBLVKksL8UOZW7mZKYK+fws6BXLrIqs0IZ+OjP+WT
fcJugrN7fM/t6zFgQt5S
=4xKW
-----END PGP SIGNATURE-----

--Signature=_Mon__7_May_2012_13_56_42_+1000_dIH+81ztHkNa68sD--
