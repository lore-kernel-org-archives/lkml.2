Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759098Ab2EIMgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 08:36:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42414 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752687Ab2EIMgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 08:36:37 -0400
Message-ID: <1336566991.8274.348.camel@deadeye>
Subject: Re: [ 061/167] [PATCH] nfsd: dont fail unchecked creates of
 non-special files
From: Ben Hutchings <ben@decadent.org.uk>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "J. Bruce Fields" <bfields@redhat.com>,
        Orion Poplawski <orion@cora.nwra.com>
Date: Wed, 09 May 2012 13:36:31 +0100
In-Reply-To: <20120509070758.GC32230@burratino>
References: <20120509055029.588587017@decadent.org.uk>
	 <20120509055038.318026845@decadent.org.uk>
	 <20120509070758.GC32230@burratino>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-4Mae+mImV0InxqDMBhy+"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4Mae+mImV0InxqDMBhy+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-05-09 at 02:07 -0500, Jonathan Nieder wrote:
> Ben Hutchings wrote:
>=20
> > 3.2-stable review patch.
> [...]
> > commit 9dc4e6c4d1182d34604ea40fef641775f5b15456 upstream.
> [...]
> > [bwh: Backported to 3.2: use &resfh, not resfh]
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
>=20
> Looks good.  Greg, I think this backport can be reused for 3.3.y,
> where the upstream patch similarly does not apply for lack of
> v3.4-rc1~40^2~19 ("nfsd4: reduce do_open_lookup() stack usage").

Thanks, I had made a note that this should be queued for 3.3.y as well.

Ben.

--=20
Ben Hutchings
Life is what happens to you while you're busy making other plans.
                                                               - John Lenno=
n

--=-4Mae+mImV0InxqDMBhy+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT6pkz+e/yOyVhhEJAQr9gBAAwoUB+JZcDopSnLF31kpN7fpjOjFk0Iu3
PN4Qnh6Jy1ZL774R0+t8K95VK5x+1kwSw0TGpVmayur/U5FJ/AQwI9sTZUzYNgwb
aPhXU9N4jMedrFn0mcf6UZfvmT9FjLfOMjYhZPScmjEm5bL2BLhVt2tW7y8WEDOG
OXv+lAVxVD6ZkuS620MRpFGmcfB2oQcg4h0p0Iky+u0iJiYSrQt789ubuQ9HVP8d
Jp5cNWOR85IxRPC2ReuelRuYhsJVNJtQ35y7P6It0qlRVmruq2gOtLj3tL5cyZbX
kWepLoF2Dio3yxecNGT1uv2OQKUQvpbkFktfb253HfaCKu1K8kSRO12qQpbp/YV5
Hls06RmoCAYP12aghUpiOC62JZcUUUdhN8lIFDomUvBuicaeBh47wPnG4zP4xm3X
evQrt7/LXbm+lBpsoNQ6HapZJWF44lmVS+LKn8MZwuAuD3Ot1gnXihC50Xq3vN61
XFSin25Q6Mg/H+M2k06oN2Hm0JfwOxpPa1rrgl9Yu48ZyrWd+mh/h9Xt0vnfIKIW
ZnT3byFALerHbJ22IS8qjVHDKfo7lPriSovnbF4L4Avf0q8J//ecX4mnNz+C3Unt
amBSl4p4TzuPn0bs4X0+zTgIHa5hGQ0x2x4cQRKDByaOB2Kmry/TdGYXXyB79n+3
6K/6pvrl0vw=
=pw/B
-----END PGP SIGNATURE-----

--=-4Mae+mImV0InxqDMBhy+--
