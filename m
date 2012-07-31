Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab2GaXM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 19:12:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56504 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754970Ab2GaXMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 19:12:25 -0400
Message-ID: <1343776327.4642.67.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 06/73] mm: compaction: introduce sync-light migration for use
 by compaction
From: Ben Hutchings <ben@decadent.org.uk>
To: Mel Gorman <mgorman@suse.de>
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Dave Jones <davej@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Nai Xia <nai.xia@gmail.com>, Johannes Weiner <jweiner@redhat.com>
Date: Wed, 01 Aug 2012 00:12:07 +0100
In-Reply-To: <20120731170326.GT612@suse.de>
References: <20120731044310.013763753@decadent.org.uk>
	 <20120731044311.917959946@decadent.org.uk>
	 <20120731164203.GD3111@herton-Z68MA-D2H-B3> <20120731170051.GS612@suse.de>
	 <20120731170326.GT612@suse.de>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-xtqFJMM6dRYdwh85fDK2"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xtqFJMM6dRYdwh85fDK2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-07-31 at 18:03 +0100, Mel Gorman wrote:
> On Tue, Jul 31, 2012 at 06:00:51PM +0100, Mel Gorman wrote:
> > On Tue, Jul 31, 2012 at 01:42:04PM -0300, Herton Ronaldo Krzesinski wro=
te:
> > > On Tue, Jul 31, 2012 at 05:43:16AM +0100, Ben Hutchings wrote:
> > > > 3.2-stable review patch.  If anyone has any objections, please let =
me know.
> > > >=20
> > > > ------------------
> > > >=20
> > > > From: Mel Gorman <mgorman@suse.de>
> > > >=20
> > > > commit a6bc32b899223a877f595ef9ddc1e89ead5072b8 upstream.
> > >=20
> > > We need also to pick recent fix dc32f63453f56d07a1073a697dcd843dd3098=
c09 after
> > > applying this one.
> > >=20
> >=20
> > mel@machina:~/git-public/linux-2.6 > git remote update
> > Fetching linux-next
> > Fetching stable
> > Fetching net-next
> > mel@machina:~/git-public/linux-2.6 > git show dc32f63453f56d07a1073a697=
dcd843dd3098c09
> > fatal: bad object dc32f63453f56d07a1073a697dcd843dd3098c09
> >=20
> > What commit is this, where did it come from and why is it needed?
> >=20
>=20
> Bah, I'm an idiot. Yes, this patch should be included as well.

OK, I've added this.

Ben.

--=20
Ben Hutchings
Experience is directly proportional to the value of equipment destroyed.
                                                         - Carolyn Scheppne=
r

--=-xtqFJMM6dRYdwh85fDK2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUBhmR+e/yOyVhhEJAQqAnxAA062TIZgmUeD1NGs8iKvViW2BgVK3i60y
cLZYJ0i+0c2u7skmkA/sEBL25rKCstELjyKoMHAzlKtgOAp8pOhU8mfjy11ZCwZN
/eDVjovaOYVUv2dGs7bBp5A7our8yZiF5fGXaoENli4qx1qzKr6kg2oEDLuJ0y8n
Z5EYTUsynNUBQtwe00RJkz/fu95VpdEAQ2b+y0seA2acaoOicUqZl2IQJWtYXZQr
/Gmk6q7KQGphkuS5faDFXi1MRzb2kqNly4doAIh9PvxxL2uNmCQYROQY39tR78zn
6rGPWwnPetsQwlqYamXfck4uFXZRha38iqIJ+Bpp0t+GJajhYw+aQ+g4JHE++Zj8
W/tRoIqJmtWzP00zg2noR7q70cUZ8cbajlxyn22nl6on8QQXD85L0FEmKh5MP2eA
Gv6YvsIdEh7tJ7JJKzvIrAhIyhoM1vcAgcllUtHNbhkLBf51baW+TDmmhCKsu2Up
QFOxt+tvkk7vSmd0uCDEHS5GsmGxL0UlYNK+YJ3YOcbn3YOGFi75NJ5Sbdosu6d/
Y68jUixL84ih5cnhnf4kJaeQwboV7Q4DPH8uyYm/Fx62NgvHo4b0Wd/hql/CMaip
RZS7w0l2G5nMSMNj8SIcH/wfL4DnMsk2VCcr2/lRscIASnWvVzHs5JNgOAP+XSa7
UtOJyRFaytk=
=Vp0r
-----END PGP SIGNATURE-----

--=-xtqFJMM6dRYdwh85fDK2--
