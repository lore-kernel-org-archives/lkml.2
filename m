Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab1GKVfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 17:35:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55560 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757474Ab1GKVfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 17:35:36 -0400
Date: Mon, 11 Jul 2011 23:35:35 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 11/11] watchdog: WatchDog Timer Driver Core - Remove
 llseek
Message-ID: <20110711213535.GH5811@pengutronix.de>
References: <1310392522-9949-1-git-send-email-wim@iguana.be>
 <1310392522-9949-11-git-send-email-wim@iguana.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HuscSE0D68UGttcd"
Content-Disposition: inline
In-Reply-To: <1310392522-9949-11-git-send-email-wim@iguana.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HuscSE0D68UGttcd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 11, 2011 at 04:24:39PM +0200, Wim Van Sebroeck wrote:
> No need to set no_llseek any more since it's the default now.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

I'd think we can squash this into patch 1? Arnd?

> ---
>  drivers/watchdog/watchdog_dev.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_=
dev.c
> index f6aa4b5..30a1d36 100644
> --- a/drivers/watchdog/watchdog_dev.c
> +++ b/drivers/watchdog/watchdog_dev.c
> @@ -338,7 +338,6 @@ static int watchdog_release(struct inode *inode, stru=
ct file *file)
> =20
>  static const struct file_operations watchdog_fops =3D {
>  	.owner		=3D THIS_MODULE,
> -	.llseek		=3D no_llseek,
>  	.write		=3D watchdog_write,
>  	.unlocked_ioctl	=3D watchdog_ioctl,
>  	.open		=3D watchdog_open,
> --=20
> 1.7.6
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--HuscSE0D68UGttcd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEUEARECAAYFAk4bbKcACgkQD27XaX1/VRtNhwCY14h+LUPtbzhJPMUX3Ie2vPxL
rACgm9NGDBaqZO7qUkSrfDWgktIdoxI=
=+gHs
-----END PGP SIGNATURE-----

--HuscSE0D68UGttcd--
