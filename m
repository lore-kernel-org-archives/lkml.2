Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab2K0UPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 15:15:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51809 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756053Ab2K0UPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 15:15:37 -0500
Date: Tue, 27 Nov 2012 20:15:35 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/RFT][PATCH 1/4] regulator: core: Allow specific minimal
 selector for starting linear mapping
Message-ID: <20121127201535.GB32691@opensource.wolfsonmicro.com>
References: <1353983073.5422.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6sX45UoQRIJXqkqR"
Content-Disposition: inline
In-Reply-To: <1353983073.5422.2.camel@phoenix>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 27, 2012 at 10:24:33AM +0800, Axel Lin wrote:
> Some drivers (at least 3 drivers) have such variant of linear mapping that
> the first few selectors are invalid and the reset are linear mapping.
> Let's support this case in core.

Cool!  Applied all except patch 4, thanks.

--6sX45UoQRIJXqkqR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQtR9KAAoJELSic+t+oim94t0QAJUxr49/tBK0xfKLEHOGza0Z
C6qq1vP7btsnLC2227CpieJpX/sQacVq0vzZli1hfPeS3RmbqF5j6nt2sLP76OY/
2I3OTKAiCfJgavq6JnSA+W2eLo4PSrb2Nz/hTtyMuRahk7gHLwsiWb4zSpxFZUH0
p6cIJr36+QNdQIvbf9WgolcvSoeS7xBP0i3qjsamW8YF2Xt+Kv6y/kyUReYlqrkF
0Cj63zlpuAd56IBSFomuD8qUTVsScYn5qxm/VaZWC2hNUtgAOIdABBEsKVt04mmI
YPeFqJmPWn8u/Ev0RvdPn5GJKE6/NH0oaY+y5ehINmkXF9sr3FmvPjU7a1J7t7J5
hJTMUw421GlJ5mY8hcEdoKCy6rCpQvua+PhCUXkw+yHpc+/VTz0CtGUfuYmR+GlU
iJ0dnBnft7TWWPY0LofYMvzg+Kwxo2OttihF/rD9/ASvxcIGvlpiAgdgU4z9yBDu
BsK8DhSqrvmHIDMZsdEZCVGgQWCZNIKTDS7YNZZ9GSEmuQpLOd2f4XPKZhtay0C1
FbqzspIgmIskomSfE8LThO0rEsDmjF3DeQgzapX9jeNJ4vSRDBuHdkQvXszwYpSi
NQllwuWpPf+CGadOWRPMzrDVaJnTAC3azoa1sXFXLFzmn3kzlNIN9wzY4i+eqQTo
tJec8ORuGOUb0vOSpDCm
=ofM2
-----END PGP SIGNATURE-----

--6sX45UoQRIJXqkqR--
