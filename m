Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab2HEWjb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 18:39:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47512 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753065Ab2HEWja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 18:39:30 -0400
Message-ID: <1344206349.13142.47.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [stable] backport "xen: mark local pages as FOREIGN in the
 m2p_override"
From: Ben Hutchings <ben@decadent.org.uk>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: stable@vger.kernel.org,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Date: Sun, 05 Aug 2012 23:39:09 +0100
In-Reply-To: <alpine.DEB.2.02.1208011401101.4645@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1208011401101.4645@kaball.uk.xensource.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-BR6nFs1QfgjKjt4BXLoS"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BR6nFs1QfgjKjt4BXLoS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-08-01 at 14:34 +0100, Stefano Stabellini wrote:
> Hello,
> I would like to request a backport of the following upstream Linux
> commit to 3.4, 3.3, 3.2, 3.1, 3.0, 2.6.39 and 2.6.38.
> It fixes a deadlock that happens when a Xen frontend driver connects to
> a Xen backend driver in the same domain. A detailed explanation is
> included in the commit message.
>=20
> A simple cherry-pick should work for all the stable versions.
>=20
> Thanks,
>=20
> Stefano
>=20
>=20
> commit b9e0d95c041ca2d7ad297ee37c2e9cfab67a188f
> Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Date:   Wed May 23 18:57:20 2012 +0100
>=20
>     xen: mark local pages as FOREIGN in the m2p_override
[...]

Added to the queue for 3.2, thanks.

Ben.

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-BR6nFs1QfgjKjt4BXLoS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUB72Dee/yOyVhhEJAQrsJhAAufVImA675om7pXaXUul/0CbMvh5WFWAu
mT3FPZHho79ajZOW9BzZFw9eNJuIshxcwcy6D/HxOPErs/zZH4aRUYgsnFFeMYtd
ZAW7ZuK3KarzlDsf9yGeExIjDzqjbQpFqNtrNTpmk8JOAkUO98U8sTv6smxmafkW
CCHMHA1UA58FGXgYpxgJA4mwtRbjWj0W5NvdaeCCX9Vd+GW8rIe71IC3mYXsmXgD
ETOkcvxMSxVsfuzzLQVGQYFt6c4sxe29DdMsuhyA19UXrXaHB4AePCP9/Ali2g44
n61BAsGQpgWz1Ev7B2r+bIgP516H/4wWeiq8PoJ9QydjJAm0Ls4Rku4HcD50jA4Y
+wUHFjGHoGMxIu5owPQzLlUd8CYFdpkRYd86ouuzCEb9uD+rZ6lNcC6wzVrEVrO/
oEBOvajdTVuULML6wMSpPiYzDgNOKWMA6e29s52achfYA9qIepGTxs4DNPNqe5xu
Npx2IqNoKDFjgaKNVsfozTOoTfNjzzZtUU6Uci2j9nsk46RJ7j1jI/gRN8E45LfS
PDTslDtF1r0nvOZOMgLgSMQDbQlZYtIHaAZGNYTPkqF6rQlHFqR4/wgN1AFr12lu
+t26PMZ7pRBI01d04By28kmlqzDpvemFERNnRphOiPGf79n/4FTrXUU5VeoRY2P+
HGEpMdEaJUo=
=xDsu
-----END PGP SIGNATURE-----

--=-BR6nFs1QfgjKjt4BXLoS--
