Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab1FGOPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:15:40 -0400
Received: from smtp204.alice.it ([82.57.200.100]:36761 "EHLO smtp204.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754756Ab1FGOPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:15:39 -0400
Date: Tue, 7 Jun 2011 16:12:21 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Simon Wood <simon@mungewell.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marcin Tolysz <tolysz@gmail.com>
Subject: Re: [PATCH 1/2] sony_ff_hid_descriptor
Message-Id: <20110607161221.3334dcdd.ospite@studenti.unina.it>
In-Reply-To: <alpine.LNX.2.00.1106071531330.22872@pobox.suse.cz>
References: <80b32cfd7dc9e8afee2c4d9e21d1a7e3.squirrel@host171.canaca.com>
	<1306145999-15643-1-git-send-email-simon@mungewell.org>
	<20110601214924.36ec42ad.ospite@studenti.unina.it>
	<alpine.LNX.2.00.1106071531330.22872@pobox.suse.cz>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__7_Jun_2011_16_12_21_+0200_uo6GxaFJs1W+LCCS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_Jun_2011_16_12_21_+0200_uo6GxaFJs1W+LCCS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Jun 2011 15:32:15 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Wed, 1 Jun 2011, Antonio Ospite wrote:
>=20
> > On Mon, 23 May 2011 03:19:58 -0700
> > Simon Wood <simon@mungewell.org> wrote:
> >=20
> > > This patch modifies the HID descriptor to allow the reporting of
> > > the accelerometers and gyro via a joystick axis.
> >=20
> > I am going to test it tomorrow, but for now I notice that the
> > Signed-off-by is missing. Wait for the test before resending tho.
> >=20
> > Plus, the short commit message can be improved a little bit, and the
> > long commit message could use the classic imperative form used in kernel
> > commit messages: "Modify the HID descriptor to...", but these are just
> > suggestions.
[...]

> What was the result of your testing of the patches, please?
>=20

There has been an off-list discussion and I think Simon is going to send
the patches once again in a form which amends the HID descriptor even
when the Sixaxis is connected via Bluetooth.

I will retest and add the Tested-by on those.

Regards,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Tue__7_Jun_2011_16_12_21_+0200_uo6GxaFJs1W+LCCS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk3uMcUACgkQ5xr2akVTsAFG7wCgi0pOMpxNh+ocY3F+LQ10kuAv
ZR4AoIXmkdlRcsCsq6YQlaabXgnDQEQc
=UxKT
-----END PGP SIGNATURE-----

--Signature=_Tue__7_Jun_2011_16_12_21_+0200_uo6GxaFJs1W+LCCS--
