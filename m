Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab0GZE2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 00:28:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50428 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173Ab0GZE2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 00:28:50 -0400
Date: Mon, 26 Jul 2010 14:28:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-masters@oss.sgi.com, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: linux-next: build failure after merge of the xfs tree
Message-Id: <20100726142846.83265620.sfr@canb.auug.org.au>
In-Reply-To: <20100726035442.GD7362@dastard>
References: <20100726115107.3c3b7303.sfr@canb.auug.org.au>
	<20100726035442.GD7362@dastard>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__26_Jul_2010_14_28_46_+1000_+5+y1_XP6FifZnpy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Jul_2010_14_28_46_+1000_+5+y1_XP6FifZnpy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Mon, 26 Jul 2010 13:54:42 +1000 Dave Chinner <david@fromorbit.com> wrote:
>
> Can you check the following patch fixes the problem?

That patch fixes the compilation problem for me.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__26_Jul_2010_14_28_46_+1000_+5+y1_XP6FifZnpy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMTQ7+AAoJEDMEi1NhKgbselwH/330zkChEXKCvgfAAi5QlSAH
OuUw7iCidYTKVaeKvC35fPr8NU7kaCrUEa5dJGRWUICrsNb6yGjmq3k4dIjy6Lfc
iq3ypM55mIV5uHviT0vRcVMiddFtwAlR6K3s59pbIALyGzRsoALy5ABWaozArLpL
j/P2/pOPvlO6Xeveuyb3EDy8HJqpTsN6ZUDtpqn6RFVVcngzmSaXeh1crK3rfCDt
AL+Oqjn5+UojLXc2aIVezOkh0eUSnkHq7LrdVDsUoB3O0rA7Ozx2lUmRzmd/WBg4
ExFGudR1NDaml5nHUwm/KbUUBjg5egbcRFZktNlSfPG0dMIXlFUwNdeZ2QLpOxw=
=2FOr
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Jul_2010_14_28_46_+1000_+5+y1_XP6FifZnpy--
