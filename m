Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680Ab0FUXko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 19:40:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49323 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758317Ab0FUXkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 19:40:43 -0400
Date: Tue, 22 Jun 2010 09:40:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: paulmck@linux.vnet.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: Re: linux-next: manual merge of the tip tree with the block tree
Message-Id: <20100622094033.3becf09f.sfr@canb.auug.org.au>
In-Reply-To: <20100621171300.GF2354@linux.vnet.ibm.com>
References: <20100621161623.3dfedc32.sfr@canb.auug.org.au>
	<20100621171300.GF2354@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__22_Jun_2010_09_40_33_+1000_2nr4XOlf0l=dYd9L"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Jun_2010_09_40_33_+1000_2nr4XOlf0l=dYd9L
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Mon, 21 Jun 2010 10:13:00 -0700 "Paul E. McKenney" <paulmck@linux.vnet.i=
bm.com> wrote:
>
> I took a look, and all of the changes from "fs: remove all rcu head
> initializations, except on_stack initializations" are reflected in -next.

Thanks for checking.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__22_Jun_2010_09_40_33_+1000_2nr4XOlf0l=dYd9L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwf+HEACgkQjjKRsyhoI8z2kQCdFvU/21v7WjLBaBgqTPLENwP6
asUAoKpF+eLp4v5xIlRL66cba/RT9gWj
=gFkL
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Jun_2010_09_40_33_+1000_2nr4XOlf0l=dYd9L--
