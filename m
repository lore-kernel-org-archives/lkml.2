Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab2EEExX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 00:53:23 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42474 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab2EEExW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 00:53:22 -0400
Date: Sat, 5 May 2012 14:53:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pierre Carrier <pierre@spotify.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rob Landley <rob@landley.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] procfs: expose umask in stat and status
Message-Id: <20120505145309.e815be998ff5df1177dcd2d1@canb.auug.org.au>
In-Reply-To: <1336186227-1941-1-git-send-email-pierre@spotify.com>
References: <1336186227-1941-1-git-send-email-pierre@spotify.com>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__5_May_2012_14_53_09_+1000_RKMWDKumIEjt/tSU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__5_May_2012_14_53_09_+1000_RKMWDKumIEjt/tSU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pierre,

On Sat,  5 May 2012 04:50:27 +0200 Pierre Carrier <pierre@spotify.com> wrot=
e:
>
> +	umask =3D get_task_umask(p);
> +	if (umask >=3D 0)
> +		seq_printf(m, "Umask:\t0%o\n", umask);

Why not use "Umask:\t%#o\n" ? that way you don't get two zeros if the
umask is zero.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__5_May_2012_14_53_09_+1000_RKMWDKumIEjt/tSU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPpLI1AAoJEECxmPOUX5FEOXQP/1kA0sMq1VXKmGUaNKtSQ103
FpPkzOOtZJSIoHSf5CjVO58JDi4mgdQxEQorbJby11zKDSoUEoS5gZ0CD8h7hFIu
6eR0YmlcZBBM31YWN/lkeJCoHzdcSkkgsCC8PbO5y/0NHE8KiSRbW4CxPp4HVZjm
qrjp0ymZ1lXDV660lkpi44Api5BJ5mhAU1mnPZkLFgcWpMSR2Jd+7BrfoPqmAOwZ
2b42VT0qrvau5EdQru5yVxVqBcG4QfwVdw2gn4qraTHho7m+IwBl2niHNTJ8M4j4
poqbU5XhopzCKSlLk+MybLiHQ6L4uHhfiYD+FokwcelQ2zEgWWY+D1JQmPqiY4WI
XxEUpwotgtIE7vxgliJZtCG6UlssVc50PtHWl6jksJfBM5UimCGF1GKi3mZmlgVs
kJQUytjE9etusjiYqODeMqdvTCYW7gSHf//pMAvJP6dTP3KH+/BEEadUa6m6rxTE
7k7uT0KjinpMUl3OMzsXm23wPgAtu2LEzts3rpHo/xk5L2gq2KZOS8cbN++z0fQo
VAD8BmdLphKt9YHhH8TVyFVIfNDM7E8F7yjojjmiEm/9dv64ULQtPImu/gJUL6eN
E5dV2AxXX6IKzBhFntQs40iRpSkbji3ZauS2fJtbt9vJ5mPRJ3x1UPk69tRbuK3O
7rR/xGP4JAWWqlFmPkab
=nTso
-----END PGP SIGNATURE-----

--Signature=_Sat__5_May_2012_14_53_09_+1000_RKMWDKumIEjt/tSU--
