Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761626Ab2CPMcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 08:32:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:16356 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab2CPMcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 08:32:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="139906220"
Message-ID: <1331901281.3730.64.camel@sauron.fi.intel.com>
Subject: Re: [RESEND PATCH] mtd: fix section mismatch for doc_probe_device
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Ryosuke Saito <raitosyo@gmail.com>
Cc: dwmw2@infradead.org, robert.jarzmik@free.fr, mikedunn@newsguy.com,
        ivan.djelic@parrot.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Fri, 16 Mar 2012 14:34:41 +0200
In-Reply-To: <CADTWAOL7aBi64yimwPubAJ22=4AQ1BRjzQCahUXUsbSa1oJ59A@mail.gmail.com>
References: <CADTWAOL7aBi64yimwPubAJ22=4AQ1BRjzQCahUXUsbSa1oJ59A@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Sq6XX+Lyk/QEEAH9S7f+"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Sq6XX+Lyk/QEEAH9S7f+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-03-15 at 19:19 +0900, Ryosuke Saito wrote:
> doc_probe_device() is only called from docg3_probe() which is in .init.te=
xt,
> so it must be in the same section to avoid a section mismatch warning.
>=20
> Signed-off-by: Ryosuke Saito <raitosyo@gmail.com>

I've fixed up your patch and push to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-Sq6XX+Lyk/QEEAH9S7f+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPYzNhAAoJECmIfjd9wqK0xYYP/1kXxueKJVgNVovBD558Hdh3
jBwwqeGm6dGNdQWWP2ULwuhAKkW4oCX1XAjMDclrXSc4dEjR4sSXM79goV33xego
3xLofG6+ZG9ZDb/cVBNtg9fguZ4CYu2YPMUdG9e6u7sem029hlMtQ9ugQx2K+InC
cDteZIJ0LqcOoEDb9PDnL8XjZ9UYogeesOU7SAA5noO7MRCo6xbZKeKbGCy3+TT+
QXsDFBsAN14QSFDYNdkTVrl/sL0SvffANdexPdi4ro09iMzRY9vqweRFD9SSgltJ
YxHA2idhItCrLH26Kk41ODA7yN8a26IpcSkRUsrTaI9AKX0jhHP6csL7jJds7oM5
UWZjfCMxjxrcixq2CDohiR5fFnmMDRQ4BcCnPk1xRI3cN3d6Dgujk7iFG7yM6M+v
cR0gP9ZcxrHalT6nHufSu7L3HkRig21KP0BNMkPb4BHoctH4eAEGsN7RfanTqi1B
41H9dyzjSINxikKkL6aIMWMgUnMrchNooVjMUG31NendudtVrT9q5Sv1dtnUt98f
ReXdrprYIpQdyKmRnJdXJtqgB58ZS6Lx53pzH9GsJKkeNNwKjndbTLbvoRyhbJ0F
o7MK6LiC8wlBDyYq6WGnNjtm8QpxK8Ab/Li6DQwgJobt7AoW71uFpl5YpC6OPPgO
e4imDGF6BuV6YUyLX03O
=jkc2
-----END PGP SIGNATURE-----

--=-Sq6XX+Lyk/QEEAH9S7f+--

