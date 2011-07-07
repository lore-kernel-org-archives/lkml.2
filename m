Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab1GGK3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 06:29:13 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:37413 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753224Ab1GGK3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 06:29:09 -0400
Date: Thu, 7 Jul 2011 13:29:01 +0300
From: Felipe Balbi <balbi@ti.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        khilman@ti.com, b-cousson@ti.com, paul@pwsan.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com
Subject: Re: [PATCH 1/6 v2] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
Message-ID: <20110707102900.GG1311@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1309546474-15363-1-git-send-email-keshava_mgowda@ti.com>
 <1309546474-15363-2-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f5QefDQHtn8hx44O"
Content-Disposition: inline
In-Reply-To: <1309546474-15363-2-git-send-email-keshava_mgowda@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f5QefDQHtn8hx44O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tony, Benoit, Kevin, Paul,

On Sat, Jul 02, 2011 at 12:24:29AM +0530, Keshava Munegowda wrote:
> From: Benoit Cousson <b-cousson@ti.com>
>=20
> Following 4 hwmod strcuture are added:
> UHH hwmod of usbhs with uhh base address and functional clock,
> EHCI hwmod with irq and base address,
> OHCI hwmod with irq and base address,
> TLL hwmod of usbhs with the TLL base address and irq.
>=20
> Signed-off-by: Benoit Cousson <b-cousson@ti.com>
> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>

Can the hwmod part go into this merge window ? I can fix the PM part
later on but without hwmod, I can't do anything.

--=20
balbi

--f5QefDQHtn8hx44O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOFYpsAAoJEAv8Txj19kN15BcH/iTlNst2b0dnUitUzdItLwIQ
8DeYs5iDIlC3fb0+c8RPtcKrfEicV4s6XzeJ1Zc924EB2Jza6fFEH+mlHlOAUS+B
R+l1n6/OwBSDi3hchkdRDx8mdn5GPqy+OmSeWp+L0FMesNeD05Gzn+Pdx5gF+cUj
2lhdFMOY3c6KDy/q/MJCO3KC/9PPr0ci6tzgJmEazsgn41FOifFy20tBXtPlLC3P
KT4NpDQWBD009FOIn7K1V96YAyW4vAs/jol6KgWediVC99DwLt1luo2OOQNt7TU+
ZREjAyK+rcFIBUJRdsw8Y2h+9BQN2++lgQLbJ0ygvm9T8CB0Rs1DbOz8+CVbxL8=
=kx3s
-----END PGP SIGNATURE-----

--f5QefDQHtn8hx44O--
