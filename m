Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342Ab0HJElK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 00:41:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60717 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab0HJElG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 00:41:06 -0400
Date: Tue, 10 Aug 2010 14:40:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs series, part 1
Message-Id: <20100810144056.64298160.sfr@canb.auug.org.au>
In-Reply-To: <20100810142434.8ae6912a.sfr@canb.auug.org.au>
References: <20100810033536.GA31363@ZenIV.linux.org.uk>
	<20100810142434.8ae6912a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__10_Aug_2010_14_40_56_+1000_y3eq1/mjlKes.dyV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Aug_2010_14_40_56_+1000_y3eq1/mjlKes.dyV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

On Tue, 10 Aug 2010 14:24:34 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Tue, 10 Aug 2010 04:35:36 +0100 Al Viro <viro@ZenIV.linux.org.uk> wrot=
e:
> >
> > 	Assorted work from the last cycle; among other things, there's
> > a filesystem API change (->evict_inode() series), a lot of truncate
> > rework stuff (mostly by Chris) and a bunch of fixes.
>=20
> Did you remember to apply the three fix patches I sent you?  Two were for
> evict_inode fixups (cifs and xfs) and one was inode_setattr removal fixup
> (for v9fs).

Having just fetched your for-next branch, they appear to have been rolled
in.  Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__10_Aug_2010_14_40_56_+1000_y3eq1/mjlKes.dyV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMYNhYAAoJEDMEi1NhKgbsT80H/iW4tdTlYCfctE+nraJ/jMU3
Yv1uof/DDQ+FrGpZ+QIPi8hTUlcWtSEBurNc5G/286NFpc94LnFaQKcifCZ6R4+x
sE+cVI3q+aBZXQgYpj3Y8QSL0vUoYn3M2UjTyYaz4BcdN7ZytFNN6I+2xGAVLR8+
ay8nJfnGAR1v2PFZ8YWifIvYbiY+LoTZ6Jn8Q/S3fareX7CH9bFB/uYaT4zLfsF3
C1ralB5bdLPktP7ziW3G5lhutG02EFqyUmhE9L+pC1JPe0DpCjpVdWDKXN/EcTKX
S1TiXAkUtSV5Xo9WeaTnhLX+GzGlD/SzcwuF8e/vCHFDqzU3IChjLdFZ2pcUmis=
=A7Yk
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Aug_2010_14_40_56_+1000_y3eq1/mjlKes.dyV--
