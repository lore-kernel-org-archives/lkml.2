Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab2HNB5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 21:57:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44844 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750972Ab2HNB5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 21:57:53 -0400
Message-ID: <1344909469.824.167.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH V2 18/18] Tools: hv: Properly manage open streams
From: Ben Hutchings <ben@decadent.org.uk>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com
Date: Tue, 14 Aug 2012 02:57:49 +0100
In-Reply-To: <1344877627-21779-18-git-send-email-kys@microsoft.com>
References: <1344877584-21738-1-git-send-email-kys@microsoft.com>
	 <1344877627-21779-1-git-send-email-kys@microsoft.com>
	 <1344877627-21779-18-git-send-email-kys@microsoft.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-znHtwbmEefZ5rG/S+JU3"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-znHtwbmEefZ5rG/S+JU3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-08-13 at 10:07 -0700, K. Y. Srinivasan wrote:
> Close the open streams properly.
>=20
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: Olaf Hering <olaf@aepfle.de>
> Reviewed-by: Ben Hutchings <ben@decadent.org.uk>

This isn't reviewed by me, I'm the author!

Ben.

> ---
>  tools/hv/hv_kvp_daemon.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> index c8e1013..ca6424f 100644
> --- a/tools/hv/hv_kvp_daemon.c
> +++ b/tools/hv/hv_kvp_daemon.c
> @@ -160,7 +160,7 @@ static void kvp_update_file(int pool)
>  				sizeof(struct kvp_record),
>  				kvp_file_info[pool].num_records, filep);
> =20
> -	fflush(filep);
> +	fclose(filep);
>  	kvp_release_lock(pool);
>  }
> =20
> @@ -206,7 +206,7 @@ static void kvp_update_mem_state(int pool)
>  	kvp_file_info[pool].num_blocks =3D num_blocks;
>  	kvp_file_info[pool].records =3D record;
>  	kvp_file_info[pool].num_records =3D records_read;
> -
> +	fclose(filep);
>  	kvp_release_lock(pool);
>  }
>  static int kvp_file_init(void)

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-znHtwbmEefZ5rG/S+JU3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUCmwnee/yOyVhhEJAQpiPg//Sd1D9ET9mvxVVagye9unfp6x+mFLaBFp
lpobukk4YLqzignczfSNj1kP6Q4tp+fHZi/k2OE4Y4OLt6233a+B7PyRwLLIcVrN
4Ybm0xOhY+PiP8xBc/D0nijHnQFIRkYe7Z3+bLRtbYtkfg/AsIMAzlBnIQJHAmnY
o7u0T7HEt3SeEnhiP1mzvgB5q9ib11z1VyE1exZfhXQ1sanI81DPzVKwP8zd7RwI
PUTyB/RxTmTiS37Q0aM/VXt1BdfFkaUfdjceeZ541u2byAiDXfnFShKnIUdKWCvS
0P0Mt4hMzCjg/1Rm/xtEyxWv+FJcrqiFcOII1CyMVIH4SHmoo1tqwz8Esqq1V9Xl
cYsgobwfKudgJnCHJwCkkrkO2xuOWP4+QuEw3IuHEolf53fyphFkRnV1EVJjRqvL
YmnOw7ImZOSdg4nXIxgXxBBZ53PcmlF8m0oN0xYYkQWVxdUU5i8YbJp7IxlhZJVS
SczOcA0OpOxBwJ1+NB2MR2F3ZGxemZq7lGaPZWtYoVTcI4QYQHvwhD2F21gvgPXt
Jn7qL911CekdGgQSKJuikXgPxZ+mq44EJYk+IXJSFsMcg8BiHAHuTJ+g/ws+SIwb
Z32sIp4UlRdqTLNSR57Btw7L5kPh8e5vMar+1z23RSDjk2ayYPl74GTm9GXqM8Pb
SD43gS1dj04=
=PEhr
-----END PGP SIGNATURE-----

--=-znHtwbmEefZ5rG/S+JU3--
