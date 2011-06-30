Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab1F3Ej3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 00:39:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41643 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab1F3EjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 00:39:22 -0400
Date: Thu, 30 Jun 2011 14:39:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        git@vger.kernel.org, Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: manual merge of the security-testing tree with the
 tree
Message-Id: <20110630143915.0b0fdf0f.sfr@canb.auug.org.au>
In-Reply-To: <20110630143334.90c9d1bc.sfr@canb.auug.org.au>
References: <20110630142910.2fea4257.sfr@canb.auug.org.au>
	<20110630143334.90c9d1bc.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__30_Jun_2011_14_39_15_+1000_Quq0ZEo9=pQ8V1k="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__30_Jun_2011_14_39_15_+1000_Quq0ZEo9=pQ8V1k=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 30 Jun 2011 14:33:34 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Thu, 30 Jun 2011 14:29:10 +1000 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > More information for the git experts:
> >=20
>=20
> $ git version
> git version 1.7.5.4
>=20
> I am running Debian unstable.

Today's linux-next is based on v3.0-rc5-76-gc017d0d (Linus' tree commit
c017d0d135 ("Merge branch 'kvm-updates/3.0' of
git://git.kernel.org/pub/scm/virt/kvm/kvm").

The point at which I tried to merge the security-testing tree is
v3.0-rc5-3666-g9fd8fab.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__30_Jun_2011_14_39_15_+1000_Quq0ZEo9=pQ8V1k=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOC/3zAAoJEDMEi1NhKgbsv5IH/RPgvlQTz1o1rAXDW8VDGmVa
U8yHxXgo2tn+JFLGTzPlI5/742Z7JcJ/ScRYamlVBHZXV7VGj/6Wsp8lZbOnGRpg
J6CN35lx3ewgDPyz73abblfyHhPGzg9xh42RDnIW9wnaLL+ZHXpyw/k/DVzP1KMw
5/NQpnTQTeYL/9lBboNBMgMXcOSR/gYEtp/XmMvWxctHSLWrJUJ3Fs2GRuiRu0yy
SW5NwxB3Q7LmVZpVjV0l7ch9JB3ITvQFKC7Ii7XqTA1S5XKp4FnhatDoEn98Ethb
SXsBHX6XNYr+dtbr/ZoyROT6CFrCIAM+LRCcbKcPARyrEck1saAyxGoiH8TFw+Y=
=+9tx
-----END PGP SIGNATURE-----

--Signature=_Thu__30_Jun_2011_14_39_15_+1000_Quq0ZEo9=pQ8V1k=--
