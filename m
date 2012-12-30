Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab2L3Mmq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 07:42:46 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43752 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754466Ab2L3Mmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 07:42:43 -0500
Message-ID: <1356871357.4821.19.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 104/173] rt2x00: Dont let mac80211 send a BAR when an AMPDU
 subframe fails
From: Ben Hutchings <ben@decadent.org.uk>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Sun, 30 Dec 2012 13:42:37 +0100
In-Reply-To: <1356871099.4821.16.camel@deadeye.wl.decadent.org.uk>
References: <20121228190352.097882544@decadent.org.uk>
	 <50DEA41E.6010409@01019freenet.de>
	 <1356871099.4821.16.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Rk0oU8iRbSgWOirThEu1"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Rk0oU8iRbSgWOirThEu1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-12-30 at 13:38 +0100, Ben Hutchings wrote:
> On Sat, 2012-12-29 at 09:04 +0100, Andreas Hartmann wrote:
> > Ben Hutchings wrote:
> > > 3.2-stable review patch.  If anyone has any objections, please let me=
 know.
> > >=20
> > > ------------------
> > >=20
> > > From: Andreas Hartmann <andihartmann@01019freenet.de>
> > >=20
> > > commit be03d4a45c09ee5100d3aaaedd087f19bc20d01f upstream.
> >=20
> > [...]
> >=20
> > This patch is a workaround for
> >=20
> > mac80211: retry sending failed BAR frames later instead of tearing down
> > aggr (http://www.spinics.net/lists/linux-wireless/msg76379.html -
> > f0425beda4d404a6e751439b562100b902ba9c98)
> > See:
> > http://thread.gmane.org/gmane.linux.kernel.wireless.general/83297/focus=
=3D83304
> >=20
> >=20
> > Meanwhile there was a bug report complaining about problems with
> > be03d4a45 when used as STA:
> > http://thread.gmane.org/gmane.linux.drivers.rt2x00.user/1257
> > You can find there a few other workaround proposals.
> [...]
>=20
> OK, I'll drop this for now.  Once this is sorted out, please send to
> stable a complete list of fixes that are needed.

To be clear, I have all of these in the queue:

be03d4a45c09 rt2x00: Don't let mac80211 send a BAR when an AMPDU subframe f=
ails
5b632fe85ec8 mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
ab9d6e4ffe19 Revert: "rt2x00: Don't let mac80211 send a BAR when an AMPDU s=
ubframe fails"

and I'm intending to drop/defer them all.

Ben.

--=20
Ben Hutchings
It is easier to change the specification to fit the program than vice versa=
.

--=-Rk0oU8iRbSgWOirThEu1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUOA2vee/yOyVhhEJAQqr3Q/7B1YJjh+2DlvXxOmxf1fk5+cnrp2umVEB
v8rXx3HlqFyPfECpkk1M6awswtUD3oQsJhjABtQWZ6rlrfz4hPrJ8ATNmCQSpprX
B2t+Hl9DeR19NlZUro71e32ZmQQ67SKON0GHbdt80HMnpmr7B9BRvL5IGnxC9FJz
TkCMS0ZQjoKceqz0H5iLvn+JgEnYPlKj0hhQ9Ene4ooaq4q/zSdiPxG2p7Q9y/ld
6uLodwgWwXTH3jHmBnd8Qg+EsS5+kesVy/jTxt6Xo5Dvtp/yEd7+Ytt9OETxCeyM
SbBgkVRyNF2NqO6p+h34l1rWDvl8IRemDFbma74dO5LvJovMMKw0tNTfI0t8uo8P
XkApTIyRD81RAyiX80AP727NCgar0mM0mNc2RJLaB6FVYfRsKQ+vRGC4XxuqK8R2
ux88c9CzRjFyjX6nmBYWPq3g72XMJ94GgwiuxZDQpA74iAI+nCW1GO46AUggZpsZ
PdKZu1M6WftSxPu6m6zfTRhy7p3q2a+sDX5FrBnPIuPsibgczMTr974koI3bZCk3
PfsLr6LdTMCacj7ZRmUyfzrOmHEXZSVAgI+SbPnCrmzCCXbkeN0en3TPrhgEp/hy
vYeBnS5i8eIfCJtikj2ZyMpbCcV8B7iWXMwDGt1DJkG6Npb4jUMZ+ojznMhyibDi
tPGZG5/nncg=
=YZFB
-----END PGP SIGNATURE-----

--=-Rk0oU8iRbSgWOirThEu1--
