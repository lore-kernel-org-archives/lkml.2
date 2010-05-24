Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab0EXLPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 07:15:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37058 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361Ab0EXLPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 07:15:01 -0400
Date: Mon, 24 May 2010 13:14:57 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Jiri Slaby <jslaby@suse.cz>, Dmitry Torokhov <dtor@mail.ru>,
       Devin Heitmueller <dheitmueller@kernellabs.com>,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers/media/dvb/dvb-usb/dib0700: fix return
	values
Message-ID: <20100524111457.GB16756@pengutronix.de>
References: <AANLkTikffmoWofbIo2h6zw-VW5aKEH8T_b0vMfKdo3KJ@mail.gmail.com> <1274698635-19512-1-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TakKZr9L6Hm6aLOc"
Content-Disposition: inline
In-Reply-To: <1274698635-19512-1-git-send-email-daniel@caiaq.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TakKZr9L6Hm6aLOc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 24, 2010 at 12:57:14PM +0200, Daniel Mack wrote:
> Propagte correct error values instead of returning -1 which just means
> -EPERM ("Permission denied")
>=20
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: Dmitry Torokhov <dtor@mail.ru>
> Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
> Cc: linux-media@vger.kernel.org

I am no specialist for this driver, but as I am on cc and it looks good to =
me
(no big changes, after all):

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--TakKZr9L6Hm6aLOc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkv6X7EACgkQD27XaX1/VRteoQCgxzMWXyx8Ek4ZAhCkYwnx4YRG
sSgAmgO8gLxtxec5abXDi4AjwBEMvjVO
=bNQB
-----END PGP SIGNATURE-----

--TakKZr9L6Hm6aLOc--
