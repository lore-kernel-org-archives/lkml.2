Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965400Ab2JDOrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 10:47:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34690 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965008Ab2JDOrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 10:47:51 -0400
Message-ID: <1349362057.16173.27.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 022/180] ioat2: kill pending flag
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Thu, 04 Oct 2012 15:47:37 +0100
In-Reply-To: <20121001225158.550410866@1wt.eu>
References: <20121001225158.550410866@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-mcdImmfrdkLs8xJDWZKN"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mcdImmfrdkLs8xJDWZKN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-10-02 at 00:52 +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Dan Williams <dan.j.williams@intel.com>
>=20
> commit 281befa5592b0c5f9a3856b5666c62ac66d3d9ee upstream.
>=20
> The pending =3D=3D 2 case no longer exists in the driver so, we can use
> ioat2_ring_pending() outside the lock to determine if there might be any
> descriptors in the ring that the hardware has not seen.
[...]

What bug does this fix?  Is ioat2_ring_pending() *really* safe to call
without the ring_lock?

Ben.

--=20
Ben Hutchings
For every complex problem
there is a solution that is simple, neat, and wrong.

--=-mcdImmfrdkLs8xJDWZKN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUG2hiee/yOyVhhEJAQq7FA/7BBl4Oc/ts67AS2ve+qYjJ3xJdDgMIYx/
fGCxvUyfQAuMvwB4sXRzYRDg8ikXGD6YRxAi9SktoBJ7LolKD09WY6GVpmxFzOYj
yx0OemnEhHFgODl85BQ5tUvfdt/7cCv+Qyrphg+cEn94wFDLWjaA6T7eZxDC4qzN
fAe911NKmhAFV9wf3ioQeB6JB7YqMxaIjdJvflpf+272DoiVxtOTv8EWPgr+S5Jm
KSZTrmoUOLkKji6HoLgnzmLNxvqtJ42IaqYyALLQ9U3EPFSH66zklXAmwa9VTH62
OoRLUMQyq+rCC23tieMbbBo2eubzWWwcmKWehfPBUE66IfHrzErkQXy9TO+qxhu+
xzxmlaZ3kB8vJbbArtMPsGs8Dum0fy+hsePPG1I6z03Du9L26fFoXyypS3nmgOjK
HKSjlXCaaD/Uy9lm4DyFXtP+nltnq3IyKG6MBKkzgSnPlYmumdi009WG11sXAKFT
L9H8J6P105edlqvg50p8Ah7RmiJJ90qlosdICA7jjuwaJMTjfqDgJQaDNmYYK0XT
JMLZ88nZ6i1jCpCUlsTDRr8BmHq7UX/43aRuk7j/3+XXrazSxT8GyjBeQ5oqzQmn
WxmIlc//CIdgLARYaBObg3mgXswFXPsS0AXXqgIpQGqThOumuj2kvjXX9x/TZY2q
mtN7+7JOKWI=
=XTxF
-----END PGP SIGNATURE-----

--=-mcdImmfrdkLs8xJDWZKN--
