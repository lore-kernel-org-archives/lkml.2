Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab2ARJyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:54:15 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:41746 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075Ab2ARJyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:54:13 -0500
Date: Wed, 18 Jan 2012 12:55:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Sasha Levin <levinsasha928@gmail.com>, linux-kernel@vger.kernel.org,
        Neil Brown <neilb@suse.de>, linux-nfs@vger.kernel.org
Subject: Re: [patch] nfsd: oopses in cache_parse()
Message-ID: <20120118095501.GD3356@mwanda>
References: <1321611289-21809-1-git-send-email-levinsasha928@gmail.com>
 <20120116115258.GC3294@mwanda>
 <20120116155031.GC1750@fieldses.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0/kgSOzhNoDC5T3a"
Content-Disposition: inline
In-Reply-To: <20120116155031.GC1750@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4F1696BB.006A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0/kgSOzhNoDC5T3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 16, 2012 at 10:50:31AM -0500, J. Bruce Fields wrote:
> On Mon, Jan 16, 2012 at 02:52:58PM +0300, Dan Carpenter wrote:
> > We fixed expkey_parse() in b2ea70afad "nfsd: Fix oops when parsing a
> > 0 length export" but there are other cache_parse() implimentations
> > which have the same issue.
> >=20
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > Since half of the implimentations get this wrong, maybe we should
> > just check for this in cache_do_downcall().  Is there ever a valid
> > reason to pass a zero length string to cache_parse()?
>=20
> I don't think so, no.  Checking in cache_do_downcall() sounds like a
> good idea.

Yeah.  I checked and none of the cache_parse() implementations do
anything with a zero length string.  Ignore that patch, I'll send
another.

regards,
dan carpenter


--0/kgSOzhNoDC5T3a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPFpb0AAoJEOnZkXI/YHqRcdMP/1FQWIAUKHDmvnqM9xadcEKw
9YK9EXRKDY8vvDYtKKyxeI2lI5Gpqo28N5cQx68CU6dzQ4LcTvjmkmrUHb+M+AMi
bFOHxLgt5gJYyME0EykvcWjMhXN4Hkc9RjZYP5Zcnb/nY9DT3v+coxjBkTg18WD9
HlaZ+OHoEdrLyQVjRWxLwQdrEg7xzpI4ZI3KSIYsegCalWj9AHY9tdV6ZxgAK4/s
UpUMRUHlORzh1zNFnQEBkafql460lknKtPpyLBbnNVz2yjgcBpWaIZVZNWCO8eag
QI0K1Iq7ZWJoIlXOq6hJvy8Vr035KBtYHSVPVluzTcGKSjLHxwjHbPVRU8uuj4sq
tt//8kYoLz/FDmzz9imvlnAEwaO9dLkQmxCZMAjbemZ5yVyD2sCu/qQSYPBXYlGZ
ZH1/5jEjBfWNFHkEWI966S9NVK5XfveUbJ/HKl4RKG/lPDAGpWZ6ercnq6GIx/so
fA2KeqsSWbQzKV0++79yhw8f6HVZpArpUCj1Amze7UdHmjFEvGB7fx0N7Z5XOmoj
Ee46hjVrNVuqgfqnMff9VSrtBOf+Owm3ddl1aSEgMP2OEIIqQ4FfPAsTSwqGK/mg
twny4uQU1YB3iGssj0RHVkHgxt68yVisA72HTeJidv28Ub+wch3MYPANjf6yZE1+
ASB35qcwsG0M0tmOjCET
=o7FE
-----END PGP SIGNATURE-----

--0/kgSOzhNoDC5T3a--
