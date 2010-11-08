Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab0KHLSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 06:18:03 -0500
Received: from smtp206.alice.it ([82.57.200.102]:41173 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190Ab0KHLSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 06:18:00 -0500
Date: Mon, 8 Nov 2010 12:17:15 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Alan Ott <alan@signal11.us>, Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Alexey Dobriyan <adobriyan@gmail.com>, Tejun Heo <tj@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>, Stephane Chatty <chatty@enac.fr>,
        Michael Poole <mdpoole@troilus.org>,
        Bastien Nocera <hadess@hadess.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 0/2] Get and Set Feature Reports on HIDRAW (USB and
 Bluetooth)
Message-Id: <20101108121715.ae2da4af.ospite@studenti.unina.it>
In-Reply-To: <alpine.LNX.2.00.1011011523150.15851@pobox.suse.cz>
References: <1281442367.12579.206.camel@localhost.localdomain>
	<1281990059-3562-1-git-send-email-alan@signal11.us>
	<alpine.LNX.2.00.1008231459370.1019@pobox.suse.cz>
	<alpine.LNX.2.00.1009021724480.26813@pobox.suse.cz>
	<alpine.LNX.2.00.1009221408330.26813@pobox.suse.cz>
	<alpine.LNX.2.00.1011011523150.15851@pobox.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__8_Nov_2010_12_17_15_+0100_wOAKV+vaqM7S8DO7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__8_Nov_2010_12_17_15_+0100_wOAKV+vaqM7S8DO7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 1 Nov 2010 15:23:34 -0400 (EDT)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Wed, 22 Sep 2010, Jiri Kosina wrote:
>=20
> > > > > This is version 4. Built against 2.6.35+ revision 320b2b8de12698 .
> > > > >=20
> > > > > Alan Ott (2):
> > > > >   HID: Add Support for Setting and Getting Feature Reports from h=
idraw
> > > > >   Bluetooth: hidp: Add support for hidraw  HIDIOCGFEATURE  and
> > > > >     HIDIOCSFEATURE
[...]
> > > ... Marcel?
> > >=20
> > > I'd really like not to miss 2.6.37 merge window with this.
> >=20
> > Seemingly I have not enought powers to get statement from Marcel here=20
> > these days/weeks.
> >=20
> > Davem, would you perhaps be able to step in here?
>=20
> Marcel, any word on this patchset by chance?
>=20

Hopefully Alan will manage to send a v5 sometime soon, Alan I don't want
to pressure you, just remember to CC Gustavo F. Padovan (see
MAINTAINERS) as he looks to be the most active bluetooth maintainer
these days.

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Mon__8_Nov_2010_12_17_15_+0100_wOAKV+vaqM7S8DO7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkzX3DsACgkQ5xr2akVTsAEZagCgmarMRB+cv6ZnfEtdAF8ekkkf
/f0Anj1kzzXCG73SZ+dLjuMVQiyQojpe
=6gey
-----END PGP SIGNATURE-----

--Signature=_Mon__8_Nov_2010_12_17_15_+0100_wOAKV+vaqM7S8DO7--
