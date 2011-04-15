Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab1DOKYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 06:24:39 -0400
Received: from smtp207.alice.it ([82.57.200.103]:50294 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255Ab1DOKYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 06:24:38 -0400
Date: Fri, 15 Apr 2011 12:24:25 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org,
        openezx-devel@lists.openezx.org,
        "John W . Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
        Guiming Zhuo <gmzhuo@gmail.com>
Subject: Re: [PATCH v3] rfkill: Regulator consumer driver for rfkill
Message-Id: <20110415122425.96ebd7f0.ospite@studenti.unina.it>
In-Reply-To: <20110414130626.GA7890@opensource.wolfsonmicro.com>
References: <1302686356.3731.1.camel@jlt3.sipsolutions.net>
	<1302723645-5286-1-git-send-email-ospite@studenti.unina.it>
	<1302724383.3731.19.camel@jlt3.sipsolutions.net>
	<20110414123912.71e4bd52.ospite@studenti.unina.it>
	<20110414130626.GA7890@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-unknown-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__15_Apr_2011_12_24_25_+0200_W9zl.ZHWB36Is9vb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Apr_2011_12_24_25_+0200_W9zl.ZHWB36Is9vb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Apr 2011 06:06:26 -0700
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Thu, Apr 14, 2011 at 12:39:12PM +0200, Antonio Ospite wrote:
> > Johannes Berg <johannes@sipsolutions.net> wrote:
>=20
> > > Should remove do platform_set_drvdata(pdev, NULL)?
>=20
> > AFAICS this is not strictly necessary because we never check for NULL
> > here and we are setting drvdata again in _probe() each time the module
> > is loaded anyways. If it is considered a good practice for symmetry
> > reasons then I'll add it, no problem. Does anyone have comments on that?
>=20
> We went round this loop with I2C - anything peering at driver data that
> it didn't originally set is buggy anyway so no need to reset to zero.
> If there was a need the platform bus or driver core should do it since
> all devices would need it.
>=20

Ok, so v3 is the one which could be merged.

John if you are the one who is going to commit it, would you please add
the line:

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

Thanks everybody for the comments.

Regards,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Fri__15_Apr_2011_12_24_25_+0200_W9zl.ZHWB36Is9vb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2oHNkACgkQ5xr2akVTsAFR/gCfQ8GE5fi/wdMTh/sMcgr8V/R9
YAsAoI8gzHFlJR28QT32t3ehLnGMSx9f
=Ut+5
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Apr_2011_12_24_25_+0200_W9zl.ZHWB36Is9vb--
