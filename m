Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab1FNQt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 12:49:29 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:42158 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750947Ab1FNQt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 12:49:27 -0400
Date: Tue, 14 Jun 2011 19:49:03 +0300
From: Felipe Balbi <balbi@ti.com>
To: Skacore Systems <skacore.systems@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] s3c2410_udc: udc command always disables pull-up instead
 of passing the command
Message-ID: <20110614164900.GR2353@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <BANLkTimU+E8Y0_9+H2nsF6CMg66_TDH0LQ@mail.gmail.com>
 <BANLkTimL=+vaa7NB5FW192rZd08Gv-Z-OA@mail.gmail.com>
 <BANLkTik+TD1+k1hd-hEteE5OTeDrDAuMZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qt1QjyEQWhDl0Ejc"
Content-Disposition: inline
In-Reply-To: <BANLkTik+TD1+k1hd-hEteE5OTeDrDAuMZQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qt1QjyEQWhDl0Ejc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 14, 2011 at 04:58:40PM +0200, Skacore Systems wrote:
> Sorry for the HTML,
> There is a bug in s3c2410_udc driver, which triggers when using custom
> UDC command for USB pull-up.
> As a result driver is always calling user defined UDC command with
> wrong parameter (S3C2410_UDC_P_DISABLE) instead of
> just passing the parameter to the user defined function.

please take a look at Documentation/SubmittingPatches and fix up your
patch so that it can be applied. Also, when sending patches,
scripts/get_maintainer.pl will give you a hint of who you should put on
Cc ;-)

--=20
balbi

--qt1QjyEQWhDl0Ejc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN95D8AAoJEAv8Txj19kN1vVwIAJnYK9lWa1vwkX8D2gmz3pEb
+t3fYMZLG7+TEwcgcuw63InawCVMqh53H+vJv6kzzOf4aqzcgIKCSKxYglOvX0He
pDGriVIS64kkOo1vShJA3yUfDgMUKhLDn+l9n+rzcBV1sNO02//8clAnqmL6QmT4
FrHZE+h0yM1n7RuYV1MncI+lSw3mLWcVbFNxq8Op2DUekPw7lTFhUTHzy+tjw6Vp
3L57xChyf7xZDX/2i/fvXt9YTPLbwIpJr9mZOBo5WlD8hMxFI/7DdaKh1XRLvhs/
hAp3Dy9drS416RMsBf5fHFOYLRzeozXhvxHCTtCjHzyDwyWAoWb2yDNySRUJzvk=
=n/As
-----END PGP SIGNATURE-----

--qt1QjyEQWhDl0Ejc--
