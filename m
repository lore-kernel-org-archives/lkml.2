Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab1GZOxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 10:53:42 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:59205 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753597Ab1GZOxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 10:53:34 -0400
Date: Tue, 26 Jul 2011 17:53:31 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sergei Trofimovich <slyich@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergei Trofimovich <slyfox@gentoo.org>
Subject: Re: [resend PATCH] tusb6010_omap: fix build failure: error: 'musb'
 undeclared
Message-ID: <20110726145330.GF32582@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1310916480-3477-1-git-send-email-slyich@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hU50fLDIZPaBYjJk"
Content-Disposition: inline
In-Reply-To: <1310916480-3477-1-git-send-email-slyich@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hU50fLDIZPaBYjJk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 17, 2011 at 06:28:00PM +0300, Sergei Trofimovich wrote:
> From: Sergei Trofimovich <slyfox@gentoo.org>
>=20
>   CC      drivers/usb/musb/tusb6010_omap.o
> drivers/usb/musb/tusb6010_omap.c: In function 'tusb_omap_use_shared_dmare=
q':
> drivers/usb/musb/tusb6010_omap.c:92: error: 'musb' undeclared (first use =
in this function)
> drivers/usb/musb/tusb6010_omap.c:92: error: (Each undeclared identifier i=
s reported only once
> drivers/usb/musb/tusb6010_omap.c:92: error: for each function it appears =
in.)
>=20
> Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>

applied, thanks

--=20
balbi

--hU50fLDIZPaBYjJk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOLtTqAAoJEAv8Txj19kN1IhMH/RRJXeVyyC0MtHPY00tliPo7
2dkkzg3E81oKqeGpNsqeIFtixC/WNEJof/j5Ggt5NJ/eoNkRKPs8tEI7xCkMerWl
3g6bE2i7+QxPdzJ5V+PSWRE3eMdDKD8xgCtBPCGuJ0Ia70bwT6xvvkwWOvTdmBfQ
+KVjAOJJaXRWd9mdGBsqnV+DtMNWRmQ472qGpBGWushxg0Skl+fHDcSlwi/TBJeE
SAox3oZBBrZwDv1Btyz+QOWFaukF0aQuRz+JCIu3OyE/yTUaDnXiAQVjlm85C96T
QT5GxcTOtquxCesxtnicL0dnw191qZWheqbqvSLeT2UD+5t85Zg9raLu//BIDgU=
=nVUO
-----END PGP SIGNATURE-----

--hU50fLDIZPaBYjJk--
