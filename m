Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab2HUKuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 06:50:51 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:60980 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756418Ab2HUKur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 06:50:47 -0400
Date: Tue, 21 Aug 2012 13:46:48 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 2/4] Input: keypad: Add smsc ece1099 keypad driver
Message-ID: <20120821104647.GU10347@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345545940-2232-1-git-send-email-sourav.poddar@ti.com>
 <1345545940-2232-3-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CYcXvPfqKSDi0QhV"
Content-Disposition: inline
In-Reply-To: <1345545940-2232-3-git-send-email-sourav.poddar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CYcXvPfqKSDi0QhV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 21, 2012 at 04:15:38PM +0530, Sourav Poddar wrote:
> +static struct platform_driver smsc_driver =3D {
> +	.driver =3D {
> +		.name	=3D "smsc-keypad",
> +		.of_match_table =3D of_match_ptr(smsc_keypad_dt_match),
> +		.owner  =3D THIS_MODULE,
> +	},
> +	.probe		=3D smsc_probe,
> +	.remove		=3D smsc_remove,

one extra comment which I forgot. You probably should put your remove on
__devexit and add __devexit_p(smsc_remove) here.

--=20
balbi

--CYcXvPfqKSDi0QhV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQM2cXAAoJEIaOsuA1yqREPmUP/AvfScXSgoi2kWD4jh7ksRu+
RdNDVUDRgngMphOkYn5xIqGsVXPauweofTJqGl+8XRAnotS9WxnmHPww4sB7lbA3
n4HlfLKw8j6PDeWO9JslvyN6HLI3IJIHIVLOv97XUsra7cPHrHyuwivjp8pLx7I2
agIEbqpe+Cm9yzdm39J+qmF7+qrgRO8krRIEAwwiad6GWlDblBSjh0hSN2mzkDNy
Zr+OjXc69gxCXpzaFCi/W+XNL+/h4eVNtCF6AsIKRaq44iE2LunF2mJdZsE6NbC0
p0AKuQ4ZoqDZegZmnTTHWOS9JXfWrYaiPiVtqRFl9og3tDHTPJXUKd01cbeN6WSy
E45GJaEMh/+JDcBJFyc6tJbQjvaM5hMVWISsnqWS545h1G3Y5IX9k380+7sffQ5j
+NA5YRYXxZ8106Yl/WqLHWI92vvcuP2FwBDd9uFEAtNxb+5GOHX7L1Sg9f3qskYX
+GiaYFzgrLcMAfeRP5RkMCrO4j577bIgkPu5/zIWKeUWhxFmmLQQLVvr9RyVGFX0
QrSinE9Vg2RuXwW6EvWRa57f89u0En0EGU2bzV6oEA8oPTf8vNEwbgHdo1bK8brz
VZ3YoHS1byeE+u1IYyUeGomOM8BdTY0on5LxcMrvrlG/2Ia7DQk+YJJvY/OFCzX5
OCu1V+LGo9eM7E7Glyw3
=Swyd
-----END PGP SIGNATURE-----

--CYcXvPfqKSDi0QhV--
