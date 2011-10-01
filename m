Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab1JAPHl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 11:07:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59225 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157Ab1JAPHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 11:07:35 -0400
Date: Sat, 1 Oct 2011 17:07:30 +0200
From: Lars =?iso-8859-1?Q?M=FCller?= <lmuelle@suse.de>
To: Anton Altaparmakov <aia21@cam.ac.uk>, Jeremy Allison <jra@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        LKML <linux-kernel@vger.kernel.org>,
        PWF Linux <pwf-linux@ucs.cam.ac.uk>, Steve French <sfrench@samba.org>,
        Jeff Layton <jlayton@samba.org>
Subject: Re: CIFS  kernel module bug
Message-ID: <20111001150730.GJ5170@giles.fritz.box>
References: <A904EFBF-CBC1-4842-9E50-2A556103B8AA@cam.ac.uk>
 <20110930140409.51c1a94c@tlielax.poochiereds.net>
 <E35BF115-B84D-4DB2-BDDC-E356052282F2@cam.ac.uk>
 <20110930234711.GD14147@samba2>
 <alpine.LSU.2.00.1110010122210.15683@hermes-2.csi.cam.ac.uk>
 <6704F264-5437-4948-8C1B-FE3F5CE59C24@cam.ac.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fUvfsPTz/SzOZDdw"
Content-Disposition: inline
In-Reply-To: <6704F264-5437-4948-8C1B-FE3F5CE59C24@cam.ac.uk>
X-Operating-System: SUSE Linux 2.6.37.6-0.7-default x86_64
X-PGP-Key-Fingerprint: FEEE 231E 36E5 AD5F 1F80  BF7E E0D0 622B 414A 57C3
X-PGP-Key-ID: 0x414A57C3
X-Pflichtfeld: X-Pflichtfeld: SUSE LINUX =?iso-8859-1?Q?P?=
 =?iso-8859-1?Q?roducts_GmbH=2C_GF=3A_Jeff_Hawn=2C_Jennifer_Guild=2C_Felix?=
 =?iso-8859-1?Q?_Imend=F6rffer=2C_HRB_16746_=28AG_N=FCrnberg=29?=
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fUvfsPTz/SzOZDdw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 01, 2011 at 09:48:12AM +0100, Anton Altaparmakov wrote:
>=20
> On 1 Oct 2011, at 01:34, J.P. King wrote:
> > Anton will be asleep, so I'll attempt to answer this one.
> >=20
> >> What server code is the OES CIFS server running ? I thought Novell CIFS
> >> services were all Samba based.
> >=20
> > We have been told by the people upstairs who run the server that it isn=
't.
>=20
> It is not Samba based.  Like Apple, Novell have written their own since S=
amba decided to go GPLv3=E2=80=A6

(Potential) FUD alert. ;)

This Novell CIFS server existed before Novell bought SUSE.  And the
decission to go with it instead of Samba had nothing to do with the move
of Samba from GPL v2 to v3.

Lars
--=20
Lars M=C3=BCller [=CB=88la=CB=90(r)z =CB=88m=CA=8Fl=C9=90]
Samba Team
SUSE Linux, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany

--fUvfsPTz/SzOZDdw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iD8DBQFOhyyy4NBiK0FKV8MRAvzbAJwLsh6foKhEobFCSnp5tqOFeLEn3ACghdM8
UYCWNvh08eMSW2Hihkg2xYM=
=Fi0T
-----END PGP SIGNATURE-----

--fUvfsPTz/SzOZDdw--
