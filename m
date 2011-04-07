Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab1DGXsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 19:48:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59601 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757159Ab1DGXsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 19:48:23 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1299630756.4146.25.camel@localhost>
References: <1299630111.4146.15.camel@localhost>
	 <1299630756.4146.25.camel@localhost>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-KiqkLlqS7H0FLX1Z6tT2"
Date: Fri, 08 Apr 2011 00:48:19 +0100
Message-ID: <1302220099.5282.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH 4/5] avr32: Fix .size directive for cpu_enter_idle
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KiqkLlqS7H0FLX1Z6tT2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-03-09 at 00:32 +0000, Ben Hutchings wrote:
> gas used to accept (and ignore?) .size directives which referred to
> undefined symbols, as this does.  In binutils 2.21 these are treated
> as errors.

Please acknowledge and send this upstream.

Ben.

> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  arch/avr32/mach-at32ap/pm-at32ap700x.S |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/arch/avr32/mach-at32ap/pm-at32ap700x.S b/arch/avr32/mach-at3=
2ap/pm-at32ap700x.S
> index 17503b0..f868f4c 100644
> --- a/arch/avr32/mach-at32ap/pm-at32ap700x.S
> +++ b/arch/avr32/mach-at32ap/pm-at32ap700x.S
> @@ -53,7 +53,7 @@ cpu_enter_idle:
>  	st.w	r8[TI_flags], r9
>  	unmask_interrupts
>  	sleep	CPU_SLEEP_IDLE
> -	.size	cpu_idle_sleep, . - cpu_idle_sleep
> +	.size	cpu_enter_idle, . - cpu_enter_idle
> =20
>  	/*
>  	 * Common return path for PM functions that don't run from

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-KiqkLlqS7H0FLX1Z6tT2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATZ5NPue/yOyVhhEJAQrwwRAAnlzCT4VwN+pQvlrGFYSkFkdRu9UDdmRU
H1f47wRk5Vr/x6qteRJTZwk87rjjH6CX1mjB54n1UqwKOYf8vNsQBMx1UeKN0ldR
YPTd+5KjMi5Q3f4jxv8PZNUDgfUjD1JDBXuqMOMjWUbMbJexyRrPdRzBStyWYRj1
9KLPKeFxj9lGcLqcRYvoOx2ItqGc8TSu3m5hFAT4MVl2262bq/SWgmbzLHCBMNBq
EEUtttioLP3R3kgIUrNS06pibFPiUYDdb2CJu6WR+Uo67YUZPWH9bzR44FLSWjb5
dthg/zThlMUGro+mtY6xsFBIMg0VXzlXRQ44dkcu/Ga177jAEBm40WRD9Hl+hKVw
TubMAWo8pqmfwpx6xlm7QnEP6o3yBxkpH3xiLGgsCIP/8wVXEMj0q/kVr1W/cOgi
UTv/TlfpdHruyXEiU5zZ6/O14J1kEIaPQ0TFltWHOJXCKzKxEDRDaZMhGHRALSWL
LSrnU1cV9rTrRGJoxi6g1FgRMp6B45gB7Wq2+xyDL8yvnz+AIyy1jHBivsfDzcky
RHuh/L1JFRzjBBScgOMKnO1CiJO7Th0BxLSqeYZg2lvR+VJn6zuKATBEaGvX2gkR
ektA9sRZFO68+AdSPa/IX6S1qKnMLshBKbHfsHRFwioyXRpjy1ZAaH+xVeP8d9o8
4gGpBVoqwYY=
=n/JY
-----END PGP SIGNATURE-----

--=-KiqkLlqS7H0FLX1Z6tT2--
