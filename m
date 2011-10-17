Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab1JQVps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 17:45:48 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49474 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab1JQVpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 17:45:46 -0400
Date: Tue, 18 Oct 2011 06:45:44 +0900
From: Mattia Dongili <malattia@linux.it>
To: Valdis.Kletnieks@vt.edu
Cc: John Hughes <john@calvaedi.com>, linux-kernel@vger.kernel.org,
        Stelian Pop <stelian@popies.net>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>
Subject: Re: sony-laptop driver: Volume keys on Sony Vaio TX3 don't work
Message-ID: <20111017214543.GB1311@kamineko.org>
References: <4E9ABBF6.3000504@calvaedi.com>
 <4E9ADBD3.4070404@calvaedi.com>
 <4E9B182A.3020101@calvaedi.com>
 <74494.1318789218@turing-police.cc.vt.edu>
 <20111016213800.GA12703@kamineko.org>
 <81436.1318801813@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <81436.1318801813@turing-police.cc.vt.edu>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 3.1.0-rc4+ x86_64
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 16, 2011 at 05:50:13PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 17 Oct 2011 06:38:01 +0900, Mattia Dongili said:
> > On Sun, Oct 16, 2011 at 02:20:18PM -0400, Valdis.Kletnieks@vt.edu wrote:
> > > Do we know if this is applicable to all Sony laptops, or only a few b=
usticated
> > > models?
> >
> > I believe the latter is the case, the old A series also had this
> > problem. Of course applying the patch will break other models (SZ is one
> > I'm sure about) so there is no actual winner here unless we figure out
> > how to properly decode keys on sonypi models (this problem is
> > specifically related to two phase hotkey decoding, see the irq handler).
>=20
> And let me guess - two phase hotkey decoding is sufficiently weird that
> nobody wants to actually fix *that* code, right? (Rhetorical question, I
> already know the answer to that one).
>=20
> If that's not an option, perhaps we need a per-model quirk that patches u=
p the
> tables at boot time?  If we do that, we may want to re-arrange the table =
so the
> affected entries are at the front or something to help insure we don't pa=
tch
> the wrong entries if somebody else inserts new lines.

Wouldn't udev do that already?
We may actually want to remove those events that never get looked up in
the tables instead.

--=20
mattia
:wq!

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk6cogcACgkQgpRPaOotLEG++ACg25hn4cGE2OnY26fX9czlIgkC
3aAAnj3SzUNLZip5g3ElL64yHs6Vc3j9
=RZB7
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
