Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab0EQKZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 06:25:53 -0400
Received: from smtp-out108.alice.it ([85.37.17.108]:2725 "EHLO
	smtp-out108.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab0EQKZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 06:25:51 -0400
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 May 2010 06:25:51 EDT
Date: Mon, 17 May 2010 12:15:25 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: [PATCH v2] leds-lp3944: properly handle lp3944_configure fail
 in lp3944_probe
Message-Id: <20100517121525.c895d8d9.ospite@studenti.unina.it>
In-Reply-To: <1274089668.28623.3.camel@mola>
References: <1274089668.28623.3.camel@mola>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__17_May_2010_12_15_26_+0200_F=Y0Wwa_vVbDTnkN"
X-OriginalArrivalTime: 17 May 2010 10:15:36.0917 (UTC) FILETIME=[E4BA4050:01CAF5A9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_May_2010_12_15_26_+0200_F=Y0Wwa_vVbDTnkN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 17 May 2010 17:47:48 +0800
Axel Lin <axel.lin@gmail.com> wrote:

> In current implementation, lp3944_probe return 0 even if lp3944_configure=
 fail.
> Therefore, led_classdev_unregister will be executed twice
> ( in error handling of lp3944_configure and lp3944_remove ).
> This patch properly handles lp3944_configure fail in lp3944_probe.
>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Antonio Ospite <ospite@studenti.unina.it>

Thanks.

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Mon__17_May_2010_12_15_26_+0200_F=Y0Wwa_vVbDTnkN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvxFz4ACgkQ5xr2akVTsAF+wgCfYgqRqiVuX7/budB5yGdU3dLs
OtoAoJKYXkhXvWcGNEoQ7o6vuZvCy7MB
=q9Xd
-----END PGP SIGNATURE-----

--Signature=_Mon__17_May_2010_12_15_26_+0200_F=Y0Wwa_vVbDTnkN--
