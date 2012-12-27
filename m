Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab2L0SmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 13:42:03 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45361 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753193Ab2L0SmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 13:42:00 -0500
Message-ID: <1356633712.17740.13.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 152/241] mm: vmscan: fix endless loop in kswapd balancing
From: Ben Hutchings <ben@decadent.org.uk>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 27 Dec 2012 19:41:52 +0100
In-Reply-To: <20121218001656.GB7147@cmpxchg.org>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
	 <1355407206-17100-153-git-send-email-herton.krzesinski@canonical.com>
	 <1355601411.18807.26.camel@deadeye.wl.decadent.org.uk>
	 <20121218001656.GB7147@cmpxchg.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-y3iATUzTYcG0xjGfJHXd"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 151.217.219.247
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-y3iATUzTYcG0xjGfJHXd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-12-17 at 19:16 -0500, Johannes Weiner wrote:
> On Sat, Dec 15, 2012 at 07:56:51PM +0000, Ben Hutchings wrote:
> > On Thu, 2012-12-13 at 11:58 -0200, Herton Ronaldo Krzesinski wrote:
> > > 3.5.7.2 -stable review patch.  If anyone has any objections, please l=
et me know.
> > >=20
> > > ------------------
> > >=20
> > > From: Johannes Weiner <hannes@cmpxchg.org>
> > >=20
> > > commit 60cefed485a02bd99b6299dad70666fe49245da7 upstream.
> > [...]
> >=20
> > Greg, you missed this in 3.{0,4}.y.  I'm attaching the version I used
> > for 3.2.y, which seems to be applicable to 3.0.y.  One or other of thes=
e
> > should work for 3.4.y.
>=20
> Please don't put this in anything earlier than 3.4 as this was the
> first version that exhibited the problem.
>=20
> I apologize for letting it slip into 3.2; a result of failing to
> properly mention the origin of the problem in the changelog, tagging
> it stable for 3.4+, and noticing the email proposing it for 3.2.  Time
> for vacation, I guess... :/

OK, I've queued up a patch to revert this in 3.2.

Ben.

--=20
Ben Hutchings
The world is coming to an end.	Please log off.

--=-y3iATUzTYcG0xjGfJHXd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUNyWcOe/yOyVhhEJAQp0AQ/+Oc+NAjVmEPLtkaTGfJwVJU5se+9o/+Wm
QGMOBSLIGvRVC0hH8CnTAuvUIrTvdWGPE+HqsqoSYU9IUHCPoVDS/2bNBppBW8es
WOS+t9Wt9q4FMm1RpiYcwyQbewaAQySMONITCTTbML51AI3JyDAibIygDy9CVkcp
boPK4SLLuwqBpcNJKT7tG4WSbl95EgwIb9pPbVC3p5jpis7uFTAiH5REA3vKOzCd
a0gqdZKWgFaXcfY8+LBwtz2zU74318BrUX/gOQy8uw4mQzEYnwZA7mgTWlB86BiR
T6Gz2tzanOJySv3ZshX+CftbsKO1cY2oKqAraRRjsG0k8WfYykNTPED75yewr/FF
ZS0VxQRpcoI28nw25XmuhpGZdrTOLWDXsbZ4l7+/6pCe3StkVDf+W8OOO6XLR62Y
eL9zVhLDICq7T7gD+AOviMvAnwjAZQFiOf+lHI3SR6gA175ommfS20yOgIEjxU6L
39/xz0lmGrs+o1h6kuThMNNEEB+CyfQG1HpcKPxbnopr7qLdgv4BgVFAYwopwWOE
nUFvFH1g7rSMt5pq1yqF64FJEg+psQaw4fAIqqzMEqOhvqfMKpxnpdZa13liIMwL
C0hZYFc8Xzd9kaQT2hM7AwLu5DwpkvbQdG+axS2AJkacWmBHTKfTSB67NgXDaStY
V7p5doZc/VQ=
=X5K2
-----END PGP SIGNATURE-----

--=-y3iATUzTYcG0xjGfJHXd--
