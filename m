Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab2A3JIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 04:08:38 -0500
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:33032 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751655Ab2A3JIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 04:08:36 -0500
Date: Mon, 30 Jan 2012 11:08:32 +0200
From: Felipe Balbi <balbi@ti.com>
To: Masanari Iida <standby24x7@gmail.com>
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] [trivial] usb: Fix typo in langwell_otg.c
Message-ID: <20120130090824.GB27456@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1327758608-7575-1-git-send-email-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z4+8/lEcDcG5Ke9S"
Content-Disposition: inline
In-Reply-To: <1327758608-7575-1-git-send-email-standby24x7@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z4+8/lEcDcG5Ke9S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Jan 28, 2012 at 10:50:08PM +0900, Masanari Iida wrote:
> Correct spelling "reseting" to "resetting" in
> drivers/usb/otg/langwell_otg.c
>=20
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

NAK, this driver will be dropped on next merge window. Thanks though :-)

--=20
balbi

--z4+8/lEcDcG5Ke9S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPJl4IAAoJEIaOsuA1yqRErY8P/2E2DkKLQ6PCG7G+hY+WacwQ
dK05pRTZEkkxn+6j84PFUTfnPmLbNC838zIKa/5/P3J7Iq0n2KGERVGD7kFj4nyI
JViN92bpRmwlvpNdNQZjNkittGZc1i/tUH/40+999we1OuNVt4qRnfW2PneDt9R7
cvxHEg/GCNlyGZIrWEgOgz4Q3F5lb7Wv9buL3EWBRXTzaFTZsSS6rxG6QI2L1jha
Xdhgg2cPcV0fpl5SPdRoM2bsVFidJrzlGcqLqFasw+/FCe4S3vvjj+huwVkcGK2Z
8K3S4RYUNmS/zkVH2XR/0vzDxtfBUwP1etBOIJjY9ggLEoo4bCWkrJ8a+qnDjREy
JDeiFcRdRVvSPFBJRJbGbwj21/wSC6/qUEf7U5LihJ4jN8WMs1E1kIVbIqFJVK0/
XDUU6nWt6L3QfPtVkCTATdRQXahaaAWdqsBgRSUgnOMMoQBBKEowSi6txcC6Kk8y
IN1KDHqkBzfWslkfAnpCdIV0ztHs4CXLc2MfmZ/dlWLpK8MC/KukSqt1Y1XwLpR9
8wgUH7UQiSeQoqhadbyv49ac0NwKchj3oVewclG0rtyJO0DmxHoRmmc2ogg1TYNB
yzf0QDwRYB3rCppgQ23SQ7NCfvGZsVjICDBbVj/W51KiFaYSCMx+3LUPOgMX8kAA
/wfAuGqlNe05OF9KHBOL
=+rgh
-----END PGP SIGNATURE-----

--z4+8/lEcDcG5Ke9S--
