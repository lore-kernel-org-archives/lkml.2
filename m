Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395Ab2EWKmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 06:42:09 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:49017 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757395Ab2EWKmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 06:42:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoQJAOa9vE9bdWOb/2dsb2JhbABDhS+mViKICYEHghUBAQUjVhALGCoCAlcGiCWncZJ1iw+ELIEUA6UMgmw
X-IronPort-AV: E=Sophos;i="4.75,644,1330902000"; 
   d="asc'?scan'208";a="518546134"
Message-ID: <1337769731.3666.8.camel@fourier.local.igalia.com>
Subject: Re: [PATCH 2/3] Staging: ipack: fix failure registering an ipack
 device
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Wed, 23 May 2012 12:42:11 +0200
In-Reply-To: <20120523104115.GL4637@mwanda>
References: <1337764395-23200-1-git-send-email-siglesias@igalia.com>
	 <1337764395-23200-2-git-send-email-siglesias@igalia.com>
	 <20120523104115.GL4637@mwanda>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-HqFLMZdbBPSpfqaSuO9Z"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HqFLMZdbBPSpfqaSuO9Z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-05-23 at 13:41 +0300, Dan Carpenter wrote:
> On Wed, May 23, 2012 at 11:13:14AM +0200, Samuel Iglesias Gonsalvez wrote=
:
> > Trying to install an ipack device it always failed in the match() funct=
ion. This
> > patch fixes all the bugs present there.
> >=20
>=20
> This looks like part of it is undoing stuff introduced in
> [patch 1/3]?  I was going to ask what the stuff was in 1/3 and then
> it got removed which makes me wonder why even more.  Could you write
> something about why in your changelog?  Or if it's not needed then
> remove it from the first patch.
>=20
> Really it would be easier to review if you broke it up into one
> patch per bug, with a description of what the bugs were instead of
> "patch fixes all the bugs present there".
>=20
> Some of these changes don't seem necessary.  It feels like you were
> debugging and then when you got match() to work you just committed
> all the changes instead of only the lines which are needed.
>=20

Yes, you are right. I will work again on these patches.

Thanks,

Sam


--=-HqFLMZdbBPSpfqaSuO9Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAk+8vwMACgkQWrfbyfmd9eJ5PQCgrTpvUOeCPkPmdjdPWKBORmeI
2V4AoICCQBsW7gdAS/lanaSt43Hvfa/b
=i5kp
-----END PGP SIGNATURE-----

--=-HqFLMZdbBPSpfqaSuO9Z--

