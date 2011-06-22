Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab1FVDQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 23:16:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35969 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757714Ab1FVDQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 23:16:11 -0400
Date: Wed, 22 Jun 2011 13:16:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: comedi doesn't build on several architectures
Message-Id: <20110622131600.cd05d33a.sfr@canb.auug.org.au>
In-Reply-To: <20110621.194925.1313933193955144936.davem@davemloft.net>
References: <20110621.194925.1313933193955144936.davem@davemloft.net>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__22_Jun_2011_13_16_00_+1000_q2Fuk.y4+kyRcewI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__22_Jun_2011_13_16_00_+1000_q2Fuk.y4+kyRcewI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Tue, 21 Jun 2011 19:49:25 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> It depends upon PAGE_KERNEL_NOCACHE which only a handful of
> platforms define.
>=20
> Really, enabling staging in Linus's tree with all this build fallout
> was not the wisest.  It's blowing up all of my allmodconfig test
> builds now.
>=20
> Stick it to -next first next time.

It was (briefly :-() and I complained about build breakages.  There are
still some (as you have seen).  And lots of new warnings (which I am
ignoring mostly because there are so many warnings anyway).

See msgid <20110609172745.dfd3a298.sfr@canb.auug.org.au> on lkml from Jun 9.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__22_Jun_2011_13_16_00_+1000_q2Fuk.y4+kyRcewI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOAV5wAAoJEDMEi1NhKgbsX+gH/Rv5XOX6dw+iudy0RbZm87O1
gpI3rV0H9vcTgKzUtL2LOt/WmZOxgLTKBfZAjJY5y4ZHQ6v2/SzZxr2yFjj2JVFS
foM2ysv/iI+tMeEbpHnQmtap+wboajuUCJ+cNVPObyd59X+PvZsdMAd995gXu4YV
QAlnofRLOnXTazOxiRJbmq2q0YvhcbGJL7AJfVuS+DvpB8M8rldaSVvB5aPAKzt5
ohjRYrvofzh8WffY7TliIjACcEc/f31CQZngAA6frTrzkgHQhBbvLjD4qI0845hB
jTeQpA0Y6MN9C1Mp1q3p8RWeBjP2x3ri66E4RZgK1H9IGM78UOE0Pq4djGZfblU=
=jANZ
-----END PGP SIGNATURE-----

--Signature=_Wed__22_Jun_2011_13_16_00_+1000_q2Fuk.y4+kyRcewI--
