Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab1JRInO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 04:43:14 -0400
Received: from smtp206.alice.it ([82.57.200.102]:40782 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932145Ab1JRInI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 04:43:08 -0400
Date: Tue, 18 Oct 2011 10:40:54 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: David Rientjes <rientjes@google.com>
Cc: "Tomas M." <tmezzadra@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: kernel OOPS when releasing usb webcam (random)
Message-Id: <20111018104054.07aa2bcf462c0268a23c0139@studenti.unina.it>
In-Reply-To: <alpine.DEB.2.00.1110171703210.13515@chino.kir.corp.google.com>
References: <4E9CB0C2.3030902@gmail.com>
	<alpine.DEB.2.00.1110171703210.13515@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__18_Oct_2011_10_40_54_+0200_7PRUqfStqHoVLGr3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_Oct_2011_10_40_54_+0200_7PRUqfStqHoVLGr3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 17 Oct 2011 17:05:19 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Mon, 17 Oct 2011, Tomas M. wrote:
>=20
> > im getting the following null pointer dereference from time to time when
> > releasing a usb camera.
> >=20
> > maybe this trace is of assistance...please reply to my mail since im not
> > subscribed.
> >=20
>=20
> I suspect this is happening in v4l2_device_unregister_subdev().  Adding=20
> Guennadi, Mauro, and linux-media.
>=20
> > BUG: unable to handle kernel NULL pointer dereference at 0000006c
> > IP: [<f90be6c2>] v4l2_device_release+0xa2/0xf0 [videodev]

Hi,

I sent a fix for a similar trace last week:
http://patchwork.linuxtv.org/patch/8124/

Tomas, can you test it fixes the problem for you too?

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Tue__18_Oct_2011_10_40_54_+0200_7PRUqfStqHoVLGr3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk6dO5YACgkQ5xr2akVTsAF1PgCfXIdAGBZvlHpJEq5fTT8wTSg7
FKsAoK2KRQ7YXcBEhrI3cgwMHJz/Hp2G
=MJ2F
-----END PGP SIGNATURE-----

--Signature=_Tue__18_Oct_2011_10_40_54_+0200_7PRUqfStqHoVLGr3--
