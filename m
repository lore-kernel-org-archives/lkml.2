Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab2GWGto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 02:49:44 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36152 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab2GWGtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 02:49:42 -0400
Date: Mon, 23 Jul 2012 16:49:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [git pull] vfs.git; pile 1
Message-Id: <20120723164937.83f822896e5ba92bb83c7436@canb.auug.org.au>
In-Reply-To: <20120723060909.GE31729@ZenIV.linux.org.uk>
References: <20120722100920.GZ31729@ZenIV.linux.org.uk>
	<CA+55aFzG9gzWRLvZMb6RnKua0=RHxBFisYSCVDNhjHBq7oq2yw@mail.gmail.com>
	<20120722202030.GB31729@ZenIV.linux.org.uk>
	<20120723060909.GE31729@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Jul_2012_16_49_37_+1000_Dvz9sFwx3oR2uTv2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Jul_2012_16_49_37_+1000_Dvz9sFwx3oR2uTv2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

On Mon, 23 Jul 2012 07:09:09 +0100 Al Viro <viro@ZenIV.linux.org.uk> wrote:
>
> On Sun, Jul 22, 2012 at 09:20:30PM +0100, Al Viro wrote:
> > Result: for-linus-2 + v3.5 and for-linus + v3.5 give identical trees,
> > and for-linus-2 merges clean with nfs/nfs-for-3.6.  Would you be OK
> > with pulling that one?  Again, my apologies to everyone involved ;-/
> >=20
> > If you are OK with pulling that one, the summary is unchanged, location=
 is
> > git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus-2
>=20
> BTW, Stephen, could you confirm that vfs.git#for-linus-2 has no conflicts
> with the rest of trees in linux-next?  I've checked the lack of conflicts
> with nfs.git and you haven't mentioned any other conflicts, so I hope
> that this will do, but I haven't tried pulling and merging the rest of
> the stuff in -next; not with the link I'm behind right now... ;-/

I found not other conlicts with the vfs tree today.  Not that some
conflicts are necessarily a problem.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__23_Jul_2012_16_49_37_+1000_Dvz9sFwx3oR2uTv2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQDPQBAAoJEECxmPOUX5FEFugP/0ce05ZNKxZxRARLyyIAZ/Jz
F8Wx8/UgXTZGE8l0ojo52q94bAfaeBjSE1WZJbnjHtXmvVgmAj2JaABQ53ulu69t
xS7+Ybcm/s4DsJr5b+HpVAh8YiVYRIrplhtCUMT9dReNVRqjOwtj94OZkckuScPe
zcwg5fFL5UJ9Ra8e42TSbt4Yu4hshcg6nF0bBLtmGvweDNjw3mV49MWs24Gn+q9S
UZ+lSb9ushzateu0cE+MKBJDJOVY50V+W/4K8689VYxbDWh89rumHDicGurR1Vb0
Go56FIIxXff3/+nnOWe4zAyj7yE+zJElccOnqLpvSawfTU1BsQJXIQVeuN26bfgw
NBiJQo1UseZGTrqrNhMuZtayMwXDt9kPUFe/TcnWk8NX35jaDd0syz3zyAbcgPQe
0mI9FViNvlZgQs56eWg1H9CQJuwJp1TXRdGY/3p3QCtnv6q4wvgjoNwtAbytyyvQ
f57gffiF41c3hjiK3b3C4LBgcA/Veoghw5mxA25hz2QwEO+vouoTdxzDuo7aae0D
KqS4VSCjAIn9NdEMT4NM3k7tyqg6LRbiCG2d1T6rsW9I8GGbN7m2bgH7o1jxD1Wk
MhfvPdOJTxTIn0JXKxmSUtrc+MtwCOkKAlXXL7ZRUAoQrHa5qzRlIF1ED/maYcIs
/+klDaRpAJtUjANnj/i8
=cZ0u
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Jul_2012_16_49_37_+1000_Dvz9sFwx3oR2uTv2--
