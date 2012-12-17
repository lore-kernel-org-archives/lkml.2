Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205Ab2LQDOQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 22:14:16 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:47139 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2LQDOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 22:14:15 -0500
Date: Mon, 17 Dec 2012 14:13:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Mason <chris.mason@fusionio.com>
Cc: Chris Mason <clmason@fusionio.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        Josef Bacik <JBacik@fusionio.com>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the btrfs tree
Message-Id: <20121217141355.9bbbd1ef4c59959bf7940a4a@canb.auug.org.au>
In-Reply-To: <20121217025241.GC13828@shiny>
References: <20121217100022.7d751dc9075d60a33d636a23@canb.auug.org.au>
	<20121217001504.GA13828@shiny>
	<20121217025241.GC13828@shiny>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Dec_2012_14_13_55_+1100_mkY5.bBDh7rmVb5o"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Dec_2012_14_13_55_+1100_mkY5.bBDh7rmVb5o
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

On Sun, 16 Dec 2012 21:52:41 -0500 Chris Mason <chris.mason@fusionio.com> w=
rote:
>
> On Sun, Dec 16, 2012 at 05:15:04PM -0700, Chris Mason wrote:
> > On Sun, Dec 16, 2012 at 04:00:22PM -0700, Stephen Rothwell wrote:
> > Josef and I have sob on all of our commits (at least all the ones not in
> > 3.7, I didn't go back farther).  In this case the Author was Stefan and
> > it ended up rebased in either Josef's or my tree.  We usually try to
> > preserve merges on rebase, but this time was a bigger set of changes
> > than usual and it didn't work out.
>=20
> Just FYI, I've pushed out a fixed version of the tree with proper
> signed-off-by on all the commits, thanks for catching that.
>=20
> It also has the fix for the ppc compile problems.  (This isn't a pull
> request yet, I've got the hash collision fix and a few others pending as
> well).

You do realise that I just fetch your tree/branch each day, right?  So it
will be in tomorrow's linux-next.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__17_Dec_2012_14_13_55_+1100_mkY5.bBDh7rmVb5o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQzo3zAAoJEECxmPOUX5FEpMMQAJk/pUQBo8hTTvUYiNi1+Gii
sEi+0jPvhSIT+6YsdLDAUp8FwtWRZYR/Ery8VpOutPPTtG4k29WH9DpU4s+Dz+17
kSkZ4j+lBO9eZMuzb+qhbn4pmmRKu/KJq0kkRlHei/kAfK2Z+eBLDNDvoRfpy1J+
M/WY8KNnVLVRYdoxs184tt9e7se3wkKNwkaaaDRMjorJojoyxelxw9pqAnL8mHdb
6RDoC+GwkozC0ZPYKlJXCdHzq/1Ug/EJpOjYnCRISNSerAxUHwKq3TfGNHZgGHgx
BDn1XMGwMoZGEh/yBxg3Qi03UYRvLmOr1Hpf8Y1bZyAAVhwn36YyATa1MvnPzh0F
N5TYtF1zgIw5mszWZ6dqKPuTDmM1n2upor4f2OYyiFCcGYiAx67lbELaqapYLxJn
zPSC2xVNdo+asT0GE1b8U6zqDmzVeZV8e+aDUWxS/9CXlpSGAfy1SViqnNB1Onw+
tklWKb/oRdjV0uui5GaOn2fEZp5L9x6GbY3NfpEtsx0jaqMtY7jMwf2wkOVtRjWl
/GCwPJXaPramUuYHPVZEGvRIej0qorguyojSnPGU0U74exMQg6rrB57eorjtglsj
OorpuLJF+QOfmMyuFbF/BjrL6ce+3QS5IJ9rMILBngbHSqikXKq00eMUl8DcTl6Z
aOe3PAosjo8c+eOF8i2q
=CXvW
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Dec_2012_14_13_55_+1100_mkY5.bBDh7rmVb5o--
