Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab2IMJaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 05:30:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34469 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab2IMJaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 05:30:02 -0400
Date: Thu, 13 Sep 2012 11:29:43 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: m-karicheri2@ti.com
Cc: nsekhar@ti.com, khilman@ti.com, khali@linux-fr.org, ben-linux@fluff.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: i2c:clk: preparation for switch to common clock framework
Message-ID: <20120913092943.GA5912@pengutronix.de>
References: <1346350236-11105-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <1346350236-11105-1-git-send-email-m-karicheri2@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 30, 2012 at 06:10:36PM -0000, m-karicheri2@ti.com wrote:
> As a first step towards migrating davinci platforms to use common clock
> framework, replace all instances of clk_enable() with clk_prepare_enable()
> and clk_disable() with clk_disable_unprepare(). Until the platform is
> switched to use the CONFIG_HAVE_CLK_PREPARE Kconfig variable, this just
> adds a might_sleep() call and would work without any issues.
>=20
> This will make it easy later to switch to common clk based implementation
> of clk driver from DaVinci specific driver.
>=20
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

Subject had "i2c:clk" where "i2c: davinci" would be more precise.

Fixed that and pushed to -next.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlBRp4cACgkQD27XaX1/VRsvYACgotXt37eiAUUakCKM84H6Zenz
02AAoJZZy+6DE2r7DGJhe/Mg7fkU60OC
=9RhD
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
