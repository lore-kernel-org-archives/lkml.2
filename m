Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab2CLQd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 12:33:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:7933 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177Ab2CLQdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 12:33:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="117821227"
Message-ID: <1331570150.12037.55.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/4] jffs2: Convert most D1/D2 macros to jffs2_dbg
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joe Perches <joe@perches.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Mon, 12 Mar 2012 18:35:50 +0200
In-Reply-To: <1331566415.13200.14.camel@joe2Laptop>
References: <cover.1329349881.git.joe@perches.com>
	 <2d68e76db16d42f451370714f03ef952e0839692.1329349881.git.joe@perches.com>
	 <1330965033.7220.16.camel@golum> <1330966615.3140.6.camel@joe2Laptop>
	 <1331294012.29445.10.camel@sauron.fi.intel.com>
	 <1331318968.13055.8.camel@joe2Laptop>
	 <1331557935.12037.11.camel@sauron.fi.intel.com>
	 <1331566415.13200.14.camel@joe2Laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-8jtaBgZgdQ32SZx4/WSz"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8jtaBgZgdQ32SZx4/WSz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-03-12 at 08:33 -0700, Joe Perches wrote:
> On Mon, 2012-03-12 at 15:12 +0200, Artem Bityutskiy wrote:
> > On Fri, 2012-03-09 at 10:49 -0800, Joe Perches wrote:
> > > On Fri, 2012-03-09 at 13:53 +0200, Artem Bityutskiy wrote:
> > > > OK, pushed these ones, although I think that mechanical D1->jffs2_d=
bg()
> > > > conversion is not very useful and to make your patch-set worth the
> > > > trouble you should do few more clean-up steps, like I suggested.
> > >=20
> > > Do you want me to remove the D2/jffs2_dbg(2, ...) instances
> > > or just eliminate the first arg to jffs2_dbg and keep the
> > > current jffs2_dbg(2,...) instances?
> >=20
> > Just remove. There were few other suggestions as well :-)
>=20
> what about all the dbg_<foo> calls like
> dbg_readinode(fmt, ...)?
>=20
> I tentatively converted them to a bitmap
> and a single jffs2_dbg(mask, fmt, ...)
> but perhaps all of these could be deleted
> too.

I think it is better to convert them to jffs2_debug(). And I guess after
the change the "mask" parameter will go away?

--=20
Best Regards,
Artem Bityutskiy

--=-8jtaBgZgdQ32SZx4/WSz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPXiXmAAoJECmIfjd9wqK03P8P/12MzJy8Spem8mg05lCVRJpE
ajmBWozjvewKQqU2a7/l4bZ48W0xjdWe++oVzo/fkkx5RK1lUaYyO+68u0UuqjAQ
hk7+YOOo/vjgVDqzLD7tKCFI4AkX/tv3cDK8f96zUrS0ynpRGkAd+xTEWfVTANbW
4pLqOrlUzrh/i6ZVCNtufovavM5OJKG4aLAxLqz+caREWKIf4XtZsPUkA2AvlLYz
87V2c7FYHDkJzDrvKhXckzxGLAvS5UDquPar4W06gUNvj4VK1Mdm3Z6qqbP1FwHf
itOKOHp4lygko9p7o0y6PFlCg2GvDObEA060t+0LYGz/dc7IzDNVjDnHJJz1e+ke
WY8SDWgQbxY1xewvujpBQ3kAAy7TqI5WHmBoEkkD+1ADKE+sUES+HuFLWDE/1Kzz
dvJb3TRVwkauhOj/MPFqXfyU3vv8frWWmWmIhbgfAqYGU5PyL3Qw8W/YS+9frutQ
e7I87Npy+CZEHAkUXl0aVwZXHS6sNyuWL7xOeFZLoxUmPM3I5Xu4LlU5vKgYqoq7
cMwBLc9FxxMaC4aL+xFvqeT67YXI35KLDATHvDIMcz2veVMx2RuMjkgaRLTM1fqW
8z9MrKK8pIRRpJIM/0owyJI3lQMAkVJLRwo/bjBxlZcdQ41yquga2R5DRu4wqjlO
wBqEkPAur7bpfI02nkXv
=KuJ0
-----END PGP SIGNATURE-----

--=-8jtaBgZgdQ32SZx4/WSz--

