Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab0LMDlC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 22:41:02 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45663 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756674Ab0LMDlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 22:41:00 -0500
Date: Mon, 13 Dec 2010 14:40:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: rcu-walk and dcache scaling tree update and status
Message-Id: <20101213144049.fa3b14d9.sfr@canb.auug.org.au>
In-Reply-To: <20101213023733.GB6522@amd>
References: <20101213023733.GB6522@amd>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__13_Dec_2010_14_40_49_+1100_i4JWXefpJLeiXtG6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Dec_2010_14_40_49_+1100_i4JWXefpJLeiXtG6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nick,

On Mon, 13 Dec 2010 13:37:33 +1100 Nick Piggin <npiggin@kernel.dk> wrote:
>
> Linus has suggested pretty strongly that he wants to pull this in the
> next merge window (recently, that "inodes will be RCU freed in 2.6.38"
> in an urelated discussion). As far as I know, that's what he's going to
> do. I'd like to get this some time in linux-next to improve test
> coverage (many filesystems I can't even test, so there are bound to be a
> few silly crashes). Stephen, how do I arrange that?

Well, you ask me :-) (letting me know where the git tree is).

I this case I would like an email from Al and/or Linus (and/or maybe
Christoph?) before I add this to linux-next as you say below that
(despite being as well tested as you can do) it does require more review
and buyin from others.  Of course, if Linus is going to merge this during
the next merge window, then it really should be in linux-next as soon as
it is ready enough.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__13_Dec_2010_14_40_49_+1100_i4JWXefpJLeiXtG6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNBZXBAAoJEDMEi1NhKgbsS9MH/1z8ya9Hsw9CzbggsLr/P/d8
x9+Vwzfm412QHXJ6/DF/Z0eQ4kq/HEMcrYmWgmTf6XNFcf8y7Egaw+y4MMHPgtMK
EvvoNzWQYybMccVbJzy1icU521osgUpB2SKuwEEpJ0O/9c1zd62KEHaViPks2L7t
6yz5pKTx0rE1YI+CUTOhP3apY9UsEFi1RvtjQ7P3yb4mHMTiUV6BngzWBweZymyf
Bd+OSKBykyxXKh6/qSJE8HxfQAX4PnG447RlOFiOITYdbRGaAWmUyWiRyj6BogtZ
JwSCCsh3VdoZF2PundOvOiHucjLIMTSkEaIiR+OtC8cGzC2vo6J1scbKA8SxiIU=
=/AqV
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Dec_2010_14_40_49_+1100_i4JWXefpJLeiXtG6--
