Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab2BIH4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 02:56:36 -0500
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:41700 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961Ab2BIH4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 02:56:34 -0500
Date: Thu, 9 Feb 2012 09:56:30 +0200
From: Felipe Balbi <balbi@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Tomoya MORINAGA <tomoya.rohm@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH 3/3] pch_udc: Specifies GPI port number at configuration.
Message-ID: <20120209075629.GJ1121@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1328253259-9343-1-git-send-email-tomoya.rohm@gmail.com>
 <1328253259-9343-3-git-send-email-tomoya.rohm@gmail.com>
 <4F2BBBDA.90900@mvista.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlsYxwg8UDQn+EKZ"
Content-Disposition: inline
In-Reply-To: <4F2BBBDA.90900@mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlsYxwg8UDQn+EKZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 03, 2012 at 02:50:02PM +0400, Sergei Shtylyov wrote:
> Hello.
>=20
> On 03-02-2012 11:14, Tomoya MORINAGA wrote:
>=20
> >Problem:
> >  The GPIO ports used for detecting VBUS may be different
> >  on each platform.
> >  This should be easily modifiable.
> >Solution:
> >  In configuration, GPI port number is specified.
>=20
>    Isn't it better to pass this with driver's platform data.

Yes, please re-factor this port. This doesn't fit as a compile-time
choice.

--=20
balbi

--UlsYxwg8UDQn+EKZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPM3wtAAoJEIaOsuA1yqREAuIP/AmQcM60iu78r6uW54IWofPg
aiMLhiUhcngaN9UT+YkAZ8jH5Qq1fp0e1WJTBKDxFM2yhZ9ff5xD91QpVBF6hhq5
YcdOq8ofGmO0u8c/1tewBrnhh/YLUrfMfqAHQYgaph82sqjM/3fA4F4D8hYGfgQ8
96yYlKByQXGXOQJtaxO3MpvQfTIU3huMFll4U2BohQt+FvCltBwb3ZihsrxdFwVr
v4zhwqwYFX0+M37I4pZLVsftBReR8Fn3rJrD/JX1aWJSdMXO7sXaQwN4lR4ENR1i
kKxISnHhcmMqh6UXSBlcN8HxB0sixKtIm823qDH0xF5T3EsczsXMWi5Tr7UQGTy3
ajz7Uh1DRx1h7LjrZqsn05n9/jrSJsXvvlh5M+oFRSRfUy6ts+97Cxo7vQqUUU2V
sPFNox8ANy/taTShXlszru/HrkYbpPwTvhMbSGDZzN17n45opGRM77d26io9k8w1
X3rWUr2yD78tp+w+dTnynGMFH6ekB/vlbHdbDrcjdOUIiYtgdIe3GnQ12qXrSmX5
wpinEwB2XsQdxvf7eETGBR13+JGPlvO0rn+jXmcvK/1zU7GbtirVpNjv0bKThwhy
MIx6WFnGYNoj65qd/U/3MUeRXUncElTFCV8adQej+3Gv3bi9kKkS3Z9KnYVf3ze3
tPfAxV0/imkmegcR8JRK
=f/a3
-----END PGP SIGNATURE-----

--UlsYxwg8UDQn+EKZ--
