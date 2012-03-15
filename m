Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab2COC6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 22:58:50 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38199 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab2COC6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 22:58:49 -0400
Date: Thu, 15 Mar 2012 13:58:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Hugh Dickins <hughd@google.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, akpm@linux-foundation.org,
        rob.lee@linaro.org, j-pihet@ti.com, khilman@ti.com,
        deepthi@linux.vnet.ibm.com, dan.carpenter@oracle.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kucheria@linaro.org
Subject: Re: [PATCH] cpuidle : fix random hangs with intel_idle
Message-Id: <20120315135841.affff2d75681451d9ddd1a58@canb.auug.org.au>
In-Reply-To: <alpine.LSU.2.00.1203141720360.2003@eggly.anvils>
References: <alpine.LSU.2.00.1203131454500.1335@eggly.anvils>
	<1331770181-800-1-git-send-email-daniel.lezcano@linaro.org>
	<20120315111415.cd119171ac86967aebe85545@canb.auug.org.au>
	<alpine.LSU.2.00.1203141720360.2003@eggly.anvils>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Mar_2012_13_58_41_+1100_NzEer013tQ8qAe_i"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Mar_2012_13_58_41_+1100_NzEer013tQ8qAe_i
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hugh,

On Wed, 14 Mar 2012 17:23:26 -0700 (PDT) Hugh Dickins <hughd@google.com> wr=
ote:
>
> On Thu, 15 Mar 2012, Stephen Rothwell wrote:
> >=20
> > So this needs to go into Rob's tree.  Maybe after Hugh verifies that it
> > fixes his problem.
>=20
> Yes, Daniel got me to try it offline before he posted it.
>=20
> Tested-by: Hugh Dickins <hughd@google.com>

Excellent.

> Personally, I'd recommend including it even before it gets into Rob's
> tree (where it may well be improved upon first): it does a lot to
> improve the usability of linux-next.

OK, so I will add this patch to today's tree (on the assumption that it,
or something better, will be added to Rob's tree soon).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__15_Mar_2012_13_58_41_+1100_NzEer013tQ8qAe_i
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYVrhAAoJEECxmPOUX5FEJx0P/399KGKIvXTRKmCo0reZxUjl
jhL2SR1/1/olupaco8aZbkMXrSlpTyj3Ps9NOMzosKVf6kVRSp2sAaJO1tsr62xs
sXm5sY85rK4e/XntHu5GquEZVDqvYJzTI1VPArZ4npOsC8DWDIn6a/WuZQsqJ2JL
6oEh/kwDQLKB/QFHqJFTStydc+tG5sNpJZwpHiu61a0ZE1veoA+I5FAoNJkf65AE
6hD1jUBtdl+vyA1ByTzMS1sLC/g3a3Vj+cOpJavLGQ+CU0KiStc0e79TLQf7kY1p
WNdeFNtloKiIRA4BstYfM3tfMX+Ka0C3myrYzeX20+YaTsYVgGLPvgwAstqiOPm2
ujUzIcviOx3I2oYJ0ClO2MORefxRJYScnWJi+MsjneY/7+J0IIYb8AlJtPiwoU5B
hk6zQ4uy35gDhaTCo7nw1wa2Ttq0MU+pXVnYbRyIn7367UEFyR7JwczfvFr9H86X
fdOaW78u0fAqCF58nCaCb9f8J3XrVqLF/Cg1/HySMCA1XGPisr0GzEKW5Ny/E5JI
CbHL7/oLnQ791XvSJgG34Fi/SmrSjG9CkRaYWnk2MLx4lVn7HHCXmlyRqcVwTAPC
MRxIahCoOLpD9V1ipV0dA6SqhEejls9tsusGFYRWvaNLrAHl254cu1V8V7KUAk5H
U41wfATtqngZFamjoN9s
=g2rM
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Mar_2012_13_58_41_+1100_NzEer013tQ8qAe_i--
