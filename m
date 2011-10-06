Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964841Ab1JFMTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 08:19:09 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:57501 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935810Ab1JFMTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 08:19:07 -0400
Date: Thu, 6 Oct 2011 15:19:01 +0300
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 01/26] usb/gadget/pxa25x: is_vbus_present is gone
Message-ID: <20111006121900.GQ1714@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
 <1317499438-14058-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QVgWX4+QEldMe/r9"
Content-Disposition: inline
In-Reply-To: <1317499438-14058-2-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QVgWX4+QEldMe/r9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Oct 01, 2011 at 10:03:33PM +0200, Arnd Bergmann wrote:
> A recent commit obsoleted the is_vbus_present function, so
> we must not use it any more.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Felipe Balbi <balbi@ti.com>

If you want to carry this through your tree, I'm fine with it:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--QVgWX4+QEldMe/r9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOjZy0AAoJEAv8Txj19kN1HsQH/Am5B8TPAapNPGMPRZzc/jtp
utQHNweRMEoqGR01aCcRFTIh3tytu7r+Vfsoa9xTytQXPtMTwwV+VgxObnqGoMnI
DtKzwXsQvzJyGkqpl0ePdhUnIUSaxtPIaonJQFbs+SfUHvNi0QgNyLQ8h/gI3JCn
6spLRE2oP2jfJiJ4sDmA/4jLpzIjSyYM71Kk1QmdS7ENSpMB6pQkY4I15p8ho0Io
L+WtOPAHTSAAK8M98njnTsH/HMvE6y9NWhRM35NPqerClfdlNbZJWEQImxFkVGw0
jexeO2HuAs7Pa5fQyx4gOrV9k//Q+dyq49OYxk2C+P1lirLdRzspe0ftPtvF2Us=
=T58n
-----END PGP SIGNATURE-----

--QVgWX4+QEldMe/r9--
