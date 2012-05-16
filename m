Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759870Ab2EPIjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 04:39:18 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:42500 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759308Ab2EPIjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 04:39:14 -0400
Date: Wed, 16 May 2012 11:37:23 +0300
From: Felipe Balbi <balbi@ti.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com,
        gregkh@linuxfoundation.org, idos@codeaurora.org, balbi@ti.com
Subject: Re: [PATCH] usb: gadget: at91_udc: fix endpoint descriptor
 dereference
Message-ID: <20120516083722.GH17359@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1337156587-7379-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nOM8ykUjac0mNN89"
Content-Disposition: inline
In-Reply-To: <1337156587-7379-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nOM8ykUjac0mNN89
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 16, 2012 at 10:23:07AM +0200, Nicolas Ferre wrote:
> The patch 5a6506f (Update at91_udc to use usb_endpoint_descriptor inside =
the
> struct usb_ep) removes the desc field of struct at91_ep. This convertion =
had
> not been completed which leads to a compilation error.
>=20
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Felipe Balbi <balbi@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

Greg this should be applied to avoid compile breakages on your usb-next
branch. Sorry for that.

--=20
balbi

--nOM8ykUjac0mNN89
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPs2dCAAoJEIaOsuA1yqREt40P/2EGtE1yCSXJA3ZdOyjnWN+N
wqItrm9f+h+Ny71gnmWWKfVi9DQQvPboEjXJoYo6TL7hT6zqbTej/vcU7zN8Pzxp
PW+aghH+hGdsRbn1izq4AV9nmG4VnG5MmkIVNvFr6s9OFRkKrDzAT56M3pf0b0lj
9+QgRoNErtMkDqoBlDjS0OazS+c4vkONu/YYBK2nYx9NNW2B1+kCPMlIuzak1P07
rVKhQjia98h+YizBQOprZhbQp5FeMeYPsyhET5lpIgAPTZFn54Etdm46wb4Rrxsy
FhV4beTW7sgYyFDq/DeJmr1BbFop6s6QjjEbPS8Lz3Egi8vKwpFuhJI1QCLXcP5+
oqcj2F+YPtwQPstVQkVghZUnDpA8erA7zAv+7uaJQ/cRVHZep4A2SRM1d7OLVdr2
bhpI47OrhyycdwGCPgZh3Oc/noy0o67ydKUY85TirQa7VYpxFcLFMQ7OTPsn44ZK
J+Mi9c9T6BOUHGB2T2brDET7aNqYRH9D20n7t1JdTsfLRcgHwNJe1FJ2MQ3seWwT
CXiz0JJGrqY+HUuSs7/icwToMhvTe3OwWNOwMcCV6JzJeEljHGzwuZNkq0ff7Dc6
Hl+GwQFBf1hjy6yIwHFNr/jiVYg7xFS/K7LLZkttTTJYGBzNTPQsVOcKn0UVZBuQ
QGUDHSnTlIM8lhMQDBbY
=NPX1
-----END PGP SIGNATURE-----

--nOM8ykUjac0mNN89--
