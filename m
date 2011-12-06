Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab1LFPeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 10:34:22 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49998 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754427Ab1LFPeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 10:34:21 -0500
Message-ID: <1323185640.7454.269.camel@deadeye>
Subject: Re: [tip:core/locking] lockdep, rtmutex, bug: Show taint flags on
 error
From: Ben Hutchings <ben@decadent.org.uk>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Date: Tue, 06 Dec 2011 15:34:00 +0000
In-Reply-To: <tip-fbdc4b9a6c29befbcca65e5366e5aaf2abb7a013@git.kernel.org>
References: <1319773015.6759.30.camel@deadeye>
	 <tip-fbdc4b9a6c29befbcca65e5366e5aaf2abb7a013@git.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-M3C6ASRt4vOUbVXur8cb"
X-Mailer: Evolution 3.0.3-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-M3C6ASRt4vOUbVXur8cb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-12-06 at 01:38 -0800, tip-bot for Ben Hutchings wrote:
> Commit-ID:  fbdc4b9a6c29befbcca65e5366e5aaf2abb7a013
> Gitweb:     http://git.kernel.org/tip/fbdc4b9a6c29befbcca65e5366e5aaf2abb=
7a013
> Author:     Ben Hutchings <ben@decadent.org.uk>
> AuthorDate: Fri, 28 Oct 2011 04:36:55 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 6 Dec 2011 08:16:49 +0100
>=20
> lockdep, rtmutex, bug: Show taint flags on error
>=20
> Show the taint flags in all lockdep and rtmutex-debug error messages.
>=20
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/r/1319773015.6759.30.camel@deadeye
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
[...]

If you disagree with a patch, do not silently drop parts of it.  I
demand that you remove my 'Signed-off-by' as this is not the change I
submitted.

Ben.

--=20
Ben Hutchings
Absolutum obsoletum. (If it works, it's out of date.) - Stafford Beer

--=-M3C6ASRt4vOUbVXur8cb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATt416Oe/yOyVhhEJAQqEmhAAjPgL3sa5s6HuwxcKqUoRzj8NjdC3p9Z0
sPzFGKh6q5L5fc00C91xYGJPBrK4AbPkrZn6Qm2J4We4h9sct6y5NXLDkjWgNeRC
q7WL5/ISIcl43P1e/YTVIMyFLsbu0YcuoWf/cqB+f1PVT7q3AC0v8gulQpHjdy6r
Xj2M3ipeHgG2KqkkwkIpYyW06zPPM70C92l5jWTsB5q40xSXTALD6ZnPeuWff19j
R1cax2uxpQgpboCtELk4w8KXn/A7wNlrQXkduy1RfGz+U6wWuQADlNLpHpVuDzrQ
7wHkPUZxiFwNKRNnkLltmitU57ye0nvO4/vIQXHu5QPzDHp05nHIu+Kv4gPNNDJn
6Ey63A1sO/Qs+IiSy+FxUra6XaZBauH21aiR8Z5UsejH3b+gf7vB1e233DGo+3dD
9JPjQgd7ixofNyBdfy6T2OcsRT6rWSpwqqOy1E0KD0EJwBP0vg7yjjIamBabYFAL
I9gpxy9GNaFUXcQk8lp8UC93A7klwzJHAWVGBJsVUB1vLKL9XBYKWbtbdd663VfR
8zlaGMHyUX0tu88NznyK8DwE0OgK0fv0c7b1pnZsgpu6knObXeYMiD27+vQwEZSb
I4o2iNZ9l5NoQfhFf1PFnfLxVa8o/Chx4+2Ck10OU1SocW/NvS/4oJhN5mC0z/OQ
p3dCv/0I1x8=
=0qCo
-----END PGP SIGNATURE-----

--=-M3C6ASRt4vOUbVXur8cb--
