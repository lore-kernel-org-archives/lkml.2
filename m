Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab1GEWmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 18:42:24 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:35444 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751449Ab1GEWmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 18:42:23 -0400
Date: Wed, 6 Jul 2011 01:42:18 +0300
From: Felipe Balbi <balbi@ti.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v3 4/5] MFD: twl6040: Demand valid interrupt configuration
Message-ID: <20110705224217.GE8023@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1309895376-17446-1-git-send-email-peter.ujfalusi@ti.com>
 <1309895376-17446-5-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xA/XKXTdy9G3iaIz"
Content-Disposition: inline
In-Reply-To: <1309895376-17446-5-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xA/XKXTdy9G3iaIz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 05, 2011 at 10:49:35PM +0300, Peter Ujfalusi wrote:
> In order to operate correctly twl6040 needs correct
> interrupt configuration.
> The slave drivers (vibra, and ASoC codec) will refuse
> to probe, if the interrupt configuration is not correct.
> In this way some checks can be removed from the code.
>=20
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--xA/XKXTdy9G3iaIz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOE5NJAAoJEAv8Txj19kN1SeoH/i6zFl5piFIR8b/URWeJEkZn
NOboe3vYH9+xB1Y3CnKe+8nLNVKsqglCqrO9ac+c/7ZGEmkJIz4+de/tT+WQcOY9
QAyeQAjTWIcGYYZPMdhA2G0dTf7ahNrzYEv+gyFka2yOv9DUEA5ePNTApcHQ1seV
GdPWcXljxf20rqjR4bSzJRzKQWnqo5QPVknPTrbb93Zck+pRn/TJALd5kjttbVVZ
x/RK5IHP7ukyujzY7KoEHULF6/4oJyzzydpVXMkyEo7C32fEp7TJcEQLu1BU2Hgu
9ay1uoaX/0ot7fl+VznNjOImS4ZKTZxrDaW5p66y/nayyYrpeUnXu+lIp8S+5Go=
=S7Y7
-----END PGP SIGNATURE-----

--xA/XKXTdy9G3iaIz--
