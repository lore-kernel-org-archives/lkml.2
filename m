Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964909Ab2JWXPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 19:15:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:23844 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933615Ab2JWXPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 19:15:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,637,1344236400"; 
   d="asc'?scan'208";a="208195107"
Message-ID: <1351034128.2252.4.camel@jtkirshe-mobl>
Subject: Re: [PATCH 081/193] drivers/net/ethernet/i825xx: remove
 CONFIG_EXPERIMENTAL
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 23 Oct 2012 16:15:28 -0700
In-Reply-To: <1351022666-6960-82-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	 <1351022666-6960-82-git-send-email-keescook@chromium.org>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-0Os6zNB+NIcwkEPvyLXW"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0Os6zNB+NIcwkEPvyLXW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-10-23 at 13:02 -0700, Kees Cook wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
>=20
> CC: Paul Gortmaker <paul.gortmaker@windriver.com>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> CC: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/net/ethernet/i825xx/Kconfig |   12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)=20

Acked-by: Jeff Kirsher <jeffrey.r.kirsher@intel.com>

--=-0Os6zNB+NIcwkEPvyLXW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQhyUQAAoJEOVv75VaS+3OM38P/1LJMZeHmUAraJb57c3C0d9L
AdnpuK9FV+h2U8oZ010EzK2ostRWmSfTMkvBWEVnYtsgAf5yVIZ9qch728pWr/pW
EJq0Hg/CkHfvg9EG5yG61CZ7PxNMhAp+PregsRv6TfHcONK6OgNirqyULM0VrPVy
wjcUID1CCFThrXfTB1dhPcyrXBFLK1QjkB29aF27+Cfzi+WAQdmEzXWHIliJamz1
ev+PTQKPzgBW+wQPDN3oItqnXTD6cnmBr6bYt3YGzUyQpjqRSCAcGyd56Cpu1M7h
jpVGMrD/45MsA1BGsE5MCBv+SXELAXAlRBasTu0T/B3AEGVxRgkuJ99QrrX2qfkn
prQM+mji91XIZv/7Vy8Xtr7ACcs8mVs/DHQixvACDOPqys0FXZ6pyXIiAEFYqL7s
pgjK9lHpmEsYKZUp+lpx1KaH9S6oVZC/iRNqDa+mAjnlkVQtVceA0Zi7VOk81dLC
0rSMRONLmPpad0bU+2j+n2mC3B2QMSvD5k6juYnZNwV0j1Im0rdE4m0WpqFTE53C
woKFxi53qmxM9jEg637DYsoLeuzIGs5jU6Cygye4KDQm5JxblymoZhnqao75ze3m
7iFMygNskQr/kKFu2FztyCE7A8L6Ekx4RH0dIiw/vZuD5AK+OF5c046TpJEiGL0O
ylmJwiXWXvfKKIv7yN5s
=WqmS
-----END PGP SIGNATURE-----

--=-0Os6zNB+NIcwkEPvyLXW--

