Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab0ERKVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 06:21:01 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38339 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756134Ab0ERKU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 06:20:59 -0400
Date: Tue, 18 May 2010 20:20:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the block tree
Message-Id: <20100518202044.a91d7f64.sfr@canb.auug.org.au>
In-Reply-To: <20100518085613.GU25951@kernel.dk>
References: <20100518133710.8b1545dd.sfr@canb.auug.org.au>
	<20100518085613.GU25951@kernel.dk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__18_May_2010_20_20_44_+1000_/JcCR4vjdd=uIip0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_May_2010_20_20_44_+1000_/JcCR4vjdd=uIip0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 18 May 2010 10:56:13 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
>
> Thanks, it looks like a merge/commit error on for-next alone, for-2.6.35
> is fine. I'll make sure this gets fixed up now.

So why is for-2.6.35 different from for-next?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__18_May_2010_20_20_44_+1000_/JcCR4vjdd=uIip0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvyafwACgkQjjKRsyhoI8xYVwCgowl3aMBsWALlPBJVI6gfuk7K
Q/AAn2oO2OE1VE5wKqeqV/zqOk1vU5Kg
=vB96
-----END PGP SIGNATURE-----

--Signature=_Tue__18_May_2010_20_20_44_+1000_/JcCR4vjdd=uIip0--
