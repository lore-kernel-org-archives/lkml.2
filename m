Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab2IVHcT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 03:32:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52528 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab2IVHcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 03:32:17 -0400
Date: Sat, 22 Sep 2012 09:32:07 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: guanxuetao@mprc.pku.edu.cn
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, Qin Rui <qinrui@mprc.pku.edu.cn>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] unicore32: pwm: Use module_platform_driver()
Message-ID: <20120922073207.GB2538@avionic-0098.mockup.avionic-design.de>
References: <1347956633-15667-1-git-send-email-thierry.reding@avionic-design.de>
 <1347956633-15667-3-git-send-email-thierry.reding@avionic-design.de>
 <50847.162.105.203.8.1348282590.squirrel@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Yylu36WmvOXNoKYn"
Content-Disposition: inline
In-Reply-To: <50847.162.105.203.8.1348282590.squirrel@mprc.pku.edu.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:fDi9CrB7NzrHz5EFTyIE8wpBPz26iDmRLsqt4RJkDMq
 I1JzXqttakddtz773ajmgSbtXonS9OEI074qxfynXRDLZMxoLR
 C4QAAb5/a9wcn/1JP1cbwIRR8YZ5rNiQI4+rwWfS6vIxjiLKZ7
 XxB8uYieeKq4zuv9quowzZ+ISnET+f09TOxAF6Q0FmYFZ0pWuF
 pKlDVn4iTABj0Hv86Nciz/lhZ9RbH78Bg1DcnEspzcUu8t+A7y
 Ix9lZc7xrz0krb/QTlcD6bsb8t5MQi42MyerwyiSsa9PCRpqXr
 Th7lZxZi4y9XbE7Yjsa7bsKSMDz4yZnH1uTZvadS383ypppVDS
 unSytxS/jA6EpLPaxcMdto4w192SszGkpGz4l17na81rLSpDSD
 RehKw27edGdwMpc41kt4DtL1EAFl8sTQ+4avk2afnhzp1O2N4K
 vZ7aW
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Yylu36WmvOXNoKYn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 22, 2012 at 10:56:30AM +0800, guanxuetao@mprc.pku.edu.cn wrote:
> > Some of the boilerplate code can be eliminated by using this macro. The
> > driver was previously registered with an arch_initcall(), so technically
> > this is no longer the same, but when the driver is moved to the PWM
> > framework, deferred probing will take care of any driver probe ordering
> > issues.
> >
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>=20
> Tested-by: Qin Rui <qinrui@mprc.pku.edu.cn>
> Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
>=20
> Thanks & Regards,
> Guan Xuetao

Great! If you don't mind I'll take this through the PWM tree with your
Acked-by.

Thierry

--Yylu36WmvOXNoKYn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQXWl3AAoJEN0jrNd/PrOhX/oQALUjnCF0NIgm1ztU0Ur0XW93
RPH+MCtOLCnhYCD+37b7GZQ86DcNh2QkyLKVVt/q31kBvTTY+OZEMb++sSnRLQWP
OdnlRfNrFrJ2WuPBdbftJ9vJvsdsffdzin8fDvwmSdgCTrL1M1PoKsluD+eqomZV
NpOwBZv9hKIkGZgkUA1t4gy1Tz1361AQgQ4cj5Ta6jEvlH54v9pZQDQ6OEiQSa2J
GtmzTc12SdkLIfh/LXwJYTc0mY8sGbjSlQZbRtoV8mt58h/srAYUTHAGijDpXJq6
/8zIMSX9VlxRg9mDS1qBp9WMMhME49bDiNAIkW6ZNhCq+bM+0NYdts+68lYeaVPi
6JPajNdd4fqhg/nl0KE7+Y2eZA0XmTr0vSDAAHGHAY4OmC5biCDsfKaqC254uDrT
OHEqRdJBu3b+6iS6bgQACiAEkNZfD6y0wFkV8DlnpgUY7E9NKlmbjfXO7KsHG17i
Xjquwj5B2c9imeR6cwfNasoLQbQsPfUsnL6SxlYZY7SV3s20urbw68gXHMeKE3HC
ztitac1rFwDczVrM8YbhsePPXtwjUkqWoAvCnJZqcMvfAMM9f7hQohJc3+zxT137
GjAN/pWWtsxNpQrKrc9YrsbX55hP2oiKXsJlBxPgbEsJ/TIjf5dTwfAVglbLenR9
xRI77iB2JBKfJU8gyFve
=tidH
-----END PGP SIGNATURE-----

--Yylu36WmvOXNoKYn--
