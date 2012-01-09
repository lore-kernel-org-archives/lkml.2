Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab2AICW5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 21:22:57 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:46719 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab2AICW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 21:22:56 -0500
Date: Mon, 9 Jan 2012 13:22:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: Re: linux-next: manual merge of the vfs tree with Linus' tree
Message-Id: <20120109132246.d1b8bb0dc4c16b04d9a326ea@canb.auug.org.au>
In-Reply-To: <CA+55aFyYR=66K721tVF3NgLg-MyFsVuy6kewJJBXaS1GVd+wXQ@mail.gmail.com>
References: <20120109121133.76f5b7c4a4780954c4562244@canb.auug.org.au>
	<CA+55aFyYR=66K721tVF3NgLg-MyFsVuy6kewJJBXaS1GVd+wXQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__9_Jan_2012_13_22_46_+1100_E=JgbY9BS2aG.l8+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Jan_2012_13_22_46_+1100_E=JgbY9BS2aG.l8+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 8 Jan 2012 17:32:14 -0800 Linus Torvalds <torvalds@linux-foundation=
.org> wrote:
>
> On Sun, Jan 8, 2012 at 5:11 PM, Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
> >
> > Then again ... it looks like the vfs tree has other changes to the btrfs
> > code so that I need the version from the vfs tree, not Linus' tree ...
>=20
> The btrfs changes (at lest most of them) will come through the btrfs
> tree, that's one of the reasons the vfs tree got re-built, afaik.

That's fine, but maybe we should consider getting the btrfs tree into
linux-next ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__9_Jan_2012_13_22_46_+1100_E=JgbY9BS2aG.l8+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPCk92AAoJEECxmPOUX5FEh7oQAKaC9DAY617n5u57Yez0VFmb
HAxnX6i/iw8JAx3Z9PbcsASV7DIlR8N1jsiyMnq5voClAa36e3jl13M3PnRyydIN
UI65OIY64kOz5OEMIbfrhLKaEcfEAXTuWu/3zgvsfpDSqHKmrNGmqfxLiYp3FJa/
iAqU0AQ6rhB8BnoClSBMnc1wEO91Fgz3pd4m5BqWD1YYW87IyUZxs9c8uhIp0IOF
dMghlSyphLxm/ndnkGoOqwZEzVgYUDzLoPvZXZZowZORqUfJZTlscxBQ4e4fWid5
I8/vnzJO3fEez4ovUozd8T7RByMZKGUe8sUw5C/De0L2KX2N8PsZdNikTOTsJetz
HmVh9a6clrDdhymsS1xyIAJjNmUFkq9bJ+2oGgKS3gaS35a9Lj8tOLFEbPzhHjjZ
bG8L+DCf6jPCkvc/U43wkxo9i/xjr/n/qhcig1eSPfpDlYw6dVUG6qziaryd4vqY
FfReEPi21MS2Ry0Ac2TH9K11X4ENskH13UnHBu1JiPtkgHj8lzL/CtvZatcb9qGy
nc7SO555cS934GDx3IVJjRy4Ow2HXnklDHNa1cBAN0mZBlh5PQu2LflPMUOGMzTJ
qreo38ZOGsKH5KKzeLi8sV8a4Yx/YBBXpwfYpVrplR/LMSTT7LbFPCmnP7EfzTt1
OaEDcR1XzlzEzBFgNkTR
=iP1T
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Jan_2012_13_22_46_+1100_E=JgbY9BS2aG.l8+--
