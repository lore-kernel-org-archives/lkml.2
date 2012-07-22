Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab2GVW6o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 18:58:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52899 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752313Ab2GVW6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 18:58:42 -0400
Message-ID: <1342997912.5132.63.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 00/34] Memory management performance backports for
 -stable
From: Ben Hutchings <ben@decadent.org.uk>
To: Mel Gorman <mgorman@suse.de>
Cc: Stable <stable@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 22 Jul 2012 23:58:32 +0100
In-Reply-To: <1342708604-26540-1-git-send-email-mgorman@suse.de>
References: <1342708604-26540-1-git-send-email-mgorman@suse.de>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-DSFjeOF8GR8EHAGz6UiB"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DSFjeOF8GR8EHAGz6UiB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm about to put 3.2.24 out for review, and it's pretty big already so
I'm going to defer these to 3.2.25.  I haven't forgotten or rejected
them.

Ben.

--=20
Ben Hutchings
73.46% of all statistics are made up.

--=-DSFjeOF8GR8EHAGz6UiB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUAyFmOe/yOyVhhEJAQr+4A/+LaPs/vt/Mj0bM9EEUJcKrCWgkjIhMHTe
yfATasRFvDi4RjlhbxpbEBm6TqiksXH5Kk4thwQaXW+gycpRcx/eevO1IlMZ6kFv
EGPk0d92Jo3p+C9Z/La0v5LgUHHLZw48ycHOthwMrhF91QKwNHrOl852U443LxJd
nKKbJ8w6fu0WhTtEWe90qe9REGGcuxWzVEN1QFXvJe+9K8SXzAgBz1r6a9m7nLWF
eV8Pjb6kR3h1oWnoWAKawRM+rykxrSvLF7KCefWhaTvAxpt9xqH01dhh5eLCj+2x
Adr2qEq2vQHVVPt70xgYU94xXpq4KTfHoh+M9U6SV/FEPAHE5swhXVHtQu9Vy8pf
fNbPmaLPK0fQ0a3kMG3eSSw000HaYYI3INV7DO6Puk2od3hWHjS8x/w5imHtHDR6
Ps+4wu+p2CkKHZSrz8rhIuQXNrXbCBHL6qydoRA88AF2Q2pPMKJebIA+FqU1Gk4d
VFMCdCSTsrkEA2h3TQUThrG1t76CBvg5j934LWaMNq6mv73Uq9jdiYx3g3iPyyLE
zt+b2NTpmFVGyf+dUUlTpSYvX+doZ0qj002wX8EZUnELx/j9JUIMCbjYQ9h27tRT
xftkF+EMFF/4PU0x7Wv+amWIGDHMZ0Z9PehZE2CyrmcsGWUWYVFniYXuUyuSeLPU
3ixrLRhiUUI=
=eYBU
-----END PGP SIGNATURE-----

--=-DSFjeOF8GR8EHAGz6UiB--
