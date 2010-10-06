Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab0JFKBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 06:01:43 -0400
Received: from smtp205.alice.it ([82.57.200.101]:55934 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216Ab0JFKBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 06:01:41 -0400
Date: Wed, 6 Oct 2010 12:01:29 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Alan Ott <alan@signal11.us>, Oliver Neukum <oliver@neukum.name>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 0/2] HID: hidraw, fix two NULL pointer dereferences
Message-Id: <20101006120129.52da81d3.ospite@studenti.unina.it>
In-Reply-To: <4CAB94A0.8040402@gmail.com>
References: <alpine.LNX.2.00.1010041548580.29535@pobox.suse.cz>
	<1286292017-6746-1-git-send-email-ospite@studenti.unina.it>
	<4CAB94A0.8040402@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__6_Oct_2010_12_01_29_+0200_pvfp_vBqoKLknSIh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Oct_2010_12_01_29_+0200_pvfp_vBqoKLknSIh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 05 Oct 2010 23:12:00 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> On 10/05/2010 05:20 PM, Antonio Ospite wrote:
> > here are some fixes to hidraw.
> >=20
> > Patches are against 2.6.36-rc6, but they should be ported to other
> > maintained stable kernels as well.
> >=20
> > Antonio Ospite (2):
> >   HID: hidraw, fix a NULL pointer dereference in hidraw_ioctl
> >   HID: hidraw, fix a NULL pointer dereference in hidraw_write
>=20
> Hi, please fix also the window in hidraw_release.
>

I am not sure I get what you mean, can you please add more details?

> thanks,
> --=20
> js
>=20

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Wed__6_Oct_2010_12_01_29_+0200_pvfp_vBqoKLknSIh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkysSPkACgkQ5xr2akVTsAHyPQCdE0Jtmhz8Z2xq9vZUoNXZKwFh
x7kAn2GYNoGlkgOZTNj+nYmjHw3pgfpK
=KMIf
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Oct_2010_12_01_29_+0200_pvfp_vBqoKLknSIh--
