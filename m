Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab1HRHrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 03:47:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:31370 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162Ab1HRHrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 03:47:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="38957402"
Subject: Re: [PATCH] checkpatch: do not test/warn of leading whitespace
 before signature tags
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Joe Perches <joe@perches.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        Anish Kumar <anish198519851985@gmail.com>,
        Andy Whitcroft <apw@canonical.com>
Date: Thu, 18 Aug 2011 00:47:11 -0700
In-Reply-To: <1313652390.32547.53.camel@Joe-Laptop>
References: <1313650112-17287-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <1313652390.32547.53.camel@Joe-Laptop>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Q/jX7Zy5m2fn+QlC0gyX"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Message-ID: <1313653632.2128.88.camel@jtkirshe-mobl>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Q/jX7Zy5m2fn+QlC0gyX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-08-18 at 00:26 -0700, Joe Perches wrote:
> On Wed, 2011-08-17 at 23:48 -0700, Jeff Kirsher wrote:
> > From: Bruce Allan <bruce.w.allan@intel.com>
> >=20
> > Commit 2011247 introduced additional style checks for signature tags in
> > patches which is good.  Unfortunately, now whenever patches are checked
> > by piping the output of 'git show' or 'stg show' through checkpatch it
> > warns not to use whitespace before all signature tags since these (and =
the
> > rest of the patch description) are indented.  Remove this test/warning.
>=20
> I think this is not a good idea.
>=20
> checkpatch is meant for patches not git log output.
> indenting signatures can cause other problems later.
>=20
> I think you can avoid this easily by using checkpatch
> option --ignore=3DBAD_SIGN_OFF when using git log output
> as input.

The problem I have with this is that the sign-off's are not bad, they
are by default indented by 'git show' or 'stg show' so checkpatch.pl
should handle the "default" formatting of git/stg and if there is
additional indenting not expected, then the sign-off's should be
considered bad.  If this option is added, then if there were "real"
problems with the sign-off, it would not be displayed.

>=20
> You could also use:
>=20
> git log --format=3D"commit %H%nAuthor: %an <%ae>%nDate:   %aD%n%n%s%n%n%b=
"
>=20
> so that you get the current default --format=3Dmedium
> output without indenting the commit log body.
>=20
>=20

Even doing this does not resolve the "false" warnings" that
checkpatch.pl produces regarding the sign-off's.

--=-Q/jX7Zy5m2fn+QlC0gyX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJOTMN/AAoJECTsCADr/EWUrDwIALCqzTZyWMc53GjcK/8Oz1XO
aZe/YW4epImcP90LbbXKIjLJXD5YOWknzeLHpvADdSDW2DfgNhelee4aswkmZjUl
sAfgW6CE8841SM1YRF9Ij3/PBQzqi9MSIhUR7Ybx1yFL5FeCtEOxBHzwXF00ZLvP
noGP57FEVHy1wlvutcanuE3CgEYNJpSa5jyxusX4B8OTcD/mvucTXCo+llmi7J9k
TntmPVhcswHmKeqY5/GNQAoCHC81e//A1JiCJnX+GZYypByXTBFaAXS3mYz9LlI4
8g3Qqkwq7UiDzm30t4xSa5iUJOdAF/iiZaNjTy5KuhX2UOg1Qvm2vEch1h6goGU=
=s/eQ
-----END PGP SIGNATURE-----

--=-Q/jX7Zy5m2fn+QlC0gyX--

