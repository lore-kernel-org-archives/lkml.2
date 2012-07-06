Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab2GFB3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 21:29:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33392 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab2GFB3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 21:29:37 -0400
Date: Fri, 6 Jul 2012 11:29:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>
Subject: Re: linux-next: manual merge of the signal tree with the
 arm-current tree
Message-Id: <20120706112926.42f2548cb2eebc74c547c847@canb.auug.org.au>
In-Reply-To: <20120705075204.GA12344@flint.arm.linux.org.uk>
References: <20120705173526.bf8772adb18edfc91adddea8@canb.auug.org.au>
	<20120705075204.GA12344@flint.arm.linux.org.uk>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Jul_2012_11_29_26_+1000_ePkjjWFPGrFafbv7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Jul_2012_11_29_26_+1000_ePkjjWFPGrFafbv7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 5 Jul 2012 08:52:04 +0100 Russell King <rmk@arm.linux.org.uk> wrote:
>
> Currently, bugs have been found with the signal handling updates which
> happened during the last merge window.
>=20
> Will has concerns with Al's proposed fixes for the signal handling.
> Unfortunately, Al isn't responding to attempts to discuss this (for
> whatever reason), and as we're now at -rc5, we believe Al's patches are
> now too complex to go into this stage of -rc.
>=20
> We have had to find a way forward on this - which means reverting some
> of the commits that went in during the previous merge window.
>=20
> So, your revert to "fix" this isn't a good idea, because it isn't what
> will be going to Linus this weekend.

OK, so for today, I have reverted these commits from Al's signal tree:

c1eafa6fc84a	"arm: pull all work_pending logics into C function"
9c802c169f96	"arm: deal with handlerless restarts without leaving the kerne=
l"
76c3f4da3ee4	"arm: get rid of TIF_SYSCALL_RESTARTSYS"

(I was not sure if I needed to revert the first of these.)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__6_Jul_2012_11_29_26_+1000_ePkjjWFPGrFafbv7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP9j92AAoJEECxmPOUX5FEFRwQAKXCd4HsakjBr9HhQlIpI6O+
/CQ/LuMULW0ow7MBJKe8IYgRWavCpm+nrC1aFmd8yWwa5cDdWl+2NJpHc6YBfUvT
hjyvYzzD50i7Cx5W3EL1VbqZW2O3syfyhzUCxfu3rs+E+RLgAuEfaqe4Xn06YAce
N6VE1I3hI5xNusV7/JDroXlvG4K7BiHB4P9eDcGLxi2XcSqzRf7qMQ0bRi0pEN1j
46AF3Vwuo9Gvsvn77dEJVYmr3pFIp1SsB71S3R+ayBXJfXzwZCOm4nAvEX3QKJ0f
LEHmN+efMT+nrZ5JhPUjlgBL5wwAmzS26toV1IpurkthmMnBq1fRDgCDs4FCRH6O
nXHOEtCGFkv18AA9OW1xGx1P8GlC5IvsiNPoFLhug8wXUiX2PFV8+0wHntnTSaT/
uIRXtefXrkubdPCgG4MYgRDqzrBXR+BFxPtHhT1XoOEVZUwE8WrWWXoaNhR84g1B
O9+gmR3/0PZWB8rXqH9ki1A7IdRqtz8IDOuLZsITacyj6U0vRlynbPbw/hsrmcIo
9uNSbcYURQNd21Lzuo2gHN9OGiXc+8a+s+2u08iBspWZ+7daVvTTu3tt9RqPZ5iE
vGgOkQIecShg7/G2Zf+gYiDxdnZW89fDaxbDzZIgjwTZSFCv83fFNECPtII+YXZU
Ilj/ulooC+iWVQSh4OJ+
=ovv9
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Jul_2012_11_29_26_+1000_ePkjjWFPGrFafbv7--
