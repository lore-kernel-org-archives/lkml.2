Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab2EGOl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 10:41:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51447 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756467Ab2EGOl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 10:41:57 -0400
Message-ID: <1336401714.8274.320.camel@deadeye>
Subject: Re: [ 73/75] iwlwifi: use correct released ucode version
From: Ben Hutchings <ben@decadent.org.uk>
To: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "John W. Linville" <linville@tuxdriver.com>,
        Greg KH <gregkh@linuxfoundation.org>
Date: Mon, 07 May 2012 15:41:54 +0100
In-Reply-To: <20120504204230.580609792@linuxfoundation.org>
References: <20120504204230.580609792@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-NyiLCUCcbNkTTcDvrK2/"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NyiLCUCcbNkTTcDvrK2/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-05-04 at 13:43 -0700, Greg KH wrote:
> 3.3-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
>=20
> commit 78cbcf2b9dbe0565820dc7721316f9c401000a68 upstream.
>=20
> Report correctly the latest released version
> of the iwlwifi firmware for all
> iwlwifi-supported devices.
[...]

Isn't this also applicable to 3.2.y?

Ben.

--=20
Ben Hutchings
Hoare's Law of Large Problems:
        Inside every large problem is a small problem struggling to get out=
.

--=-NyiLCUCcbNkTTcDvrK2/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT6ffMue/yOyVhhEJAQqQRQ/+NzXbV6bBaEXQEKhOOb/1z1E1qRo4Rudg
E2GzySmoxdbZ6A0ze5L26JcO9bs7BvsOfjfYU37lb/b0U/02Y5tgJrfDMS0VyuXe
r4vp5f2aZvUt9fHVFkpo1wf6BWA6HjbZa4qCAsJP5fMMJcSboP3Ht+G9XDBkrRXV
4pla4/xE4h6g32M81MF+CWPBTWblD5IBzsb5o1YR1R6r0y501ywU4LQP+7nkPsZz
87bCPxV+p/5ZIIYD3pBxA1Nvit9TCqDmkImIWqJq80wdauUdftpnyUlWatA6UF6f
/mcy6+Aqw5Pz/e6fFSSayokIZh3hyxFGRr30LcSF5/VcBfpiZThIpxyF7hxT37cB
gDjn0BE6jxsrBuBXAGp08DSHL6qtR5KCSab9tH2aCxZSt5NNtu5edamuogNC+7P0
d7weY/N8eNim/RfM9s9375ViC0bMxvj6HqVsQ4qYRPBpQNFLhgmuWoaxW6ijIBGB
xaQUV15jbGGPzH+qs3Cn/BkHl2AnYHPClzV1LjXmiVLH146ntOlPp2ZJD0nrXz3G
pSb8wRwyqv4Fw4gxIRBl+dBFYzNufSNrmBnmxw/leIsaMPVsPn/u8rBOxCVw55JI
q3+XvXcF9IYFDU31AUTrCxO6pSksA2f/nKbOibaucKJZeZATEiSaRndJ2DJFNXIA
Qiyko1pnpX8=
=HYJh
-----END PGP SIGNATURE-----

--=-NyiLCUCcbNkTTcDvrK2/--
