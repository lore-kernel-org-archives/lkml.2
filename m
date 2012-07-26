Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350Ab2GZHTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 03:19:07 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64412 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab2GZHTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 03:19:06 -0400
Date: Thu, 26 Jul 2012 09:19:02 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: linux-kernel@vger.kernel.org, nsekhar@ti.com, vaibhav.bedia@ti.com,
        gururaja.hebbar@ti.com
Subject: Re: [PATCH v2 2/2] pwm: pwm-tiehrpwm: PWM driver support for EHRPWM
Message-ID: <20120726071902.GB28165@avionic-0098.mockup.avionic-design.de>
References: <1343215699-4575-1-git-send-email-avinashphilip@ti.com>
 <1343215699-4575-3-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8GpibOaaTibBMecb"
Content-Disposition: inline
In-Reply-To: <1343215699-4575-3-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:WlsU6Bqogms7maYbxr4PDBt25JrkYdLw/buSSuW40pk
 r2llToD3EOi3NuBEFr+fxl6YuqUeO4jcpw0Q5Qq1rGt9WJQ+/5
 KhaL1CDb1bjtubL3cM1mQNwW5c1myjDnE/Qp/q42U7ALp+XkYE
 CvFv5ygrrx4E5ue8yH8+1f3Hi2BKB4vkloV+I2UK/CauxE6CtQ
 gBGVyAdKp9+2e3/O5Dc1edmQLoQnIn/InkDkrEaVYZfYzOZ7Tm
 w3mqQr691JriIzh5nhjxSt3aXI3y3sBU/sYhXJ4hmjzoqu8nxH
 Gz+EdkNrPTQDeXULoowyFX/x3Da27eaxS+NV4onqpXe73GSLI9
 QcPuTbyDpWMYxx+5DBCNn7D2y1nKYoMmQwswhLSLGPmv8grsdk
 XYfBFWv3wlZP63dEiaBjbUWkneSs9s3CPzG/rMTkrbqUDslQVo
 ZvbiD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8GpibOaaTibBMecb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 25, 2012 at 04:58:19PM +0530, Philip, Avinash wrote:
> Enhanced high resolution PWM module (EHRPWM) hardware can be used to
> generate PWM output over 2 channels. This commit adds PWM driver support
> for EHRPWM device present on AM33XX SOC. Current implementation supports
> simple PWM functionality.
>=20
> Reviewed-by: Vaibhav Bedia <vaibhav.bedia@ti.com>
> Signed-off-by: Philip, Avinash <avinashphilip@ti.com>

Applied, with a minor cosmetic fixup. Thanks.

Thierry

--8GpibOaaTibBMecb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQEO9mAAoJEN0jrNd/PrOhHw4QAKGOuYQYJa+l9N9rxQ4rUp+8
d4ibYk7Htf6K8yYCncLKqIMwiBaDOMqRgv190gJUfrsbzaYlvkkSw1RaPQCx4JgK
+D9UaPa/bvPfNygFTZCkRzhWSJtoJU/oOMzw47NmmmK1rZDzm9lqRk6IQ/nsLJpZ
3BUk8i4l60u7ma48AswyPren9bJmabucfdTNix6h3JAEpY9poyHKYrDuC9uS+JfR
SEEKdSF+CpXCIYb/V2dZJu/UmYprsuEhpRpm4zc2wxWv6lsMcDbSKF25ps88Jfzd
BWkEv+o3DbAlARL1YuwU6zjcOTUHqfeA9AeYwtsDsCbWopuUMrjCYFh9n6162iFr
vJ+vSvUvAaaqXchVAJe3yikwGswzWXfkdDwYDpPYhlm6h3jiN74q6hEAP/EwPRH1
Adk7ItogL2gvQkQCenUIFlp0AQKbKYtjVr1slUMkdN1sdOU+buYKaMo92mS6M8xj
c8H2YueryGwsUHY4g4CtgjlcN1IBqeh38G4ZJ6tfXsugzjlHpLAdDAgE4b+IhpG4
iyqy9AasGqQ+SRciFSkQp5180Q2qXiE322Y85wXY2wPjWsz2nAsB2p9Y7XdZbCRF
XhUrP5YChfOKuoYJgLode558RgXEnvOtFLA8lTQKIpyx3gUdOaNaSCHtpGQjHOHY
x4qWVHNZ7Bes4NpzRYBN
=JIJ2
-----END PGP SIGNATURE-----

--8GpibOaaTibBMecb--
