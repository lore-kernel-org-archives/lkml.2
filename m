Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab2DMO4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 10:56:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48973 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751173Ab2DMO4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 10:56:38 -0400
Date: Fri, 13 Apr 2012 15:56:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>
Subject: Re: [PATCH v2 2/2] regulator: da9052: add device tree support
Message-ID: <20120413145633.GX3168@opensource.wolfsonmicro.com>
References: <1334324261-5476-1-git-send-email-paul.liu@linaro.org>
 <1334324261-5476-2-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mu6rDKe19l+MneQx"
Content-Disposition: inline
In-Reply-To: <1334324261-5476-2-git-send-email-paul.liu@linaro.org>
X-Cookie: A is for Apple.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mu6rDKe19l+MneQx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 13, 2012 at 09:37:41PM +0800, Ying-Chun Liu (PaulLiu) wrote:
> From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
>=20
> This patch adds device tree support for dialog regulators

Applied, thanks.  It'd be good to correct the documentation in patch 1
but there should be no code dependency on the core changes so it seems
safe for them to go in separately.

--mu6rDKe19l+MneQx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPiD6YAAoJEBus8iNuMP3dmBgP/2+1sfJ3z/qHe1MRnIxmFQ5H
BdJFzPnqNWyAkAdoU8B99zX+NXZ1Hz14F721UMcbDLtOyy1eKm1gl/DFAGbOPeuK
MFqx4UqjTA4jt4amPw813Vmm+XSlIRXLQJFbTgUhn7oe5H84iK0ctIyuQGULPoB5
OeeNNOhvbN/2c99yLhDIFCueVti9ctVn1qZn9NytxQyDTFQi3fyW1GRHzNQEOtv9
yvwCS9d6zFFIlU6RRhBSxoZOFvqgMJ0TX5jC5mLE7h+AEG9f6txh1gd08ETTNJ3O
+mluOPV8Ruq9/G0flpL/B8l0nwkJIsKIwDRmkR5PyWeFMANr3THygoCsiAYsIZwp
slppjgn3eXsp+tJo0wj46luesPlJoA48WlZGTMx5J2hscVQ+esroXjc3PCZUqNmA
LTA5IcG/1hs6EvE8Uj4rmcYqZ4m9SDkdsqzQ+KmiI3kCsr2rogCE9ursTGz2Rx3q
EYz3dKWGzWrvfdweAEQ7S/++d2MD8mL4+b1Ia8MQa3mnP4vnhJ99k86QUZy33Ngj
4j8V/jTvxlH0wbZCH02YeGmDBKXvQqs/S0DnFpvJPmu5aHp0Z9wenIcwmwVLLL7X
/+d1QrDeEKo6Mnb2tRBSQO1R+OQQAhfxtmJUdnoG4/gQ4fDpedSfEgfZdM/bVqvx
cPhy6cf6wqMAROqPuc4f
=0+jW
-----END PGP SIGNATURE-----

--mu6rDKe19l+MneQx--
