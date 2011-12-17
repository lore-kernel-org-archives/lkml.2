Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab1LQE1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 23:27:41 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:42862 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1LQE1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 23:27:35 -0500
Date: Sat, 17 Dec 2011 15:27:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: linux-next: build failure after merge of the final tree
Message-Id: <20111217152729.38099acb10e3514b389a5d0d@canb.auug.org.au>
In-Reply-To: <20111217152253.1aedda0936cd5d1d98be5e76@canb.auug.org.au>
References: <20111217152253.1aedda0936cd5d1d98be5e76@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__17_Dec_2011_15_27_29_+1100_Be/LydVoavsvbLNu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__17_Dec_2011_15_27_29_+1100_Be/LydVoavsvbLNu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, 17 Dec 2011 15:22:53 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the final tree, today's linux-next build (sh
> edosk7705_defconfig and lots of other sh configs) failed like this:
>=20
> mm/pgtable-generic.c: In function 'pmdp_clear_flush_young':
> mm/pgtable-generic.c:76: error: call to '__build_bug_failed' declared wit=
h attribute error: BUILD_BUG failed
>=20
> This is the
>=20
> 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
>=20
> in pmdp_clear_flush_young().
>=20
> Exposed by commit 835cea45a4a0 ("hugetlb: replace BUG() with BUILD_BUG()
> for dummy definitions") from the akpm tree but I don't know the root
> cause.
>=20
> This may have a fix somewhere (if it is sh specific) but the current sh
> tree in linux-next
> (git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6.git) does
> not exist.

We are getting the same for all the cris config builds.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__17_Dec_2011_15_27_29_+1100_Be/LydVoavsvbLNu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO7BoxAAoJEECxmPOUX5FEG9YP/RasaKyJxZsNC+XztVswT0uW
h9UuGOzEcRnySoo1/9JegBqgJHXB0JecpJVmVdhIVaLRtvM+eCbzwFpiQz+8xN8d
vBv5xZnh6zi1k3d03w6+rHUE1Aks4aUtKu6pU6eFB4tG/ciq4suXl3TWtPLkpoFM
uhJmOtmZ3naM+MHLGw+1giFdcpleZMrh6cxu/d8dSEpGHhdVH4rhtSnMkJPv0Ez0
62tpR09VsF+qsVahj/pOOz7ax7GxdhRbGNhr/JOAv3P/tgHuYrM2UY8oiUXL4+aX
VlvvP0OK1D+lvGb/8bxCKcVGU08cR0IOrTjsTmBVFiOnMdQNRA6l9KTEcJfV7+yy
okt9VzFiZalMpPh7MPDeJ0wW+UrKdAtuLVi/98HgbBDvRs30tiotNOlDYiT3Iuft
5NBkp07EcnXgmFhR47AjySQcOFu6YtEO/JYwEUTxS20KXNQVRf0Jw7Z4WHloujvZ
VmejUbnyBmYrIfKPLKOQnWzejZqmln9zj6OgKLTmLTacoIEMzXeycFaNHBNBz/Oh
Ej7Yt3yP3AEP6n9FuE8msU7Sjw5BjR1lv7lsRxXYlLuDypRXBaxb2MW5jOeiI7wv
rGbS0QStgWUfay+vCgSA/cALeRFO3hsC7KS9KcUIeKcpwrQHLD9ctT49611wmw8p
ECWHK5yGYlHmGiAF5C/i
=6ri5
-----END PGP SIGNATURE-----

--Signature=_Sat__17_Dec_2011_15_27_29_+1100_Be/LydVoavsvbLNu--
