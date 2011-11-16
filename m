Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1KPSmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 13:42:11 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:27782 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab1KPSmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 13:42:06 -0500
Date: Wed, 16 Nov 2011 21:43:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] leds: leds-lp3944, fix "sparse" warning "mixing
 different enum types"
Message-ID: <20111116184303.GC4349@mwanda>
References: <20111005222143.665f7a7e922dbb2b2541007a@studenti.unina.it>
 <1317936884-2320-1-git-send-email-ospite@studenti.unina.it>
 <20111116160007.5a834380ca396153931cc238@studenti.unina.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8NvZYKFJsRX2Djef"
Content-Disposition: inline
In-Reply-To: <20111116160007.5a834380ca396153931cc238@studenti.unina.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4EC403F3.00F4,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8NvZYKFJsRX2Djef
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 16, 2011 at 04:00:07PM +0100, Antonio Ospite wrote:
> On Thu,  6 Oct 2011 23:34:44 +0200
> Antonio Ospite <ospite@studenti.unina.it> wrote:
>=20
> > Fix a warning from "sparse":
> >=20
> > drivers/leds/leds-lp3944.c:292:23: warning: mixing different enum types
> > drivers/leds/leds-lp3944.c:292:23:     int enum led_brightness  versus
> > drivers/leds/leds-lp3944.c:292:23:     int enum lp3944_status
> >=20
> > Keeping track of LP3944_LED_STATUS_OFF and LP3944_LED_STATUS_ON only in
> > lp3944_led_set_brightness() is OK, as the handling of DIM (blinking)
> > mode[s] is in lp3944_led_set_blink().
> >=20
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
>=20
> Ping.
> Dan, did you receive this one? I can't see it in 3.2-rc2.

Richard is the maintainer, not me.  But he's on the CC list as well
so hopefully he can answer your question.

regards,
dan carpenter


--8NvZYKFJsRX2Djef
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOxAQ3AAoJEOnZkXI/YHqRmvIQAK1ssuMmKXqmJJkfRnqJeOHe
taSdcN3ds6Z/5wu7CQmCAvBud7rcCz9UUkp50E+eHdwZroapI+OkMBlnc2cAUMuI
i3hv1ycZT0mTW7Ed89uNH0WACFyz6u47vUWJAF4ztikdIZTMqx9yVlvjpTSRTLAD
WsxrrHvt4GWqTJk2+FT+2eo8gPHIYlKq+KTxyVEG9uB2hrIVLS++ZFzXmhwes/A+
aZMzmKenyzGnO0qpPiHAgzJqQhxocORWzi4tBEoXdaBEtdzUOY1EF6a/bEOyAmHd
ZkAYbXbGnwRyDPBbvqbvux+bIWs3g56Ao5Q210Fwsi8FxEPQjDN16NFAX6whor++
oId+YzYnsJ7EKegXp/Lwwm/Vu79X7N/zR/5YcPhg//NZ2ZVKi+zvrkc2X381mFIT
IK20Nc0s1bg3/oEIo8T0nhG9Zh4vNYPtt7Wagi2Ww9rHPmq93w/6R23NHbx1V990
+X3DgPPn7/RsNjeGKsW4PmxiPpfaPs3Bwk61CzGUBmboZYN6j4nsk4SFs+ym3UW1
aXeME7ZtbUDZ0Z7tpqgtWqcQrO9iUTVY72pWqGwlkJHn7EaoilrzyQG00tdOhAjq
+U2YUVbCOAVYiByB9snCqfcmcA06X5uUOhOUJdjwx6JqbvjbmLbZ/e0GOzeishnB
qEr8DSuR7y3AijG143po
=wqEu
-----END PGP SIGNATURE-----

--8NvZYKFJsRX2Djef--
