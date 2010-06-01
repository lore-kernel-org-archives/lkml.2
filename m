Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab0FAIW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 04:22:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58858 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028Ab0FAIWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 04:22:25 -0400
Date: Tue, 1 Jun 2010 18:22:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoph Hellwig <hch@infradead.org>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, drbd-dev@linbit.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Julia Lawall <julia@diku.dk>, Al Viro <viro@zeniv.linux.org.uk>,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: linux-next: manual merge of the drbd tree with Linus' tree
Message-Id: <20100601182213.479a777e.sfr@canb.auug.org.au>
In-Reply-To: <20100601081823.GA29991@infradead.org>
References: <20100601141324.edf41f7f.sfr@canb.auug.org.au>
	<20100601081823.GA29991@infradead.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__1_Jun_2010_18_22_13_+1000_4Uiwu0yNAo6fFDnA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Jun_2010_18_22_13_+1000_4Uiwu0yNAo6fFDnA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Replacing Jens' Oracle address ...]

Hi Christoph,

On Tue, 1 Jun 2010 04:18:23 -0400 Christoph Hellwig <hch@infradead.org> wro=
te:
>
> On Tue, Jun 01, 2010 at 02:13:24PM +1000, Stephen Rothwell wrote:
> > Hi all,
> >=20
> > Today's linux-next merge of the drbd tree got a conflict in fs/pipe.c
> > between commit cc967be54710d97c05229b2e5ba2d00df84ddd64 ("fs: Add missi=
ng
> > mutex_unlock") from Linus' tree and commits
> > 0191f8697bbdfefcd36e7b8dc3eeddfe82893e4b ("pipe: F_SETPIPE_SZ should
> > return -EPERM for non-root") and b9598db3401282bb27b4aef77e3eee12015f7f=
29
> > ("pipe: make F_{GET,SET}PIPE_SZ deal with byte sizes") from the drbd tr=
ee.
> >=20
> > I fixed it up (see below) and can carry the fix for a while.
>=20
> Why is the drbd tree touching fs/pipe.c anyway?

It is based on the block tree.  I assume that it is currently based on a
version of the block tree that Jens has not yet pushed into
linux-next.  :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_Jun_2010_18_22_13_+1000_4Uiwu0yNAo6fFDnA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwEwzUACgkQjjKRsyhoI8yR4QCgl/psxaQUgkFBNBPudbrU70K+
uB4AoILTi95f7AZPWIgKskt2yEknj1DT
=q5dZ
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Jun_2010_18_22_13_+1000_4Uiwu0yNAo6fFDnA--
