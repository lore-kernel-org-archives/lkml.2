Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab2B0OhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 09:37:25 -0500
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:35040 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753819Ab2B0OhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 09:37:20 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of balbi@ti.com designates 10.152.135.198 as permitted sender) smtp.mail=balbi@ti.com
Date: Mon, 27 Feb 2012 16:37:16 +0200
From: Felipe Balbi <balbi@ti.com>
To: Cyril Roelandt <tipecaml@gmail.com>
Cc: balbi@ti.com, dahlmann.thomas@arcor.de, gregkh@linuxfoundation.org,
        linux-geode@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] amd5536udc: Fix the type of ep_string.
Message-ID: <20120227143715.GX26445@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <4F48FD62.7090304@mvista.com>
 <1330268425-4260-1-git-send-email-tipecaml@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yh423QPMiEk4ZruG"
Content-Disposition: inline
In-Reply-To: <1330268425-4260-1-git-send-email-tipecaml@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yh423QPMiEk4ZruG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 26, 2012 at 04:00:25PM +0100, Cyril Roelandt wrote:
> Use "static const char *const" instead of "static const char *".
>=20
> Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>

applied, thanks

--=20
balbi

--yh423QPMiEk4ZruG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPS5UbAAoJEIaOsuA1yqREHSEP+gJc6yEIpbnV1C9kt1Mi4roY
v9E3dynDRIHW/f1WWPAW+s2qmSr8bVGlc/78O+neUDUbFIXk/7ARSyxZJHpaQfyE
0itcwag30fuDxcRV7QGLt5HNCNk1XDnd0Jjpdw24nBzsgdO1o0q+PBEyGzI+Y+bh
eGy/msDVYQ44UoKnZyVLMECSKqTJhqV4WsRSI/n++OfaPe+cBVeJGlOQgboo0VpC
e7nAa8+t5kRMQ50MnSNSAxCy0VwARS01A7xxTvpZDaTK5VdYEiYaqACJHsyCk3X5
OxyEBalqmG+9rQceGUwiTlt2HtLKwnIFKkjEWHP3LccEzjp1mJyRhBiD8TPxFR1J
7DizIwRBWZcwJNGLpD7ukJRFBO95yJTZANacRyZVmBV37GKtq4SQuH+dsmwhIQsk
jGivhMk6Vgj5ADmc9qIPhgSLPUcM2lhwHmOGLWGP2+VRMzz8Yrjyz3zZFsSOCVu4
wUXioC+WIefUw+B0qozSRI1qMhfvXQ5pLEyF0VOLolmn83VS34qhutlq3Fa44q6W
/uYxZqwOPNYDnKrE0jSL5706r1WrAK+GdCN5yjJYL/dr6jXFB+di46/P3chT5io+
HeakyL1r+1jcfi2Apqy8YsctlE20GXnDEzIoBG9gKRdhbhvUKdEdlrKizQ1rbtf9
DTSS0NLJ7llBiSIeoZCf
=Z5hC
-----END PGP SIGNATURE-----

--yh423QPMiEk4ZruG--
