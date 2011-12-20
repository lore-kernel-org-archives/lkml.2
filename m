Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683Ab1LTMEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 07:04:30 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:40176 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750880Ab1LTMEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 07:04:23 -0500
Date: Tue, 20 Dec 2011 14:04:17 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, Vladimir Zapolskiy <vz@mleia.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "open list:USB GADGET/PERIPH..." <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 07/10] usb: gadget: remove useless depends on Kconfig
Message-ID: <20111220120416.GP31842@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1324341747-5922-1-git-send-email-felipe.contreras@gmail.com>
 <1324341747-5922-8-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mejza3ZMMA5Za1mX"
Content-Disposition: inline
In-Reply-To: <1324341747-5922-8-git-send-email-felipe.contreras@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mejza3ZMMA5Za1mX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Dec 20, 2011 at 02:42:24AM +0200, Felipe Contreras wrote:
> Where are inside an 'if USB_GADGET'.
>=20
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>

applied, thanks

--=20
balbi

--mejza3ZMMA5Za1mX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO8HnAAAoJEIaOsuA1yqREDrsP/2B8GpXkzoruNI6b/IqVfPEH
TN3exIkLG+klNZD2GANsFGr+uhuDj+vozn9IRd6I7f+n2SeMeHbIcrG0QLjwJn6r
c1kNdiRS28UZvOUL5JdsVesfj1dNVJfyvhDAZGxrrmC5TBtEOENdCVyR1K+56VlG
lX8tGEao1arahv5jJo5wujYssM+0dXkr3pUtBr4wIOeJB9BOQczOn1R2u42IgC+k
T/4dMPvkPrK7+6hcZNyUSDNSvEngz7wZsXYHdSHHS2TS3bKKlIq10Uc3X7KXTh1Q
QUxKcm3apf0ge5uayWRZz5bemYEOA1cxjVNmJOwCJd1IaTO8A61rGg0kfOWZpfOS
1VFXvzfbkuU0d6K2BgrkQRRUtCf6MP0iCt4XVPBcXRk9OI9DbFopxs/+56B9k7YG
Q1SS64bPM+SPRPtMleJ70vwzCaoZqC6u05rVou5dC7K830R7HvSaCwQL0Ziuujbl
cyoWMiRUlKNogeZPlHf/V13WKxxntz6IAfPIbL6GZ3diG1BznpSN1qr5KfGCfUFN
hg2mnBOC1KhyHaWhbZEa59MSKrKxHxnxGZtvYy4JRZNlh+ihqCIL1ZI02IqKXHOk
Jqpo/4eL/sggQ7iQpt6mg5XBhuI+u9LW2P9LBFjaYg0TDqA/OkSZa+uQxwcaeOYk
H/OT2IcRsej1VvLaACMT
=cD0l
-----END PGP SIGNATURE-----

--mejza3ZMMA5Za1mX--
