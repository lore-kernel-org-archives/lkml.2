Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab2BWXIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:08:42 -0500
Received: from ist.d-labs.de ([213.239.218.44]:47535 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756141Ab2BWXIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:08:40 -0500
Date: Fri, 24 Feb 2012 00:08:26 +0100
From: Florian Mickler <florian@mickler.org>
To: Toralf =?ISO-8859-15?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org, mjg@redhat.com, dmitry.torokhov@gmail.com,
        linux-input@vger.kernel.org
Subject: Re: multi-media key "mute" no longer recognized
Message-ID: <20120224000826.05039158@schatten>
In-Reply-To: <201201231152.25344.toralf.foerster@gmx.de>
References: <201201231152.25344.toralf.foerster@gmx.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/DPjb43P1iTL6f7sTIE6Acnc"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/DPjb43P1iTL6f7sTIE6Acnc
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Let's try to cc some people...

On Mon, 23 Jan 2012 11:52:24 +0100
Toralf F=F6rster <toralf.foerster@gmx.de> wrote:

> With kernel 3.1.10 I could mute my system by pressing the appropriate=20
> multimedia button either at my ThinkPad or at my external keyboard.
> With 3.2.1 this doesn't work anymore although the button itself is recogn=
ized=20
> when pressed (checked with xev).
>=20
> Now I'm wondering where to start to debug ?
>=20

In https://bugzilla.kernel.org/show_bug.cgi?id=3D42685 Toralf wrote:
> > with xev I get only one small diff related to "serial":
> >=20
> > tfoerste@n22 ~ $ tail -v mute-3.*
> > =3D=3D> mute-3.0.21 <=3D=3D
> > KeyRelease event, serial 33, synthetic NO, window 0x4600001,
> > root 0xc3, subw 0x0, time 293494, (1260,275), root:(1262,298),
> > state 0x0, keycode 121 (keysym 0x1008ff12, XF86AudioMute), same_screen =
YES,
> > XLookupString gives 0 bytes:=20
> > XFilterEvent returns: False
> >=20
> >=20
> > =3D=3D> mute-3.2.6 <=3D=3D
> > KeyRelease event, serial 32, synthetic NO, window 0x3a00001,
> > root 0xc3, subw 0x0, time 3424766, (-1217,745), root:(74,768),
> > state 0x0, keycode 121 (keysym 0x1008ff12, XF86AudioMute), same_screen =
YES,
> > XLookupString gives 0 bytes:=20
> > XFilterEvent returns: False


--Sig_/DPjb43P1iTL6f7sTIE6Acnc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk9GxvEACgkQPjqCkyL3Kv1/CQCfUyDJZNPDgmxjwshWKLnn479G
INIAnjWo1zcuMzt2pKalgAWEv/R+GdAk
=a8ag
-----END PGP SIGNATURE-----

--Sig_/DPjb43P1iTL6f7sTIE6Acnc--
