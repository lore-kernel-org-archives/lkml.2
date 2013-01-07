Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab3AGORw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 09:17:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33452 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751844Ab3AGORu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 09:17:50 -0500
Message-ID: <1357568256.26822.18.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 104/173] rt2x00: Dont let mac80211 send a BAR when an AMPDU
 subframe fails
From: Ben Hutchings <ben@decadent.org.uk>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 07 Jan 2013 14:17:36 +0000
In-Reply-To: <20130107081003.GB2984@redhat.com>
References: <20121228190352.097882544@decadent.org.uk>
	 <50DEA41E.6010409@01019freenet.de>
	 <1356871099.4821.16.camel@deadeye.wl.decadent.org.uk>
	 <1356871357.4821.19.camel@deadeye.wl.decadent.org.uk>
	 <20130107080532.GA2984@redhat.com> <20130107081003.GB2984@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-x7yHYfqrH8l2lGT4IWnB"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-x7yHYfqrH8l2lGT4IWnB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-01-07 at 09:10 +0100, Stanislaw Gruszka wrote:
> On Mon, Jan 07, 2013 at 09:05:32AM +0100, Stanislaw Gruszka wrote:
> > > To be clear, I have all of these in the queue:
> > >=20
> > > be03d4a45c09 rt2x00: Don't let mac80211 send a BAR when an AMPDU subf=
rame fails
> > > 5b632fe85ec8 mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FA=
IL
> > > ab9d6e4ffe19 Revert: "rt2x00: Don't let mac80211 send a BAR when an A=
MPDU subframe fails"
> > >=20
> > > and I'm intending to drop/defer them all.
> >=20
> > Patch 3 is a revert of patch 1 (questioned patch). Please apply all 3 p=
atches,
> > or only patch 2.
>=20
> No, actually all 3 patches have to be applied. Because last one, except
> revert, include flag IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL setting in rt=
2x00
> driver, which make patch 2 work.

Andreas said that that after ab9d6e4ffe19 there was still a regression.
But maybe he was confused.  I know I'm confused.

Ben.

--=20
Ben Hutchings
If you seem to know what you are doing, you'll be given more to do.

--=-x7yHYfqrH8l2lGT4IWnB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUOrZAOe/yOyVhhEJAQo5Qw//daY4rkGCjHMUjT/jwbSnN8MgdC2R2zBV
FVLqM4BYkEx6c/8YOHJNTvpdrzhyhGswNeGbim1laJLvFbybPmUB4VAsfW2BqBLX
0KRLGNHGGCGRODg16kLvU7D+wkZB07YC8dBYweZR/oev8fQ/uRVNGJ93nXzHS2e3
jIt7l6vaPnrLJvh2G4WHFAyOXls/mWj6vn4IlPOqkUK9OfAY8kthu3tsNiw3YXvH
wYbZQH1bGmHKj4xA5X6guh+bJUR0N/X7seqfu4S3CvOOWGccoxY66IRuqgxu04hS
qjf7gxCVWPsJ3ire3CkF6CK8HkK1PqPCxPFH9XnmHzUjzzzw8mBLlbRms2d+6Efg
PjX3CgD+W6+Qdv0xRH6V4QURLfwPKDjYfanoARf8XrU/GN0Tw6UHZ/cvTAvaPd2Y
mnpDKNHLf/ORWj5vvD7YTorLlS6bXQ9Yn18uZ8NmCrNA8pO4+jmvCUOgZDCNZ0Lm
zyr41E5KF1wZN5n1MLeaaxWN6d8ir3g9bjhlfL4itfl8em3H57hqTrg8oj8pLp0c
90wyghwXvLAJnrKo2140SHDXrqtU0REdnKea6TCwRXcFqMq8ozqVDh2HlTjWaLQe
tZm/vygrXwVOe3OrbUCgd4iYpZkixMxhcYG+ONoz4zlp27iDfzolSJM6fozowxUz
ozys+v0Sivk=
=pgGm
-----END PGP SIGNATURE-----

--=-x7yHYfqrH8l2lGT4IWnB--
