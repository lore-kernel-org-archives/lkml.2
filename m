Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab0JROtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:49:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34059 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755304Ab0JROtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:49:49 -0400
Date: Tue, 19 Oct 2010 01:49:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: manual merge of the xen tree with the swiotlb-xen
 tree
Message-Id: <20101019014941.adf9d20f.sfr@canb.auug.org.au>
In-Reply-To: <20101018135512.GA19999@dumpdata.com>
References: <20101018155249.d9267bfe.sfr@canb.auug.org.au>
	<4CBC014D.7070302@goop.org>
	<20101018135512.GA19999@dumpdata.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__19_Oct_2010_01_49_41_+1100_PtjQIO+DA_Rj9n+U"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Oct_2010_01_49_41_+1100_PtjQIO+DA_Rj9n+U
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

On Mon, 18 Oct 2010 09:55:12 -0400 Konrad Rzeszutek Wilk <konrad.wilk@oracl=
e.com> wrote:
>
> Since I seem to have a knack for making mistakes, let me get some clarifi=
cation
> so that I won't do it again.
>=20
> When is it Ok for me to put in the #linux-next, new stable features (so
> reviewed, acked, etc)? a) Is it post rc7? b) Or is it when Linus releases
> the kernel and Linus's merge window opens?

Stuff destined for 2.6.n should be enter linux-next (after being posted,
reviewed and tested) between 2.6.(n-1)-rc1 and about 2 weeks before 2.6.
(n-1) (usually -rc6 or 7).  That way, hopefully we will have most
integration problems sorted out before Linus releases 2.6.(n-1) and the
code can go into Linus' tree during the merge window.  We can then sort
out any bugs etc in Linus's tree during the -rc releases for 2.6.n (at
the same time putting features for 2.6.(n+1) into linux-next.

So the answer is c) pre -rc7 :-)

i.e. all the new features for 2.6.37 should have been in linux-next at
least a week ago ...

In an idea world, the week before the merge window should be spent
settling stuff down ready to go into Linus' tree.  In the real world,
everyone seems to madly shove their new features into linux-next, rebase
their trees against some recent version of Linus' tree or do merges with
his tree (sometimes all three).  A lot of this latter is completely
unnecessary and just means that all the previous testing is thrown away
with the introduction of more code from Linus' tree.

Have a look at the graphs at http://neuling.org/linux-next-size.html .
In the last week, we have had ~930 new commits enter linux-next (that is
over 12% of the total in linux-next).  Since -rc7 came out, that number
is 1580 commits (over 20%). So instead of flattening off (and
stabilising) as we approach the merge window, the rate of change tends to
accelerate ...

/me gets off his soap box :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__19_Oct_2010_01_49_41_+1100_PtjQIO+DA_Rj9n+U
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMvF6FAAoJEDMEi1NhKgbslEoH/Rq6qeXQNABb7nIc0bR4SG31
8j1fRNMPo2REpwwX+35sivPi77RhbJwKLV2UBEbUchO3knfG2Ww8w5rrPxRGkl69
7a3M+M/w2zWlbqODwHX6dPNsMqkLse2KgQEzGGPx7NQbeZwDL3nDuAM8pE+55snG
NCNsLP8JHOCXjH7jE2LawEdRDPoBJV08LSwje38W+eMjUanARw8YCtSU3HnjpKRu
ql2RhArcZs8ip3VQxnBXcBz1oVmqMFgd5MyPiDbTzqID3KLZyxHNqUsrQDfPZsIE
epzd84A40tRj5Ktuach/WYtKGBnXhgvbmXdDqBSmcTLfm/YFMCE55sTsjBQtJ2A=
=qg4w
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Oct_2010_01_49_41_+1100_PtjQIO+DA_Rj9n+U--
