Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab0JOFH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 01:07:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:27528 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab0JOFHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 01:07:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,334,1283756400"; 
   d="asc'?scan'208";a="616947920"
Subject: Re: linux-next: build failure after merge of the net tree
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Harvey Harrison <harvey.harrison@gmail.com>
Cc: David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Tantilov, Emil S" <emil.s.tantilov@intel.com>
In-Reply-To: <20101015113854.ae080284.sfr@canb.auug.org.au>
References: <20101015113854.ae080284.sfr@canb.auug.org.au>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-cjIwwdzThmyfIp30ji47"
Organization: Intel Corporation
Date: Thu, 14 Oct 2010 15:07:33 -0700
Message-ID: <1287094053.5247.1.camel@jtkirshe-MOBL1>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cjIwwdzThmyfIp30ji47
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-10-14 at 17:38 -0700, Stephen Rothwell wrote:
> Hi all,
>=20
> After merging the net tree, today's linux-next build (x86_64 allmodconfig=
)
> failed like this:
>=20
> drivers/net/ixgbe/ixgbe_main.c: In function 'ixgbe_configure_dcb':
> drivers/net/ixgbe/ixgbe_main.c:3377: error: implicit declaration of funct=
ion 'ixgbe_dcb_check_config'
>=20
> Caused by commit f32f837b75233588cd4f8542214a30915ab7847b ("ixgbe: remove
> unused functions").
>=20
> Grep is your friend :-)
>=20
> I have used the net tree from next-20101014 for today.

I apologize, this is my fault.  I have a patch coming to resolved the
issue.

--=-cjIwwdzThmyfIp30ji47
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAABAgAGBQJMt38dAAoJECTsCADr/EWUaAAH/A+X2zA4OdKtgb3Y4Ocyyl4/
yQyDcebF2hQOtgCRIuZ9Qyxne6tDqjwjO6Us7RBO4EO4DB7ctgYWHivWAVCQI4DY
0VN9XpobwI0pD9vo0tRZgNzck2cqZdqYeQg7AjPq2ZFizHE9bDCOZA/JsHk5Iakk
btK2po6YbetKWvP86JdiBa8K0OPhCA+0OWAN7k/ApXkYhzZNMb1RZyk3n0SYrexi
uh7mSdCj8RMyrqthuScLIVzmykrPc/HqhqyUq+qN6nE0FDAvnK60QGzens3SAwoo
/OmS7nrrUlrsiZd7hCV3DOe44SocpuCJ/MLCXAmPpRNb9eifti4IoXNspJl4UKY=
=exus
-----END PGP SIGNATURE-----

--=-cjIwwdzThmyfIp30ji47--

