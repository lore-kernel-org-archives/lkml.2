Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab1JJGKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 02:10:34 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:60161 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246Ab1JJGKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 02:10:33 -0400
Date: Mon, 10 Oct 2011 09:10:29 +0300
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 15/30] usb/musb: use a Kconfig choice to pick the right
 DMA method
Message-ID: <20111010061026.GF31707@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
 <1317566760-25681-16-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oFbHfjnMgUMsrGjO"
Content-Disposition: inline
In-Reply-To: <1317566760-25681-16-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oFbHfjnMgUMsrGjO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 02, 2011 at 04:45:45PM +0200, Arnd Bergmann wrote:
> The logic to allow only one DMA driver in MUSB is currently
> flawed, because it also allows picking no DMA driver at all
> and also not selecting PIO mode.
>=20
> Using a choice statement makes this foolproof for now and
> also simplifies the Makefile.
>=20
> Unfortunately, we will have to revisit this when we start
> supporting multiple ARM platforms in a single kernel binary,
> because at that point we will actually need to select
> multiple DMA drivers and pick the right one at run-time.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Felipe Balbi <balbi@ti.com>

applied, thanks

--=20
balbi

--oFbHfjnMgUMsrGjO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOkoxSAAoJEAv8Txj19kN13ZEH/1sTMVPwHCHaVkQNG5zdeaGV
n/asaA8O2+qLn40ATjXrw/wUOShUW+dD29Dv8q/9Hr/fA9vJXCOKcg+zQqN1c7Lm
pp/ygTSnNr1QIfRoJgw36bGZgsvGDQMjxjdR7EZ70Tur8zR5Y48q9YHxCG92oZ7Z
9mrPY37IGGOCtBS9V/OQW5uO+Hm6rIGAswoFAO6HghCw9JNA8kqMRJHj2EzUv8OK
hcH8AbiWQPP8z4mHQHGj78Q9Q61SJeObkk0a0olszmJn1yyajaADKeoWwphfjvF0
Z/Fl5+Ztuj2n/A7OZB8RsfG3cl64zWVDAbeosrqUS/WzfvNSd75M4QM8+C4crBQ=
=5FcO
-----END PGP SIGNATURE-----

--oFbHfjnMgUMsrGjO--
