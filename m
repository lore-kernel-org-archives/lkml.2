Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab2HTIUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 04:20:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:3096 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750Ab2HTIUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 04:20:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,796,1336374000"; 
   d="asc'?scan'208";a="206197564"
Message-ID: <1345451128.2848.14.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 5/8] UBI: check max_beb_per1024 value in
 ubi_attach_mtd_dev
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
Date: Mon, 20 Aug 2012 11:25:28 +0300
In-Reply-To: <CACQ1gAgLirwiwiUOoL7ig7R_RpB8xDr2-g2gVOEUZNvAHB60pQ@mail.gmail.com>
References: <1345214124-5478-1-git-send-email-richard.genoud@gmail.com>
	 <1345214124-5478-6-git-send-email-richard.genoud@gmail.com>
	 <20120819120804.15c33931@pixies.home.jungo.com>
	 <CACQ1gAgLirwiwiUOoL7ig7R_RpB8xDr2-g2gVOEUZNvAHB60pQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-S+THycFNlnRdkA1nVaUr"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-S+THycFNlnRdkA1nVaUr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-08-20 at 08:31 +0200, Richard Genoud wrote:
> That's right, I'll correct that in next version.
> Thanks !

I've amended this patch, added Shmulik's reviewed-by and pushed to
linux-ubi.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-S+THycFNlnRdkA1nVaUr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQMfR4AAoJECmIfjd9wqK0Ax4QAMkh31Tjvg/t8bnxBcCfag1r
oEZxItVyO7+tS2Ve7QG38rVVE8dwr/gcz2kkELCJSnLFNXDwJSwROJ0QH1JOVfYU
Rtl19BmWm2g083WsTjw+b4R+qCuPa/gReB1H8V4au12Bh/Ew6JWvTUQOzoAW45+i
AgS6i6r8zoTnyslx8yUg0nQoSD+iwCLYG2Jsql5T5zFHpjKWK8pwrg3cQoLAtGEh
LzkbT8wY2+6ZWOSIhCw8a1jYYJdRgdBkm1chjeFkV4TNKRe4D95868/Z0RHYUG6q
c+ySVNhdfplMWu+pVAKGRjAR7vVm+a4Oxx1pRVxb1lk1ZCsk2d3Gyx0MwczDGPP1
3kFmDpc8aSmsBKsHOMjg/qFULRK1lpnVzMCusNfaTj26pQSSzIzciQ5Er87u9A4j
QS39f7t32TmX7IQbuShHVDK02/KknqcONGAq+7Oc8q7Hm00+yZU6HnG5DSPmqm3U
nYUW5PTJIHbQNYrUycQjTW8b+xNgH64I+djpBo1u1QNAO3M5MyK2cKp1jjB0HSZ6
B3gYOBVU9GGx8289qAQ/8vUw9rZWkkwK0IvGpwaa+DzV25WpXubJWSsxvHkd6qJE
qmytxNtM7wlKv7QIikW4BumwMB2CynorvEvB7HrbpjAzDn2WEoGJVr8NIt/tD7fU
TdQsDEygK9KWoN5bQcLZ
=o5Ws
-----END PGP SIGNATURE-----

--=-S+THycFNlnRdkA1nVaUr--

