Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab1C2IlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 04:41:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40460 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab1C2IlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 04:41:03 -0400
Date: Tue, 29 Mar 2011 10:40:55 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Hillf Danton <dhillf@gmail.com>, Greg KH <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] uio: fix allocating minor id for uio device
Message-ID: <20110329084055.GB2901@pengutronix.de>
References: <AANLkTikKNOPi1ALD0vWiwPKDzUJSseuis63qYJKYkj6=@mail.gmail.com>
 <20110328214504.GC2786@local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z6Eq5LdranGa6ru8"
Content-Disposition: inline
In-Reply-To: <20110328214504.GC2786@local>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z6Eq5LdranGa6ru8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > -	idev->minor =3D id & MAX_ID_MASK;
> > +	if (id < UIO_MAX_DEVICES)
> > +		idev->minor =3D id;
> > +	else {

As it needs respinning anyway: If the else-block has braces, it is
recommended for the if-block, too

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--z6Eq5LdranGa6ru8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk2RmxcACgkQD27XaX1/VRs9wgCgpncLjvAlCcVfxGVLvZtEbe/E
h+UAnRzMHs0bJkutuDc6JJH0bDPGwgoL
=phxu
-----END PGP SIGNATURE-----

--z6Eq5LdranGa6ru8--
