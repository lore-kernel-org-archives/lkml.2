Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab2IJN0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 09:26:01 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:60568 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753047Ab2IJNZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 09:25:57 -0400
Date: Mon, 10 Sep 2012 16:21:26 +0300
From: Felipe Balbi <balbi@ti.com>
To: Ben Minerds <puzzleduck@gmail.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: Conform with checkpatch -3 warnings, 1 error
Message-ID: <20120910132125.GE20569@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1347151835-19028-1-git-send-email-puzzleduck@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XuV1QlJbYrcVoo+x"
Content-Disposition: inline
In-Reply-To: <1347151835-19028-1-git-send-email-puzzleduck@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XuV1QlJbYrcVoo+x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 09, 2012 at 10:50:35AM +1000, Ben Minerds wrote:
> Removed 3 checkpatch.sh warnings and 1 error in
> drivers/usb/gadget/serial.c.
> -sizeof brackets x2
> -remove initialise to 0
> -pr_warning to pr_warn
>=20
> Signed-off-by: Ben Minerds <puzzleduck@gmail.com>

please rebase this on my gadget branch ;-)

--=20
balbi

--XuV1QlJbYrcVoo+x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQTelVAAoJEIaOsuA1yqREJEgP/iSLcsJJuPAXIPvDkR9DpDaV
1vU8croPpSE5N/qs3rSLi1Za1o8oGA1yUUwqllhw9YKeEMWdryf02pAlPmqN+mVn
E7NjQN/SE+0NxFxeoPRq9+xPqHVpGorJQUHxUmsMi4du7MM4eC3a66WDKB/O2Z6H
BEAq8XALAbQj3/07TARgpgs7pQsHj7/5E8H7+HP1KoaCJ+263DAlA/ena8ocTQ5p
52S5GsyZ+QnEGcnKPxWNLBPCCak4F3D/Q0HqV78I2wYP3NP33DwDEY8j9rYdY5xQ
JhVxj4ocyxAoXeC2iUQVjcFGIXP4umlTrlUmGm+hPaHknrM5JDdx4U0AdnjQ/04n
ztGVFNVbKCiwoPUaKlhuBqdyYx76kxzc20Z8JZarNyJIgRTMA1Tck3I9lMlnnOUQ
HKspU8wTQKFIAcs5zCfz7hBDK7YrRee9EAWENgX6dcvPtEp9LvKWsm4eOg/JJNGX
OLlPRQaFsFWFCWsAR+tGlTk4Vn8B+kZGO+NM5PETccEVpt+OM1OnyB36UySu8MLp
VJ2jQK9iaHrJhBbQAdGBb8wM14bf47LZ7BQgpUIf9I3nRZoVllZPA4qHVYXO6rnD
z22zxQTS8rfD1pX+tuVy7ygrUOByZvk3M4BmgjkgzxCLjLBsOcgLnlw9Ok+Bl11u
m8EP3RpztRP5ikbdS3CJ
=DsA9
-----END PGP SIGNATURE-----

--XuV1QlJbYrcVoo+x--
