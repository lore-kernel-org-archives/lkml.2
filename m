Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab2GBHh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 03:37:59 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:36147 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751106Ab2GBHh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 03:37:57 -0400
Date: Mon, 2 Jul 2012 10:35:23 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Li Yang <leoli@freescale.com>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH 5/5] usb: gadget: composite: parse dt overrides
Message-ID: <20120702073522.GE16670@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1340720833-781-1-git-send-email-aletes.xgr@gmail.com>
 <1340720833-781-6-git-send-email-aletes.xgr@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="orO6xySwJI16pVnm"
Content-Disposition: inline
In-Reply-To: <1340720833-781-6-git-send-email-aletes.xgr@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--orO6xySwJI16pVnm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 26, 2012 at 11:27:13AM -0300, Alexandre Pereira da Silva wrote:
> Grab the devicetree node properties to override VendorId, ProductId,
> bcdDevice, Manucacturer, Product and SerialNumber
>=20
> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

I need Grant's acked-by to queue this one.

--=20
balbi

--orO6xySwJI16pVnm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP8U86AAoJEIaOsuA1yqREw64P/2+mWzVEzVDpX5cBq+XAgAvH
PyXMB73y24gX/+5kQGEuOkAbFygC4Mb0tIA6I+Hcncx3EyC/6s1SxUXbw6u0k+v1
Zds3aluGSh2+A9untIAXVc5sqoSg4wFW+97oysRJ5iYC9fQkXkHDzItoMXo6CA+1
WP4Voz4+92Re2WdcOJthJaAY1KQ6HjBwbvT5V+uo3k+rLQwogzbDADsWDekut0sW
Ty7u2l2YexpYDL2LZDMydbvuydNq9rMdJapyv0UYTJ0a0ayob4007gM4fXvoFkuh
SCtSxBDmQKvzS9rW86Uspw27BOzrF3Xkn5cXA138iXgyQFM1lRPfowC1ckHnYG+P
j1iCjLYsg6HMsQtg7JA/HtF2I1dT7ts4SMQRQagJ2bg6+OCCmLZ7MDVT3LJ/ByDX
mqBi6V8CUmw+xW9/sXtrCudPJPhoq40C18wZQt1b+jmuOCIkM8w0BXpC8zYqRBcw
SOB3EtTwKNfG2BVq7Ck6jqrhfdmps3K5Ee8fTutZoTdWnaf2n17eGLPpFVmVg516
7xVNG24Bhfr4aJYO643+jYocY1GmDbiLkg3IsNlcgKPjUzNrDttoV01SIs/KyxDz
rlqV3NO6Qxslw7ojNs43zdgWghp19h0AkauTg00lFnquetXk2ElPb/jV6AHC245D
zO+n6Q/Eya5o3Buob2y+
=Hfng
-----END PGP SIGNATURE-----

--orO6xySwJI16pVnm--
