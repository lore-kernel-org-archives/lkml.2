Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab1LESAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:00:18 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:33932 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932523Ab1LESAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:00:13 -0500
Date: Mon, 5 Dec 2011 13:00:09 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: avi@redhat.com, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com, mtosatti@redhat.com,
        jeremy.fitzhardinge@citrix.com, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5 V4] Add ioctl for KVM_GUEST_STOPPED
Message-ID: <20111205180009.GB5673@mgebm.net>
References: <1322602539-27004-1-git-send-email-emunson@mgebm.net>
 <1322602539-27004-4-git-send-email-emunson@mgebm.net>
 <1322903774.3782.1.camel@lappy>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LpQ9ahxlCli8rRTG"
Content-Disposition: inline
In-Reply-To: <1322903774.3782.1.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LpQ9ahxlCli8rRTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, 03 Dec 2011, Sasha Levin wrote:

> On Tue, 2011-11-29 at 16:35 -0500, Eric B Munson wrote:
> >=20
> > Now that we have a flag that will tell the guest it was suspended,
> > create an interface for that communication using a KVM ioctl.
> >=20
> > Signed-off-by: Eric B Munson <emunson@mgebm.net>=20
>=20
> Can it be documented in api.txt as well?
>=20
> --=20
>=20
> Sasha.
>=20

Thanks for the review, will do for V5.

Eric

--LpQ9ahxlCli8rRTG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO3QapAAoJEKhG9nGc1bpJ3A0P/RfiqRh6Ly6rKOo2ewzKWMEm
FJLapLn9BxfLNK/lz8NVHtom+G71f8v6WKdDIKOO9eY5mC2oeGnEeRhmk/9bzR99
XV6oWJXZctjIcndCnb45FF5u4yFn2ZITOXlVe+w1laEXEgFVlXyY2CvgoTmS83KL
G/KscskafTlA0TD9gZv3CQEbqly+BaRxcsw8+VIi42TosEveiTsyJ002GAeO7OuO
mp2Z9d8CaP43jAm5MBvQd6lZlLjXTsci0UrRUT3zkVZJoB+X7pNuekDJNPINRuSm
+bb78Y3ekKKz53NUx7sEyh5Gzqu6GjMDOSEzF54uviXhPnPd2lLAmRg9gwlpP+cd
ksXv0QCcCS1PsZG7cdqjXLpqorno5ll3hjL/hM5vkofgnR03r0So8uuOEBe3YKwj
nEEDp6cX3p9Z9VrAIgiO+Gg48bAiadLBGcj3aFKtcY03426HPAlnAtOHrUlug5TT
9Iw1c5lFmDyPIDC9K3f5xEqAoT0G+ulv2K9a5tNjS6LUUMgsn95PgSnJSTcnUSF1
Z15pJoC611gI79Vt+Ee+q8mcBHDFhbJwiWw/R9yv0u6XB/kX9TW1ANyVK/FBguRR
lv3p025qiLWQ7O2fJdwPFcxmPMYyc8E4/4NJZtycBbfCdWaU7FvGzz7/ao2QQfrq
y9EkoyqcKFn8ZQwCa0c9
=rXcR
-----END PGP SIGNATURE-----

--LpQ9ahxlCli8rRTG--
