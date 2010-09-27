Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891Ab0I0HSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 03:18:49 -0400
Received: from wrar.name ([109.74.195.39]:57872 "EHLO haley.wrar.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755067Ab0I0HSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 03:18:48 -0400
X-Greylist: delayed 1116 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Sep 2010 03:18:48 EDT
Date: Mon, 27 Sep 2010 12:59:46 +0600
From: Andrey Rahmatullin <wrar@altlinux.org>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [TuxOnIce-devel] Swsusp patches applied to suspend-2.6#linux-next
Message-ID: <20100927065946.GR7007@wrars-comp.wrarsdomain>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="JKGvNdIvrY8Ovf7Z"
Content-Disposition: inline
In-Reply-To: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
X-Operating-System: ALT Linux Sisyphus
X-Jabber-Id: wrar@altlinux.org
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JKGvNdIvrY8Ovf7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 27, 2010 at 03:43:35PM +1000, Nigel Cunningham wrote:
> Hi again Rafael.
>=20
> As discussed, here are the patches, modified to apply against your current
> linux-next tree. A new first patch splits compression support out into its
> own file, removing the need to have two versions of the load_image and
> save_image routines, minimising the changes to the remainder of the
> patches and making things cleaner than would otherwise be the case.
>=20
> On my laptop, single-threaded compression actually slows writing down from
> 175MB/s to around 100-120MB/s (depending on how well the image compresses=
).
> Reading speed improves from 218MB/s to around 245MB/s. I expect that
> multithreaded writing would bring the writing (and reading) speeds back
> up. It's on my swsusp to do list :)
Can I test this patchset by just building for-rafael branch?

--=20
WBR, wRAR (ALT Linux Team)

--JKGvNdIvrY8Ovf7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJMoEDiAAoJEOih81koZvPBl2sH/21DTU2gd+94cJz9RItfSv8z
PGoMGXWCfOlxzJZCMfrWLSKjHe49jzhSC5F1/pAavYN9NDVjmPQm7IzP9KeFFSZO
tkkc2+yrlUzaTXZLUbzCr6FammsvkKqCBt1cICj1u+PNAQjm+iwRr3sFnt1Ti9go
hVDIDPT6+xvOqQI9NiYmv5d22f8aoJ6wtXf8q9jSrZz3eQskjmxc7a8vQEI/lfZa
etIuLkQ0BBbi3bEb11SPqqlbAJZJJgICiedmLDhERD1v5hXOamakLBtQlRbwCHB7
bS7euD5oza/3/nzDtRJFteeDVabDbAHdtzcoFWPFOslbsLs2ZX+HNJSgDJlVCmc=
=ArQv
-----END PGP SIGNATURE-----

--JKGvNdIvrY8Ovf7Z--
