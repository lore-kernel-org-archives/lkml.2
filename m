Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab2F2OG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 10:06:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:2624 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374Ab2F2OG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 10:06:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="162249548"
Message-ID: <1340979030.3070.216.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBI: add minimal amount of reserved erase blocks in
 Kconfig
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Genoud <richard.genoud@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Date: Fri, 29 Jun 2012 17:10:30 +0300
In-Reply-To: <CACQ1gAgGbYvTO=_vVW11Ru9OXpra7oiJinbpX=DBiOHmoUtA8g@mail.gmail.com>
References: <1340636918-7505-1-git-send-email-richard.genoud@gmail.com>
	 <1340894351.3070.121.camel@sauron.fi.intel.com>
	 <CACQ1gAjLdR-ZRUS6gxMrJzVpRdvdMK2JRceyiFmeSq-FQkZbZg@mail.gmail.com>
	 <1340900549.3070.130.camel@sauron.fi.intel.com>
	 <CACQ1gAgGbYvTO=_vVW11Ru9OXpra7oiJinbpX=DBiOHmoUtA8g@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-kkzkWzXw6RU6ALgD8oO8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kkzkWzXw6RU6ALgD8oO8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-06-29 at 09:17 +0200, Richard Genoud wrote:
> 2012/6/28 Artem Bityutskiy <dedekind1@gmail.com>:
> > On Thu, 2012-06-28 at 18:07 +0200, Richard Genoud wrote:
> >> Agreed, it seems that 2% of the whole flash (at least for SLC device)
> >> is more realistic.
> >
> > Agree, feel free to send a separate patch for this.
> Done !
> >
> >> > Frankly, I do not understand this logic :-) And your patch looks wro=
ng -
> >> > it touches the "auto-format" code which you may consider more like a
> >> > "debugging" feature and should not rely on this in production.
> >> Sorry, but I don't understand what you mean by the "auto-format" code.
> >
> > Yeah, right, this comment was incorrect, sorry.
> >
>=20
> I was thinking that instead of giving to ubiattach the MBB, we could
> give it the MBB percentage (maximum bad blocks percentage of the whole
> flash device).
> From this % and the whole flash size, we get the MBB number, and set
> beb_rsvd_level for each MTD part.

Well, I thought that it may be not flexible enough for some people,
because you cannot give 1.5%, since flaoting-point arithmetic in the
kernel is not used.

> It will be easier for userspace, as we won't have to set a different
> value for different flash size. The default 2% value will (almost)
> always be correct.
> We can even get rid of the CONFIG_MTD_UBI_BEB_RESERVE option.

Yes, this option would be killed.

> BTW, the real killer feature would be that the flash gives its NVB or
> MBB value in response to the READ_ID command, but unfortunately that's
> not the case...

Sure, you can also implement this. Add the corresponding field to
'struct mtd_info', 0 will mean "not known". UBI could pick it.

--=20
Best Regards,
Artem Bityutskiy

--=-kkzkWzXw6RU6ALgD8oO8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP7bdXAAoJECmIfjd9wqK0b3cP/A9WH5Zoz4yYK48HNrNz4jV2
vUm1jBi1bFIXjadd67Tmtv5YmlW+R4DSa97PqCnDg5jdYVduuDQb8atemyUHf7sM
ORQ3e1ePkOFtNr2wPhV9X81+nEtluB4UPTucFk0/xng9BILeQdeQu4664y56sF2m
iknKEiR//aptSF21Pxd3tQIpLKLsWvB4LMFkjJMdXVmg2hzuOAlxnwwDkDxcSXq0
GtuwzHxxUwuJAyPSHPkXPWPYlLylv4QXrXR+M66y664XknONY0VN+g/Stln8Awuc
sz1IcXahDaZufQPXBm8iUv/0APSriYEFxMfRf5QoglOUs6fJokz5zZspaU3DqSUJ
77nTyVf5YsUSmkFuEB+/AxV/iWKvfPTunrabmL5fBLeI+rwPmcsTpOb2btKw24Wb
FWmFzhm8sd8XPcEZ5wy4HtQrJSQ96ikB3PWbXuhHJ7NaXakJ4mItQ4bpmSlO4Dyj
/UeCg+KWfV8TwrmrqWunv/Zdz2fJT///eAV9oHSD47WP3eFmT8u1fxdE09ubNPlu
6Xj4S0NRKtZosPboxYL1J2I3R2amzMAkwtfH5GrRmAMMEzfCKXro+OZTKq1NMkJp
zQ00P1Hj9Kuh643Z9c5488leZDU0QhxI0F6ouywBPcB7sHV11OQXEnvkICHZff01
XvrBtfiENQ4izLj0SK1M
=ElyE
-----END PGP SIGNATURE-----

--=-kkzkWzXw6RU6ALgD8oO8--

