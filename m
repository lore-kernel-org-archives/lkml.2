Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172Ab2BBSlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 13:41:25 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:47023 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757119Ab2BBSlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 13:41:24 -0500
Date: Thu, 2 Feb 2012 20:41:07 +0200
From: Felipe Balbi <balbi@ti.com>
To: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Cc: linux-omap@vger.kernel.org, grant.likely@secretlab.ca, khilman@ti.com,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Charulatha V <charu@ti.com>
Subject: Re: [PATCH v9 01/25] gpio/omap: remove dependency on gpio_bank_count
Message-ID: <20120202184106.GC29215@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
 <1328203851-20435-2-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LwW0XdcUbUexiWVK"
Content-Disposition: inline
In-Reply-To: <1328203851-20435-2-git-send-email-tarun.kanti@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LwW0XdcUbUexiWVK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Feb 02, 2012 at 11:00:27PM +0530, Tarun Kanti DebBarma wrote:
> diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
> index 0b05629..6ea7390 100644
> --- a/drivers/gpio/gpio-omap.c
> +++ b/drivers/gpio/gpio-omap.c
> @@ -28,7 +28,10 @@
>  #include <asm/gpio.h>
>  #include <asm/mach/irq.h>
> =20
> +static LIST_HEAD(omap_gpio_list);

I guess it's now too late because patch is acked and everything, but I
think if you make the driver handle one bank alone and just instantiate
it multiple times (omap_gpio.0, omap_gpio.1, omap_gpio.3, etc) driver
would be faaaaaar simpler.

--=20
balbi

--LwW0XdcUbUexiWVK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPKtjCAAoJEIaOsuA1yqREtgsP/jIh6jB2ahXno3+cOgGBTBtG
vHyqwAdpEWcS1dWMllObeU20u9zF+TW7JVLxGWKWW5q86fo6TeVt/rUHhFvR2sGu
Dtz65pLw98oihAicz0tt5SoZoW97LZw//BuqzlZ1Y5dctu1HGH8jFOWLfJjlZAFi
100yeKYHyx+P6TFi4s1gZdwqcIUuJrqueBQzHDSm+qYtpv7LrUyCikbOrPr9TZQF
9qU3fymleiaiW52RLVex8SeOCUK9anfTuMDT0ZK2FXYSWFi+SXq9nVbKLBUC5TF7
aj9nPzhUI8YNKMK3XcJIiNJ9wWL8CSX8qGUUNJetUZsciW80Afj18bY3tOJI5ReP
phuFNPV44Lv0Nf2RMPXSc1tTB5PRq/lNKeP41TK+GEZoJ0dWXqNSxfjrzMQxGzP/
upI7F99rh+eYWqOAzvS7rZIHh1cBzc4YiBQPKc4WRMTJFR8xynAvR3CCH166Svbo
LKckzAVAw9X0afUR8PzTQKet5/oSSN6XHQ06lahHLWBWdx2hpfVlvBOOzT1hDNEM
+ZqHQXJbG9eYW4TxiQRcLPQA9hY7jo2YaVReFswZaN3eof4+PB27PwdxUkfdkrv6
q8d9aZM9nynLcUXTOFvZiFK4N/Yj9RBTN3PgQg9tEg28gc5Xc/mSdR7nTIq+MA6g
tnH28JOYjabJJZqeT+No
=34Y4
-----END PGP SIGNATURE-----

--LwW0XdcUbUexiWVK--
