Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab1CHQXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 11:23:46 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39697 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507Ab1CHQXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 11:23:43 -0500
Date: Wed, 9 Mar 2011 03:23:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: Joe Perches <joe@perches.com>, linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, users@kernel.org
Subject: Re: RFC: Removing old tags, reducing the git size of -next.
Message-Id: <20110309032332.da40748b.sfr@canb.auug.org.au>
In-Reply-To: <4D764B59.1060801@suse.cz>
References: <1299039746.4208.28.camel@Joe-Laptop>
	<20110302165447.f47fd4b2.sfr@canb.auug.org.au>
	<4D764B59.1060801@suse.cz>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__9_Mar_2011_03_23_32_+1100_ED16z_5jfT5l0SEZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_Mar_2011_03_23_32_+1100_ED16z_5jfT5l0SEZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

On Tue, 08 Mar 2011 16:29:29 +0100 Michal Marek <mmarek@suse.cz> wrote:
>
> FWIW, I use the following setup for linux-next:
>=20
> [remote "linux-next"]
>         url =3D
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git

This should now be
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
(its the same repository, just a more generic name).

>         fetch =3D +refs/heads/master:refs/heads/linux-next
>         fetch =3D +refs/heads/stable:refs/remotes/linux-next/stable
>         tagopt =3D --no-tags
>=20
> and fetch the next-* tags manually only when I need them.

That should all continue to work.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__9_Mar_2011_03_23_32_+1100_ED16z_5jfT5l0SEZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEbBAEBAgAGBQJNdlgEAAoJEDMEi1NhKgbsbkAH9REL9UBpRgM7CYC/62HfzxHn
0Yx1BZX7Z1EO87vwrOPYSnO5PAxD6rOxtP2UpLjHFKD4JZiRDIlYt5dwATvz8XxF
N1nPhyCLnaA4XOoGEyr4qVLdaXloZIzHbyic1TIQdYl2NW7lSWWzhFsBV8eAlWPz
/k7ZRlbmNssYeEIIjZ80bQh2sfcfoVLJXfmkBY2a9caNS7XyvUZ03VerW4CXhxp1
6YwNFPxHfAQts7teapMSnBS2p3o4jGMpUUzhLMkByPbO+U5WVj8kJB5ByjeIqsaG
qBuZZTQNnYssi6HZhMuBoR/XYW8E1jIlzj9E/Vya7pRO9JtB0tpAIovKb/Xeaw==
=jLVJ
-----END PGP SIGNATURE-----

--Signature=_Wed__9_Mar_2011_03_23_32_+1100_ED16z_5jfT5l0SEZ--
