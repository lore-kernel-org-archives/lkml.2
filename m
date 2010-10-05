Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab0JEUQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 16:16:53 -0400
Received: from smtp206.alice.it ([82.57.200.102]:45134 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490Ab0JEUQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 16:16:51 -0400
Date: Tue, 5 Oct 2010 22:16:19 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Greg KH <greg@kroah.com>
Cc: linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, Oliver Neukum <oliver@neukum.name>,
        stable@kernel.org, Alan Ott <alan@signal11.us>
Subject: Re: [stable] [PATCH 0/2] HID: hidraw, fix two NULL pointer
 dereferences
Message-Id: <20101005221619.88904313.ospite@studenti.unina.it>
In-Reply-To: <20101005174200.GB29937@kroah.com>
References: <alpine.LNX.2.00.1010041548580.29535@pobox.suse.cz>
	<1286292017-6746-1-git-send-email-ospite@studenti.unina.it>
	<20101005174200.GB29937@kroah.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__5_Oct_2010_22_16_19_+0200_FVVjoQxi.7hCeP/t"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Oct_2010_22_16_19_+0200_FVVjoQxi.7hCeP/t
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Oct 2010 10:42:00 -0700
Greg KH <greg@kroah.com> wrote:

> On Tue, Oct 05, 2010 at 05:20:15PM +0200, Antonio Ospite wrote:
> > Hi,
> >=20
> > here are some fixes to hidraw.
> >=20
> > Patches are against 2.6.36-rc6, but they should be ported to other
> > maintained stable kernels as well.
> >=20
[...]
> >=20
> > The first one has been sent already but I am resending it with
> > stable@stable@kernel.org in the recipients list.
>=20
> Please read Documentation/stable_kernel_rules.txt which shows you how to
> properly notify the stable developer to pick up the patch (hint, cc:ing
> them on the patch is not the correct way, you need to add the mark to
> the signed-off-by: area.)
>=20

I see now, thanks Greg.

Jiri, are you adding the Cc: mark to these when you apply them? I
misunderstood your previous statement about that and thought CCing like
in recipients was enough.

There is one thing which is not 100% clear to me from the doc (my
fault): are patches targeted to -stable to be sent _twice_? Once for
linus master branch (this is what "upstream" means in that context,
isn't it?) and once for -stable with the commit ID of the former? Is
the Cc mark meant just to automate this very process? It seemed to me
that items 1 and 2 of the "Procedure" in
Documentation/stable_kernel_rules.txt are alternative each other.

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Tue__5_Oct_2010_22_16_19_+0200_FVVjoQxi.7hCeP/t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyrh5MACgkQ5xr2akVTsAFW4QCfU1V4RNPOzMRT03MfsvicOL34
vLoAnjxUNQDUOEwgcdt0zNI6CERPnhjx
=SUVN
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Oct_2010_22_16_19_+0200_FVVjoQxi.7hCeP/t--
