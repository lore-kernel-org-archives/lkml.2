Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022Ab0FVAGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 20:06:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35153 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932639Ab0FVAEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 20:04:31 -0400
Date: Tue, 22 Jun 2010 10:04:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: paulmck@linux.vnet.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: Re: linux-next: manual merge of the tip tree with the block tree
Message-Id: <20100622100423.205ae0a4.sfr@canb.auug.org.au>
In-Reply-To: <20100622094033.3becf09f.sfr@canb.auug.org.au>
References: <20100621161623.3dfedc32.sfr@canb.auug.org.au>
	<20100621171300.GF2354@linux.vnet.ibm.com>
	<20100622094033.3becf09f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__22_Jun_2010_10_04_23_+1000_Ls+tAlT6V1s.=xij"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Jun_2010_10_04_23_+1000_Ls+tAlT6V1s.=xij
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Tue, 22 Jun 2010 09:40:33 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Mon, 21 Jun 2010 10:13:00 -0700 "Paul E. McKenney" <paulmck@linux.vnet=
.ibm.com> wrote:
> >
> > I took a look, and all of the changes from "fs: remove all rcu head
> > initializations, except on_stack initializations" are reflected in -nex=
t.
>=20
> Thanks for checking.

Is there some way that this commit can be merged via the block tree?  Or
does later work in your tree depend on it?  There is considerable and
ongoing work in the block tree on the same areas as your commit changes.
Even today, this conflict is going to be much worse.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__22_Jun_2010_10_04_23_+1000_Ls+tAlT6V1s.=xij
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwf/gcACgkQjjKRsyhoI8zAHACfaAznmtNoAPX9VM7QzLjJJABW
tdsAn2c+Fe2HTX2dLwFTTWjeV8mpjKyf
=pD+W
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Jun_2010_10_04_23_+1000_Ls+tAlT6V1s.=xij--
