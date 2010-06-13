Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab0FMDiy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 23:38:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34267 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077Ab0FMDix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 23:38:53 -0400
Date: Sun, 13 Jun 2010 13:38:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-06-11-16-40 uploaded
Message-Id: <20100613133846.41669e3b.sfr@canb.auug.org.au>
In-Reply-To: <20100612101014.8dfd2843.akpm@linux-foundation.org>
References: <201006120008.o5C08gC3027843@imap1.linux-foundation.org>
	<20100613013718.e724d5e0.sfr@canb.auug.org.au>
	<20100612101014.8dfd2843.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__13_Jun_2010_13_38_46_+1000_OSHbYi/=_d3L=gpS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__13_Jun_2010_13_38_46_+1000_OSHbYi/=_d3L=gpS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Sat, 12 Jun 2010 10:10:14 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Sun, 13 Jun 2010 01:37:18 +1000 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
>=20
> > On Fri, 11 Jun 2010 16:40:13 -0700 akpm@linux-foundation.org wrote:
> > >
> > > The mm-of-the-moment snapshot 2010-06-11-16-40 has been uploaded to
> > >=20
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > >=20
> > > and will soon be available at
> > >=20
> > >    git://zen-kernel.org/kernel/mmotm.git
> >=20
> > The version in this git tree stops just before patch
> > scsi-remove-private-bit-macros.patch.  I suspect that is because "git a=
m"
> > doe not like that patch (it has "a/./drivers..." as the file names).
>=20
> git bug.  I fixed the patch.

Yeah, these comments were more reflections on the "import to git"
procedures than on the patches themselves.

> >, no From: line,
>=20
> Well.  What From: line do I put on origin.patch and linux-next.patch??

They were not the problem (for me at least).

> I fixed the others.

Thanks.

> > or do not apply
> > without some fuzz.
>=20
> That's a bit silly.  Oh well, I can try to remember to rediff
> everything before uploading.

Not really necessary, git am is a but anal in that regard (for good
reason usually).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__13_Jun_2010_13_38_46_+1000_OSHbYi/=_d3L=gpS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwUUsYACgkQjjKRsyhoI8ypUQCfexrwH9nWrBHqdXkEGKoGzsuq
bQsAnihRFqNN1i7t2wWOBbZ7gALR48mU
=dYuV
-----END PGP SIGNATURE-----

--Signature=_Sun__13_Jun_2010_13_38_46_+1000_OSHbYi/=_d3L=gpS--
