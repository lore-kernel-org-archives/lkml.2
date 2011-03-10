Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab1CJToT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 14:44:19 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60033 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab1CJToS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 14:44:18 -0500
Message-ID: <4D792A00.6090803@pengutronix.de>
Date: Thu, 10 Mar 2011 20:44:00 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Dr Andrew John Hughes <ahughes@redhat.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org, Trond.Myklebust@netapp.com,
        Greg KH <greg@kroah.com>
Subject: Re: NFS regression in 2.6.37.1 (current stable)
References: <20110310185321.GA22030@rivendell.middle-earth.co.uk> <AANLkTikXb_NM0+3ro607k0sz1zFJFTeJwp9MmBn_ngzn@mail.gmail.com>
In-Reply-To: <AANLkTikXb_NM0+3ro607k0sz1zFJFTeJwp9MmBn_ngzn@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBA3054419E5906AB8FD47DA1"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBA3054419E5906AB8FD47DA1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/10/2011 08:35 PM, Pekka Enberg wrote:
[...]
> There's some more discussion here:
>=20
> https://bugs.gentoo.org/show_bug.cgi?id=3D357121

They have identified the 55ea499d60aefa3d03a77fc8590c26b5881faa92 as the
offending commit, too. Used system is x86_64.

> Greg, Trond, as this is a regression in -stable, I wonder if it's best
> that we just revert the commit?

No - that would break arm < armv6 and IIRC parisc.

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigBA3054419E5906AB8FD47DA1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk15KgMACgkQjTAFq1RaXHPOiACfVZ2eBCOHpTiB8IRAIb/zkDc8
hlMAn1W0jDtEsKhBkkTALBB2beWz0GBp
=jiZV
-----END PGP SIGNATURE-----

--------------enigBA3054419E5906AB8FD47DA1--
