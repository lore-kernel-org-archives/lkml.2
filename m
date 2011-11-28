Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab1K1CwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 21:52:13 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:46026 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab1K1CwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 21:52:11 -0500
Date: Mon, 28 Nov 2011 13:52:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dave Airlie <airlied@linux.ie>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ville =?UTF-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Rob Clark <rob.clark@linaro.org>, Greg KH <greg@kroah.com>
Subject: Re: linux-next: build failure after merge of the drm tree
Message-Id: <20111128135204.33bb929d7495d7830d09dfc3@canb.auug.org.au>
In-Reply-To: <20111125103011.18e167cd@lxorguk.ukuu.org.uk>
References: <20111116113007.5656a7b4823ba085a46c57ae@canb.auug.org.au>
	<20111125124913.405fc8360a185f3116adb5ec@canb.auug.org.au>
	<20111125103011.18e167cd@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_Nov_2011_13_52_04_+1100_Jv5CLBfM4lYoVfoC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Nov_2011_13_52_04_+1100_Jv5CLBfM4lYoVfoC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

On Fri, 25 Nov 2011 10:30:11 +0000 Alan Cox <alan@lxorguk.ukuu.org.uk> wrot=
e:
>
> > Ping?
>=20
> As I said last time you asked this - the correct merge resolution is to
> pull the DRM updates and mark the staging GMA500 Kconfig "&& BROKEN". The
> staging driver is frozen while we merge outside of staging and will not
> be getting any attention at this point - changes there just mess up the
> move work which is far more important.
>=20
> Also nothing in staging should be allowed to hold up real work. The
> resolution for anything in staging blocking merges is to mark the staging
> parts && BROKEN IMHO

Then if you are moving a driver out of staging, you should put a patch in
your tree to disable it in staging (or remove it in staging) and send
that patch to Greg as well.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__28_Nov_2011_13_52_04_+1100_Jv5CLBfM4lYoVfoC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO0vdUAAoJEECxmPOUX5FEngAP/3ntrSmddSXWID9AYJkae7jI
6qvYQksXkZIghNdSONcyyvz71K0EfB/gQawCXWzxbT6ZNpHs/3twXn54A/BFg/qX
TcwXZsuR7WCLnCTfVaP3V4rEpoKF2WEO2lRwC2dB8i5sx5OzoOb0+YoXiNj88K/u
oZT1zvemQsz5fyVrfEZOt/i4T+cOHqTvkQbdWpmJo+JIzjFSTzSF8fFORQCGwWd4
3+flAPSlKQ6FWNXHLKcvVnevNcdc1HYD1K5fdxL8L+RFl2w++sLMsI4gVRxvwRVA
gsiFztqk0E3SfevztL3A+fd1RJPBvejRU12df0b9/UKt2LreNDou6M0zbxeH7P6b
zQHmlVqlD5IGqNKL08sgyZMTos3T9HgBw6IN8AfHXZKO76UKGA/f6PcK11tcpAAz
2PIAzQGVjc5Tm9jGiS2wuxgiiBUWtnxRqW1okukG+QhZS6OtvY7tRMwV2K8cyJs0
IFb3VnNT7aAr1ZBRjprOHguKQ+WYGcbf2gkkVyMfw8JFH0R/V7x1Enze5Wh6p6Z/
TxPIPhRygMsY54JSFFKSOcMqO50VJIZcJiWViqopArJUPjJIV2H9YJludDQMN7XK
cueqw75/kBW4vXsRvWQuSCWnE8VUeDGjPmrsW/ib+7Dq7akKMVFZVioZBa8VoiYz
kzboSe3Gs9iKY1GhUbdp
=MXTJ
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Nov_2011_13_52_04_+1100_Jv5CLBfM4lYoVfoC--
