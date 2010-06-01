Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab0FAKtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 06:49:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58368 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408Ab0FAKtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 06:49:49 -0400
Date: Tue, 1 Jun 2010 20:49:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Philipp Reisner <philipp.reisner@linbit.com>, drbd-dev@linbit.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Julia Lawall <julia@diku.dk>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: manual merge of the drbd tree with Linus' tree
Message-Id: <20100601204942.134965e5.sfr@canb.auug.org.au>
In-Reply-To: <20100601104515.GM3564@kernel.dk>
References: <20100601141324.edf41f7f.sfr@canb.auug.org.au>
	<20100601081823.GA29991@infradead.org>
	<20100601182213.479a777e.sfr@canb.auug.org.au>
	<20100601104515.GM3564@kernel.dk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__1_Jun_2010_20_49_42_+1000_tei0oTqVGLudjGs+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Jun_2010_20_49_42_+1000_tei0oTqVGLudjGs+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI Jens,

On Tue, 1 Jun 2010 12:45:15 +0200 Jens Axboe <jaxboe@fusionio.com> wrote:
>
> So the pipe patches were the same, the problem was that a fix for a
> missing pipe_unlock() had gone into mainline and for-linus/for-next
> weren't synced up to that. I'm guessing you pull drbd before for-next
> and that is why it showed up there.

Actually, I merge the drbd tree after the block tree and this fell to the
drbd tree only because your for-next branch had not been updated (and I
don't merge your for-linus branch).

> BTW, I would recommend moving for-next from the block tree up before any
> potential other trees being based off it if that is the case.

That is already true.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_Jun_2010_20_49_42_+1000_tei0oTqVGLudjGs+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwE5cYACgkQjjKRsyhoI8wujACffVSwL97RMoEoVSh/+RFVnGnf
n1IAn1AaJi1NtBHimLC5NNYJKpqHsbdj
=FODO
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Jun_2010_20_49_42_+1000_tei0oTqVGLudjGs+--
