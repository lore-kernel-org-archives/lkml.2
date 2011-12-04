Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab1LDXJn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 18:09:43 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:33552 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab1LDXJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 18:09:42 -0500
Date: Mon, 5 Dec 2011 10:09:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Cong Wang <amwang@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Please add my tree to linux-next
Message-Id: <20111205100930.1bedc458a5e78b85c563465d@canb.auug.org.au>
In-Reply-To: <4ED8529E.5070608@redhat.com>
References: <4ED8529E.5070608@redhat.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__5_Dec_2011_10_09_30_+1100_iMzhljuTxY.RTSod"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_Dec_2011_10_09_30_+1100_iMzhljuTxY.RTSod
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 02 Dec 2011 12:22:54 +0800 Cong Wang <amwang@redhat.com> wrote:
>
> As Andrew Morton suggested, please add my tree which contains all
> of my patches for kmap_atomic() [1] to linux-next. Some of the
> individual patches already got ACK from subsystem maintainers.
> The tree is hosted on github:
>=20
>      git://github.com/congwang/linux.git #kmap_atomic

I have added this tree to linux-next today.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Mon__5_Dec_2011_10_09_30_+1100_iMzhljuTxY.RTSod
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO2/2qAAoJEECxmPOUX5FE3CkQAI7+qhXFubBAltrOyfNzwi3x
zjhgcQJXO2eHqGLxpSeToM3rrslZxre+Ue5TUy2uRxpOeE/cayWETFD2jB/UJ4e+
ZUP49ZolaHsWrBey0uGkx+n6ByKGABoHv3zrGMgRpuhaaG4LuFuZaUmTxaxITm2T
jCCkpxmdMJ7P4LEB5mpEfLsBCFaaGBNBVsG+vq/+NcU5Z15BRyhxgkWJq+/+bzC2
aAhsQ1+2pkqqvPdWVBzLQ/X6MFf7vxo6HU+gbGj+CijKaB0WdmuuR0lMmPVLYFSz
jrt0ewUIn4AmFnoUmu5XMQcbYVX8nBu4b4Uzn10B4nFsnA5ptjDbcqb2+qHvjMtg
L5XLBkn4KUUYT5CLvnEjyZb2zjgHBOaEkwj4nZJfShe84Lcpjn0j9YqVHhDqC8fu
8MW6mtmIxZ5ruzCF1DODRLQ8oPVsPw4oqkFlu801WY3Isy9ogD8JLf9lhx1eFkOg
dtb8fuwUmivENINhK+zlOxnx8iONp6L241cqd0Qq2txaQj3M7+n6iDhH02GbN9wT
0ka39YTHm2b9u8HTJYQWPbdvtlCG2geR8AXSYH8nALn3M8WkpWev51+gd4SETiCd
G8QmTtTh9JwefktdgLF9T7M2uiESfUfRM01ssq8pEJbBNmzKyZoCAoJ5in7ZMhpf
hKyRnd7iyVH/4z/AgyuI
=5+vd
-----END PGP SIGNATURE-----

--Signature=_Mon__5_Dec_2011_10_09_30_+1100_iMzhljuTxY.RTSod--
