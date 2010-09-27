Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855Ab0I0Jim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 05:38:42 -0400
Received: from wrar.name ([109.74.195.39]:57968 "EHLO haley.wrar.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932420Ab0I0Jil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 05:38:41 -0400
Date: Mon, 27 Sep 2010 15:38:26 +0600
From: Andrey Rahmatullin <wrar@altlinux.org>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [TuxOnIce-devel] Swsusp patches applied to suspend-2.6#linux-next
Message-ID: <20100927093826.GA6904@wrars-comp.wrarsdomain>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
 <20100927080000.GA7032@wrars-comp.wrarsdomain>
 <4CA055EF.6050608@tuxonice.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <4CA055EF.6050608@tuxonice.net>
X-Operating-System: ALT Linux Sisyphus
X-Jabber-Id: wrar@altlinux.org
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 27, 2010 at 06:29:35PM +1000, Nigel Cunningham wrote:
> >> As discussed, here are the patches, modified to apply against your cur=
rent
> >> linux-next tree. A new first patch splits compression support out into=
 its
> >> own file, removing the need to have two versions of the load_image and
> >> save_image routines, minimising the changes to the remainder of the
> >> patches and making things cleaner than would otherwise be the case.
> >>
> >> On my laptop, single-threaded compression actually slows writing down =
=66rom
> >> 175MB/s to around 100-120MB/s (depending on how well the image compres=
ses).
> >> Reading speed improves from 218MB/s to around 245MB/s. I expect that
> >> multithreaded writing would bring the writing (and reading) speeds back
> >> up. It's on my swsusp to do list :)
> > Works here.
>=20
> Ah. You're too fast for me :)
>=20
> What sort of speeds are you seeing?
Well, I don't see any 'PM: Image read at' etc in the kernel logs after
resuming (in for-rafael tree).

--=20
WBR, wRAR (ALT Linux Team)

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJMoGYSAAoJEOih81koZvPBErkH/A7diPcNueeqqU/6InVVGCIe
vd7n3SweF3kA4tlo0JB3qgcqNyJJX98oLF5dKDyisoBAF3zfq1DfoyUNnJxdOKMK
8m5LEbSfPD9m8UTjpJhu9dj6JpwCKL3L9LeGDKUYl0gZJEJ2yigUTYc2RHH6pGWc
N/oUNw6FxMHjD41AT384SoQEreoe+zJrrSzJnaQyZv0iz4tRpJ6K8AMt9OT31O1s
gJ4JMfEcvxeMj8APhefcfP6Q1NZE7pqMuEJBKxNovI9ob2f4j6cFZARla9Na2kvz
oF0mNjNb2hMMUCt8PRostNdPfzYRhLSYs43jRYIcw6McIgKS8Oc6G4yrPmdsWks=
=jAAF
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
