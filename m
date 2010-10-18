Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab0JRExB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 00:53:01 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33163 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767Ab0JREw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 00:52:59 -0400
Date: Mon, 18 Oct 2010 15:52:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the xen tree with the swiotlb-xen tree
Message-Id: <20101018155249.d9267bfe.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__18_Oct_2010_15_52_49_+1100_OFumicP2HvSJO2Sw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Oct_2010_15_52_49_+1100_OFumicP2HvSJO2Sw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the xen tree got conplex conflicts in
drivers/xen/events.c between several commits from the swiotlb-xen tree
and several commits from the xen tree.

I am unqualified to fix this mess, sorry.  I am dropping the xen tree
for today (and only not dropping the swiotlb-xen tree because that would
be too much work).

I wonder, of course, why I have seen nothing in either of these trees
until today (less than a week before the merge window opens).

Please sort this mess out.  I will drop the swiotlb-xen tree as well
tomorrow if nothing has changed.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__18_Oct_2010_15_52_49_+1100_OFumicP2HvSJO2Sw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMu9KhAAoJEDMEi1NhKgbsAUAH/0FBRyzgC5zzt2HbrDAuPCQw
BapDaGdeW8JrOKlI+EZJDgdkEAb2shDuQg5R4Bqr+vSDinbsNUilhdMC7aMceEpz
YwyjbSsRkcrpHK49wggKwKFhL/spz29VOc6BwWfg6CDjXiMtxG3xlAgSxiGcc3AV
mKEf0hglqxpXkCbWBbVjO2zWPI4Nbk1lMf+3zGLYFFEjx8/Gi1bWATOobqXoO0We
x4AFnzH0Oc9vrrrf/6uZOA2bJPkCXEbpQYhp0jLqKGWkj9lr0lYWFgygb0t6JUQK
gLUvbOEhikF23lRHKDXJWmIH4ia/Zw+oIZLajbun00wt58artT5chmgZGbmi4IU=
=T2d1
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Oct_2010_15_52_49_+1100_OFumicP2HvSJO2Sw--
