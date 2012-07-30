Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab2G3NBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 09:01:46 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43591 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab2G3NBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 09:01:45 -0400
Message-ID: <1343653256.1513.6.camel@kyv>
Subject: Re: [PATCH 1/5] ubi: introduce ubi->bad_peb_limit
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: Andrew Victor <linux@maxim.org.za>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, Richard Weinberger <richard@nod.at>,
        Richard Genoud <richard.genoud@gmail.com>
Date: Mon, 30 Jul 2012 16:00:56 +0300
In-Reply-To: <20120719091600.7d55dadb@pixies.home.jungo.com>
References: <1341389164-24409-1-git-send-email-shmulik.ladkani@gmail.com>
	 <1341389164-24409-2-git-send-email-shmulik.ladkani@gmail.com>
	 <1342608053.7530.11.camel@brekeke>
	 <20120719091600.7d55dadb@pixies.home.jungo.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ZTeVIu4ngE3UmaAZqYzc"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZTeVIu4ngE3UmaAZqYzc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-07-19 at 09:16 +0300, Shmulik Ladkani wrote:
> On Wed, 18 Jul 2012 13:40:53 +0300 Artem Bityutskiy <dedekind1@gmail.com>=
 wrote:
> > I've also amended the Kconfig text a tiny bit and dropped the defconfig
> > changes - let's have them separately as a single patch at the end of th=
e
> > series.
>=20
> Wouldn't having the defconfig change as the last patch break things for
> those defconfigs that had explicitly set CONFIG_MTD_UBI_BEB_RESERVE
> other than the default?

OK, fair enough, but let's have it as a 2 separate patches anyway. It is
not a big deal to first change the defconfig, and then actually add the
new option.

--=20
Best Regards,
Artem Bityutskiy

--=-ZTeVIu4ngE3UmaAZqYzc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQFoWJAAoJECmIfjd9wqK0pkEP/3qiMgSgY5BQRyidbhIK/P6w
r+9rBzFUl6qbMXcafATGjqaB+DyjpLMJdmwf9Slm5paNSlEfJRcu1YlgbR94xB2K
pql1CZ7z+U8Pwh7/y6tumV3dGb3+wUsOaVz9XYk5Mi+HMTSM4aDFG/vQ8cT8HM57
GzK/V8KL4gzi/H/WVGMeL9t06mdfKUYdHvnOZ44rL64srl0yLBpdDcmsVVAAE0Wd
2AY4m9bduoHZ6+puGa/nPJHxhYoLJJu8GLsz1KIg4fs1ueI287X5TBWfnftOEOV4
WW0i3YtGIzH5C+2+JHdPJAKf32Ixrj1Vclyw4AKv5I8vOjuFDb2c88y53mdEw5rV
wVEc4aMC5Ps4hsClY4MrhoNiqD5FFUmVCcRRi+PcAPAcm7KA3Y4FEWBndjlQod2z
o4mbw2mjADAv1Mhk2BzDRTXYjv6OJW/iRdw4DK4wnm8b1ItekbZ4Y/cToNfagNTG
F6yWyit2NkWy/MyG8zsduhqYIbJEsQnV340IoEpYWT+TAf1X5+VAcg6soAg7+2TF
AVrExUV/rfpgZhcrbbV+fwYa3xMNE8RqrX320dA2y1Ri3DB9ImcGtkGx9oH+K7ms
UterNzGc3r261HVVAlswsVg7uiFSZ2k1KH42ezaQJCJnsKSzpHCPHZwoqxU0JGzU
WEhWJVAve4r7AAtR1Uci
=Mj/x
-----END PGP SIGNATURE-----

--=-ZTeVIu4ngE3UmaAZqYzc--

