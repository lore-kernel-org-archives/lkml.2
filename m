Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab2HPEZD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 00:25:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37378 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752461Ab2HPEYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 00:24:48 -0400
Message-ID: <1345091073.824.244.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [v2.6.34-stable 035/165] md: Fix handling for devices from 2TB
 to 4TB in 0.90 metadata.
From: Ben Hutchings <ben@decadent.org.uk>
To: NeilBrown <neilb@suse.de>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 16 Aug 2012 05:24:33 +0100
In-Reply-To: <20120816064631.61c7026d@notabene.brown>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
	 <1345060109-9187-36-git-send-email-paul.gortmaker@windriver.com>
	 <20120816064631.61c7026d@notabene.brown>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-rcOHoTJKbCug7Qe8TqS7"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rcOHoTJKbCug7Qe8TqS7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-08-16 at 06:46 +1000, NeilBrown wrote:
> On Wed, 15 Aug 2012 15:46:19 -0400 Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
>=20
> > From: NeilBrown <neilb@suse.de>
> >=20
> >                    -------------------
> >     This is a commit scheduled for the next v2.6.34 longterm release.
> >     http://git.kernel.org/?p=3Dlinux/kernel/git/paulg/longterm-queue-2.=
6.34.git
> >     If you see a problem with using this for longterm, please comment.
>=20
> This patch fixes one problem but unfortunately introduces another.
> The patch for that 'other' should get sent to linus in the next day or so
> after it has had a chance to sit in -next for a bit.
>=20
> It can be found at:
>  http://neil.brown.name/git?p=3Dmd;a=3Dcommitdiff;h=3D30b798a352052b07c92=
4956dda4ce720b00af711
>=20
> you could either add that patch, or drop this patch until the next cycle.
[...]

This was already backported to 2.6.32, 2.6.33 and 3.0.  So please change
the last sentence of the commit message for your following fix; it will
be needed for all active stable series.

Ben.

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-rcOHoTJKbCug7Qe8TqS7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUCx2Aee/yOyVhhEJAQpQIw/7BPVbNC2DNyhlKr3XR4T7k+nRJG0K/YDL
hj8kP5hYyWBItyDUEWv9RWczm10RSVJt7pFnrBN0LpFfwT2zmVa4h7ZwYy+Z0rvY
mHPt0yRAYfcW8Ix3YYLJfpyBfIyE63FMXT2n9WoNw55zqmqqKVg76fTNEuOgEyAp
PsK37Nrnf9j8lE3s6Vw2q94tiDQPTkOioyCT+sVODGNrd5nTQNcQSZ8+j9sJ7HMC
36EgAWeCHmNUzNsHRfdOVVZ0Zed5gJ5LUUjhHyFyv1CRoA0NiKe54c4U3jkmI2aj
GJLVGGye3/UHf5/Qq4uG8/kq+v2nDAF+qYKz3s4L5HMMBL+p9DNXTpdbTGKGrdt6
wzc65zL3c2+te2/9pGrusDToRZGiyDndAK5kWHZnSoqqt37gf+Y6x+mKpSp9Zqaa
S6aaz0cOU2QSwVuPpQjEHQqLiXTMwpEAV2e8I8QGyuMzqBBvdeSxqBDIdaAiCRIy
nGg8sqLkJlKdJY3urYWFgluwPP4KudCoibTPXy4ocoaUAW2uPTsushRlj3xyyv/j
Ua6KqjsID/0PdDxqGD+q5ILp45JznB4yAY+wfy5fhMRgxKB84e51MUpqqKFa0qNM
DfLEIooTWAG0ZR8+YIdG0zfWVRBZPzKzgYSFmqEFN7Nao1iCDFotr2RzboZbagA0
vijQJDHV4qA=
=rwU4
-----END PGP SIGNATURE-----

--=-rcOHoTJKbCug7Qe8TqS7--
