Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883Ab1DMIxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 04:53:48 -0400
Received: from smtp206.alice.it ([82.57.200.102]:50132 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757825Ab1DMIxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 04:53:47 -0400
Date: Wed, 13 Apr 2011 10:53:37 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, openezx-devel@lists.openezx.org,
        "John W . Linville" <linville@tuxdriver.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
        Guiming Zhuo <gmzhuo@gmail.com>
Subject: Re: [PATCH v2] rfkill: Regulator consumer driver for rfkill
Message-Id: <20110413105337.0e106fe8.ospite@studenti.unina.it>
In-Reply-To: <1302608488.3639.15.camel@jlt3.sipsolutions.net>
References: <1302082178.3811.7.camel@jlt3.sipsolutions.net>
	<1302260395-11872-1-git-send-email-ospite@studenti.unina.it>
	<1302608488.3639.15.camel@jlt3.sipsolutions.net>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-unknown-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__13_Apr_2011_10_53_37_+0200_rl_=nQSEa+t+5zJn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__13_Apr_2011_10_53_37_+0200_rl_=nQSEa+t+5zJn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Apr 2011 13:41:28 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> > +	dev_info(&pdev->dev, "initialized\n");
>=20
> Is that message really useful?
>

I can print the pdata->name here as well as an excuse to keep it,
reality is that I just like visual feedback in dmesg when a driver has
been loaded.

> Other than that, looks good to me.
>=20
> johannes
>

In another message you said that the comment in rfkill-regulator.h
still seemed a little wrong to you, would you elaborate more about what
you were referring to?

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Wed__13_Apr_2011_10_53_37_+0200_rl_=nQSEa+t+5zJn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2lZJEACgkQ5xr2akVTsAFCuACcD7DJpTaZ91yuxPAKX/HKd/hS
u/UAnAlQzA8g0Apy/LGU/hcwFRMsGkj2
=C7Hz
-----END PGP SIGNATURE-----

--Signature=_Wed__13_Apr_2011_10_53_37_+0200_rl_=nQSEa+t+5zJn--
