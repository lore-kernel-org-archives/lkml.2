Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab2HOU3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:29:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42194 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756518Ab2HOU3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 16:29:01 -0400
Date: Thu, 16 Aug 2012 06:28:32 +1000
From: NeilBrown <neilb@suse.de>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        hramrach@centrum.cz, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        ricwheeler@gmail.com, dhowells@redhat.com, hpj@urpla.net,
        sedat.dilek@googlemail.com, penberg@kernel.org,
        goran.cetusic@gmail.com, romain@orebokech.com, mszeredi@suse.cz
Subject: Re: [PATCH 01/13] vfs: add i_op->open()
Message-ID: <20120816062832.36a48cb0@notabene.brown>
In-Reply-To: <20120815172150.GA25062@fieldses.org>
References: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
	<1345045700-9062-2-git-send-email-miklos@szeredi.hu>
	<20120815172150.GA25062@fieldses.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/z1Be2cKuAwf83O.coF/weKT"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/z1Be2cKuAwf83O.coF/weKT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Aug 2012 13:21:50 -0400 "J. Bruce Fields" <bfields@fieldses.org>
wrote:

> On Wed, Aug 15, 2012 at 05:48:08PM +0200, Miklos Szeredi wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> >=20
> > Add a new inode operation i_op->open().  This is for stacked
>=20
> Shouldn't that "->open()" be "->dentry_open()" ?
>=20
> --b.
>=20
> > filesystems that want to return a struct file from a different
> > filesystem.
> >=20
> > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> > ---
> >  Documentation/filesystems/Locking |    2 ++
> >  Documentation/filesystems/vfs.txt |    7 +++++++
> >  fs/namei.c                        |    9 ++++++---
> >  fs/open.c                         |   23 +++++++++++++++++++++--
> >  include/linux/fs.h                |    2 ++
> >  5 files changed, 38 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/Documentation/filesystems/Locking b/Documentation/filesyst=
ems/Locking
> > index 0f103e3..d222b6a 100644
> > --- a/Documentation/filesystems/Locking
> > +++ b/Documentation/filesystems/Locking
> > @@ -64,6 +64,7 @@ prototypes:
> >  	int (*atomic_open)(struct inode *, struct dentry *,
> >  				struct file *, unsigned open_flag,
> >  				umode_t create_mode, int *opened);
> > +	int (*dentry_open)(struct dentry *, struct file *, const struct cred =
*);
> > =20
> >  locking rules:
> >  	all may block
> > @@ -92,6 +93,7 @@ removexattr:	yes
> >  fiemap:		no
> >  update_time:	no
> >  atomic_open:	yes
> > +open:		no
> > =20

and that last line should be
    +dentry_open:       no
??

NeilBrown

--Sig_/z1Be2cKuAwf83O.coF/weKT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUCwGcDnsnt1WYoG5AQJ6mQ/9G5l2x1b/Kxh97A0a/hqYxy+tXDYn5yLF
pvJrsofEFZPYI/cU1XEwrTZr4AGuqcZOaW8/MYf5arTikbyBHLfl3lqDnzIM5FYm
sXn2Dtoe74Ad+dUVp8B4vr1NNoSCf1fHN0r1mRmaHgH5W/aON1Rct4tznV8KCj9f
hL5MV7O6+Bcy+SJnPyFYcFxGDHq8j3l99C1X8ip6JnzWJpRS/tXVYKSOUCJ7CujN
5iZ9KD3Tzh8BAXZg/FAEfOtqR42RbUqwdU7gueWtyDfeOXxsH/TO0D9aU4PWaKAO
9RqgKm4Nj4TpeKVvPtMWzga8xbmB3IzeYG6OON9oEZfhqYRCAoU9+1ZKImrQ7fcp
gP6nIiDLE+Lz6u3Cc0JZlcr5kG2yvCZzKPbbND0CFkt/pBOG3YMAJDXsidfoeaWG
4T/M5qBqnL56S10QPWpeKpFL8ql76kiW+neP2SrGyzVHNqL4R0Vfnkx3HACeqgY7
2FaBZ+k19XSSRihedYgCY8mzBdea6pj+WltDgP/7qpWi/12MvHoxm5R3bUHy4d0n
JGB+eYky2RKqa1VLCTJSdUQD5HtHEtpSja92S8IWiwSYuWh2BeeKjlnGYpihyMC2
p3LxDRwYFWhkBcmJzQ1jllqDpZWeCB8GPML3wlUy1Myj2SbMSQEVUo8xe2zTfkfx
3BO4wBmowgk=
=Hu33
-----END PGP SIGNATURE-----

--Sig_/z1Be2cKuAwf83O.coF/weKT--
