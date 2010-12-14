Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab0LNADk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 19:03:40 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:56557 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab0LNADi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 19:03:38 -0500
Date: Tue, 14 Dec 2010 11:03:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: rcu-walk and dcache scaling tree update and status
Message-Id: <20101214110326.10604c33.sfr@canb.auug.org.au>
In-Reply-To: <20101213034854.GA8018@amd>
References: <20101213023733.GB6522@amd>
	<20101213144049.fa3b14d9.sfr@canb.auug.org.au>
	<20101213034854.GA8018@amd>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__14_Dec_2010_11_03_26_+1100_Mf/mOYZNUmT9MOY+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Dec_2010_11_03_26_+1100_Mf/mOYZNUmT9MOY+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nick,

On Mon, 13 Dec 2010 14:48:54 +1100 Nick Piggin <npiggin@kernel.dk> wrote:
>
> Yes I would like an ack from Al to have it in linux-next. Note that
> wouldn't have to be an ack on the patches or agreement to merge it next
> window, just an "ok to get wider review and testing" type of thing.
>=20
> If Linus's is intending *not* to pull it, then it's not so urgent, and I
> might instead ask Andrew to host it in -mm for a while. I just don't
> want to get caught with my pants down here, because there are a good
> number of untested filesystems and things.

OK, since Linus seems so keen (and you fixed the reported compile error)
I will include your tree today.  If Al has objections, I can always
remove it again.

I have called the tree (for my purposes) "vfs_scale" and have just you
listed as the contact.

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

--Signature=_Tue__14_Dec_2010_11_03_26_+1100_Mf/mOYZNUmT9MOY+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNBrROAAoJEDMEi1NhKgbsDMEIAIBjqSXcRy6EkSfHCIQ4qfiY
8nvSP3pNaI/ko0E9akKeC+j1YASTYEMuNjd/RmNiONTYd+VSaG7YnxFZOu0opIgZ
//v36t6Z4VYPTOaGGxYCBD+CNXy00zvD5fyLD8UyKOZ0lytBVwgReAYkmriyMX2/
G8k9yTxm/JwCfGyz2nsqCpee2XjCYxaHvb0TrSg11CwZ8PZWPhzfN3ozqFO3CYMp
EWSYJoj/h50dpXVeA1daKtBF+/sFtsQfWpF2kMCZyCRDCbb/EG+VP8BYPQoODBJa
e8P3xbhIQqEhAlfiJfALBy+pYVhxKQIBuhP7F/dnSHLNOtUBCSNm3LHNxr4d9Bk=
=606w
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Dec_2010_11_03_26_+1100_Mf/mOYZNUmT9MOY+--
