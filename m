Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab1FOQBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 12:01:19 -0400
Received: from frost.carfax.org.uk ([212.13.194.111]:40795 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab1FOQBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 12:01:16 -0400
Date: Wed, 15 Jun 2011 17:01:11 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kreijack@libero.it
Subject: Re: [PATCH v2] btrfs: Remove all sysfs entries
Message-ID: <20110615160111.GB17257@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
	Mitch Harder <mitch.harder@sabayonlinux.org>,
	Maarten Lankhorst <m.b.lankhorst@gmail.com>,
	Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	kreijack@libero.it
References: <4DF86FFF.5000406@gmail.com>
 <20110615103431.GA15127@carfax.org.uk>
 <BANLkTik5TXXBx6tnYiKNs075n9xHq4_zSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jq0ap7NbKX2Kqbes"
Content-Disposition: inline
In-Reply-To: <BANLkTik5TXXBx6tnYiKNs075n9xHq4_zSw@mail.gmail.com>
X-GPG-Fingerprint: 8C59 86C7 81F3 93FE BB02  DDB1 20AC B3BE 515C 238D
X-GPG-Key: 515C238D
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.20 (2009-06-14)
X-frost.carfax.org.uk-Spam-Score: -0.0 (/)
X-frost.carfax.org.uk-Spam-Report: Spam detection software, running on the system "admin.kwak.bitfolk.com", has
 identified this incoming email as possible spam.  The original message
 has been attached to this so you can view it (if it isn't spam) or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  On Wed, Jun 15, 2011 at 10:54:13AM -0500, Mitch Harder wrote:
    > On Wed, Jun 15, 2011 at 5:34 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
    > > On Wed, Jun 15, 2011 at 10:40:31AM +0200, Maarten Lankhorst wrote: >
   >> Seems that currently none of the sysfs are created any more, so just >
   >> remove sysfs support entirely. > >> > >> Fixes compiling warnings in 3.0rc3
    > > > > I would actually like to retain sysfs support -- the current > >
   entries may not be used (or useful, or in the right place, or even > > visible
    these days), but there's plenty of things that could and > > should go in
    sysfs from btrfs. > > > > So, please do remove the unwanted/unused file entries,
    but could > > you leave the sysfs file itself, and the (limited) bits that
    create > > the btrfs subdir? Otherwise, I'm going to be putting it all back
    in > > this weekend when I get the time to revisit Goffredo's old sysfs >
    > patch... > > I'm not sure if Goffredo is following this thread, but I think
    you'll > need a missing patch to provide a fs/btrfs/sysfs.h file in order
    to > use his sysfs patch. [...] 
 Content analysis details:   (-0.0 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -0.0 T_RP_MATCHES_RCVD      Envelope sender domain matches handover relay
                             domain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jq0ap7NbKX2Kqbes
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 15, 2011 at 10:54:13AM -0500, Mitch Harder wrote:
> On Wed, Jun 15, 2011 at 5:34 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Wed, Jun 15, 2011 at 10:40:31AM +0200, Maarten Lankhorst wrote:
> >> Seems that currently none of the sysfs are created any more, so just
> >> remove sysfs support entirely.
> >>
> >> Fixes compiling warnings in 3.0rc3
> >
> > =A0 I would actually like to retain sysfs support -- the current
> > entries may not be used (or useful, or in the right place, or even
> > visible these days), but there's plenty of things that could and
> > should go in sysfs from btrfs.
> >
> > =A0 So, please do remove the unwanted/unused file entries, but could
> > you leave the sysfs file itself, and the (limited) bits that create
> > the btrfs subdir? Otherwise, I'm going to be putting it all back in
> > this weekend when I get the time to revisit Goffredo's old sysfs
> > patch...
>=20
> I'm not sure if Goffredo is following this thread, but I think you'll
> need a missing patch to provide a fs/btrfs/sysfs.h file in order to
> use his sysfs patch.

   OK, thanks for the warning. I'm not expecting Goffredo's patch to
be a complete drop-in turn-key solution -- he did warn that it was
only a first draft when he originally posted it.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Anyone using a computer to generate random numbers is, of ---   =20
                       course,  in a state of sin.                      =20

--jq0ap7NbKX2Kqbes
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFN+NdHIKyzvlFcI40RAoIUAJ9ufFg+xZepj4VKc2wYCmeGV6Vu2wCgiays
bCeZbvkHdWEI5vFZOXG/Fu4=
=EfZ9
-----END PGP SIGNATURE-----

--jq0ap7NbKX2Kqbes--
