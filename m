Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab0JOHpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 03:45:21 -0400
Received: from smtp207.alice.it ([82.57.200.103]:56435 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058Ab0JOHpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 03:45:18 -0400
Date: Fri, 15 Oct 2010 09:44:36 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Greg KH <greg@kroah.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Neukum <oliver@neukum.name>,
        stable@kernel.org, Alan Ott <alan@signal11.us>
Subject: Re: [stable] [PATCH 0/2] HID: hidraw, fix two NULL pointer
 dereferences
Message-Id: <20101015094436.50ab68f3.ospite@studenti.unina.it>
In-Reply-To: <alpine.LNX.2.00.1010061130430.29535@pobox.suse.cz>
References: <alpine.LNX.2.00.1010041548580.29535@pobox.suse.cz>
	<1286292017-6746-1-git-send-email-ospite@studenti.unina.it>
	<20101005174200.GB29937@kroah.com>
	<20101005221619.88904313.ospite@studenti.unina.it>
	<alpine.LNX.2.00.1010061130430.29535@pobox.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__15_Oct_2010_09_44_36_+0200_dCY07T44pNUJwZwc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Oct_2010_09_44_36_+0200_dCY07T44pNUJwZwc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 6 Oct 2010 11:31:55 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Tue, 5 Oct 2010, Antonio Ospite wrote:
>=20
> > > > here are some fixes to hidraw.
> > > >=20
> > > > Patches are against 2.6.36-rc6, but they should be ported to other
> > > > maintained stable kernels as well.
[...]
>=20
> I have added the 'Cc:' markings now and applied both patches, thanks.
>=20

Jiri, these are not in 2.6.36-rc8, any chance we can make it for 2.6.36?

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Fri__15_Oct_2010_09_44_36_+0200_dCY07T44pNUJwZwc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAky4BmUACgkQ5xr2akVTsAHICgCeJM3vqM31uN/fB04hufuRFq0l
SjMAnA7stpeoUMKAkU6a0/DFIAwj/O9U
=01cY
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Oct_2010_09_44_36_+0200_dCY07T44pNUJwZwc--
