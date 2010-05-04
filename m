Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab0EDL4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 07:56:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51970 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab0EDL4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 07:56:44 -0400
Date: Tue, 4 May 2010 12:56:40 +0100
From: Eric B Munson <ebmunson@us.ibm.com>
To: Anton Blanchard <anton@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Fix performance issue with perf report
Message-ID: <20100504115640.GA6380@us.ibm.com>
References: <20100504111915.GB14636@kryten>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <20100504111915.GB14636@kryten>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 04 May 2010, Anton Blanchard wrote:

>=20
> On a large machine we spend a lot of time in perf_header__find_attr when
> running perf report.=20
>=20
> If we are parsing a file without PERF_SAMPLE_ID then for each sample we c=
all
> perf_header__find_attr and loop through all counter IDs, never finding a =
match.
> As the machine gets larger there are more per cpu counters and we spend an
> awful lot of time in there.
>=20
> The patch below initialises each sample id to -1ULL and checks for this in
> perf_header__find_attr. We may need to do something more intelligent even=
tually
> (eg a hash lookup from counter id to attr) but this at least fixes the mo=
st
> common usage of perf report.
>=20
> Signed-off-by: Anton Blanchard <anton@samba.org>

Acked-by: Eric B Munson <ebmunson@us.ibm.com>

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvgC3gACgkQsnv9E83jkzq7CwCgx4I+8S4bERZMmlzgTJ4O9/4u
shoAoKgGOrEZ8SxcwlPgfH0XM16oAvTB
=LGRw
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
