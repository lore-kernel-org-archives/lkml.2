Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758391Ab1FGTjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 15:39:48 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:42054 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756500Ab1FGTjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 15:39:46 -0400
Date: Tue, 7 Jun 2011 22:39:39 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: balbi@ti.com, "'Alan Stern'" <stern@rowland.harvard.edu>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ablay@codeaurora.org, "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v15 10/10] usb:dummy_hcd: Force FS device connection
 according to module parameter
Message-ID: <20110607193937.GE12242@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <016d01cc2541$0bfa5980$23ef0c80$@org>
 <Pine.LNX.4.44L0.1106071436020.1972-100000@iolanthe.rowland.org>
 <018a01cc2543$7273a5c0$575af140$@org>
 <20110607185415.GD12242@legolas.emea.dhcp.ti.com>
 <019601cc2546$6359cdf0$2a0d69d0$@org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wwSkEpePV3aFlXly"
Content-Disposition: inline
In-Reply-To: <019601cc2546$6359cdf0$2a0d69d0$@org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wwSkEpePV3aFlXly
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hi,

On Tue, Jun 07, 2011 at 10:09:01PM +0300, Tanya Brokhman wrote:
> > > Ok, agreed. I'll update the patch.
> >=20
> > Cool, I'll wait for a revised series.
> >=20
>=20
> Actually, the only patch that will be updated is this one and it's not
> really related to the SS support patches, it's just based on them.
> I'm telling you this because unfortunately I won't be able to post new
> version until Thursday...

Ok, so I'll take the others by friday and wait only for the revised
patch 10.

--=20
balbi

--wwSkEpePV3aFlXly
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN7n55AAoJEAv8Txj19kN1RdMIAJNjUUk/MTFAi6MXRPpOJpFo
SAOtElFOA2375/1Wjc9xPOkJcqyyylyW08SeHvSCcLCdNHOEmmaguBaEYpHgVaje
/FXx6WUgswDFe3sB8LmM3Pllbn58YeE29EuIChD/aJtVrATCVrrbl1dG3AfZ1T+R
NF/riO2aTiuoSdL9ZZn3LN/0Hml9IyZT2nMRXaJD0g+H7H5Xu4ReehBQq40RGzFc
8jqS34xAvG2U8TEwL3xqMUEOEOoWWoHorWF9+U3mex2BzLUi64fHRZ1Zs2e6uozq
8S1BD9Iy27e6GWSAMxhybQ9Y8eoOQZ3mixQnwFuj3TDtwnC/uacC8NHvbjNZGus=
=ZpbU
-----END PGP SIGNATURE-----

--wwSkEpePV3aFlXly--
