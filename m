Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab2E2IRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 04:17:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:15612 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943Ab2E2IRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 04:17:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="172194845"
Message-ID: <1338279578.2536.0.camel@sauron.fi.intel.com>
Subject: Re: linux-next: manual merge of the l2-mtd tree with Linus' tree
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        David Woodhouse <dwmw2@infradead.org>
Date: Tue, 29 May 2012 11:19:38 +0300
In-Reply-To: <20120529124501.38995df01dfaebcbd5f1b869@canb.auug.org.au>
References: <20120529123301.b3f33396549e0762f26fa80b@canb.auug.org.au>
	 <20120529124501.38995df01dfaebcbd5f1b869@canb.auug.org.au>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-fk5jMN3B5beK6ajRTUil"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fk5jMN3B5beK6ajRTUil
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-05-29 at 12:45 +1000, Stephen Rothwell wrote:
> Hi Artem,
>=20
> On Tue, 29 May 2012 12:33:01 +1000 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > This tree (l2-mtd) needs to be updated since most of its patches (but n=
ot
> > commits) have been merged into upstream trees.  Artem, you and Dave
> > Woodhouse need to discuss your work flow.  (Or I just need to remove th=
e
> > l2-mtd tree from linux-next.)
>=20
> I fact, I screwed up the various merge resolutions that the above mess
> caused, so I just dropped the l2-mtd tree for today.  Please fix it up.

Yeah, I should have rebased it yesterday against dwmw2's tree. I've just
done this and this should fix the issue. Thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-fk5jMN3B5beK6ajRTUil
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPxIaaAAoJECmIfjd9wqK0Sz4P/2iJz6nes63cjqjKiaMG59Jv
AnvBQArgh7iaZmEZas8TWJXVnS/C3vGUbBdnYCr1EuWeQeG6nBWCrYtXhMEr4v51
/VHWfkMCENGKpETqI/4tB29qM9XRXlJOJXynQxTmlnScELKT2F/AnsXq17u+0LPF
Z33LK1eSlDBx0MVPfvk1dBnpEVwaLWL28Yy4en6Z22nIsS+iTPoxoA8wXKZdK1v1
grqIobDdzSccXkA/xEMyF9HfAfRqqR0OXE5iIyYWRpnR01ZpaFncJYgW7XfbYQ0R
sJ2nGw7zkas1vRu0JAYlXZtk0/fOv4Po2YK8kvyVpagJySFMEaUFjKs1s5nI4emk
MjPd5qV3Oyc+2qu5bCiwPsiXAYIppz0ylXpXpDpoKgnD/Od9CIdnR7BnIZpP2gLf
4SpwHY4FgiXdV5ZwphYk+rAwUarQG31K5sQoXB6DxmE21w5ZRCwPJ8YC922IE38l
8Yc5d5pwBfCohATOmjmIgdw07VbWJ89/+++axzmyZ6+p4oHw4vrUDvCW3isH7QIz
mwX4Q2/F1sylg1h03PraIDO4IRlMoU2LhWkeiIT4wUt4+UpMTotP+xF8yDUP+hkJ
bwPtOr4eyNVT6m0eBFhn39tE/rjhJyBZ0v6ZW/xXBicRJnxHU031+Nz1RGV80zpT
655F27qCa/ttZlbFn9UR
=3o8n
-----END PGP SIGNATURE-----

--=-fk5jMN3B5beK6ajRTUil--

