Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761507Ab2EJVgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:36:25 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:42800 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761274Ab2EJVgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:36:23 -0400
Message-ID: <1336685777.12189.142.camel@cumari.coelho.fi>
Subject: Re: [PATCH -next] wireless: TI wlxxx depends on MAC80211
From: Luciano Coelho <coelho@ti.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 11 May 2012 00:36:17 +0300
In-Reply-To: <4FAC3249.3060107@xenotime.net>
References: <20120416161121.261ba4e7e38989173accfb16@canb.auug.org.au>
		 <4F8C784B.2040402@xenotime.net>
	 <1336049755.12189.30.camel@cumari.coelho.fi>
	 <4FAC3249.3060107@xenotime.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-pxPS1HMkr0xQLFKJ1VOC"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pxPS1HMkr0xQLFKJ1VOC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey Randy,

On Thu, 2012-05-10 at 14:25 -0700, Randy Dunlap wrote:
> On 05/03/2012 05:55 AM, Luciano Coelho wrote:
>=20
> > On Mon, 2012-04-16 at 12:51 -0700, Randy Dunlap wrote:
> >> From: Randy Dunlap <rdunlap@xenotime.net>
> >>
> >> wl12xx build fails with many undefined symbol errors when MAC80211
> >> and CFG80211 are not enabled, so make WLCORE and WL12XX depend
> >> on MAC80211 (which already depends on CFG80211).
> >>
> >> Here are a few of the many build errors:

[...]

> >> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> >> Cc:	Luciano Coelho <coelho@ti.com>
> >> Cc:	linux-wireless@vger.kernel.org
> >> Cc:	"John W. Linville" <linville@tuxdriver.com>
> >> ---
> >=20
> > Applied! Thanks Randy, and sorry for the delay in pushing this through
> > my tree.
>=20
>=20
>=20
> Ping.
>=20
> This patch is still needed in linux-next of 20120510.

I already applied this patch and sent a pull-request to Linville, but he
hasn't pulled from my tree into wireless-next yet.

Would it make sense for you to pull directly from my tree into
linux-next?

--=20
Cheers,
Luca.

--=-pxPS1HMkr0xQLFKJ1VOC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPrDTRAAoJEKFHnKIaPMX6EkEP/3ae2N54WKbf6C95HVqsJnCF
2skvDCE3ip6OC743HLgh5MrtCxJjFtMF4PhDTiA0zzJ9BZgXDPB74HkPN/yS6RNq
3OamagbL8krEyWsHbvl54HT93xcThAoUCqbpqMLjwu1iAF4KQtZ7V3Z0Ak1uJgJJ
94JES6dYqBI0uVih9Fwl5ngu52h5IDucPOjbIoD/NAtsEkeA9P6OVbqpIj4U2YFl
FZlICJHlRagRD3lrgxfs7/l+8mZRvel6UlNH9fMhwmEqtfL4rqXLTQu5QF+bkB/z
9Hedv931uvb9Xnhvl01IBItY9rHhWCCkoY4XQ3IrAQjcPbwSR+ifYW+P0JDr86Qu
Mg8QopI+pFQ5TW+IgBRZ1QSC+RqGsvsboPe3CDZGlH47z7wAx+RC0v3ytxrbMFz7
MwUtB/oGj3BeciDK7c7CPUhdp4GN17BI3YwFpZXrpvQA3UcCcCdOkx9hUgfw4eWU
10zYyPAUKPcYDRNzsWk88HeVJU6/OA5YU5uJTpOL7iDTqHf5C7MwBwxgLuCPhwuv
gAT/rmBFGR0rsi3lHC78LR+L2mvNVzvYdc28TiE0JiQVITkOHenuNRb5zxpJk3y8
jF1vKA3ZtE+ZfAts4yZLx9/2mV5p97ZH1fGrPE8sMu9/hOFhKUaAiPtWw5sZz3W6
I/FhETJtfq0w7bYeEw92
=f6mM
-----END PGP SIGNATURE-----

--=-pxPS1HMkr0xQLFKJ1VOC--

