Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab0ELGvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 02:51:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40556 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab0ELGvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 02:51:36 -0400
Date: Wed, 12 May 2010 16:51:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, kaber@trash.net,
       andreas.meissner@sphairon.com
Subject: Re: linux-next: build failure after merge of the net tree
Message-Id: <20100512165130.f808f3d1.sfr@canb.auug.org.au>
In-Reply-To: <20100511.231339.22535803.davem@davemloft.net>
References: <20100512125653.38f442c5.sfr@canb.auug.org.au>
	<20100511.231339.22535803.davem@davemloft.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__12_May_2010_16_51_30_+1000_coEJ9PXMt2d0oT7R"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_May_2010_16_51_30_+1000_coEJ9PXMt2d0oT7R
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Tue, 11 May 2010 23:13:39 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> Tricky merge :-)

Yeah, I got it right the second time :-)

> I'll clear all of these issues up for you tonight Stephen, thanks!

Thanks.

> There should have been a merge conflict in
> Documentation/feature-removal-schedule.txt due to some recent
> netfilter commits too, I'll take care of that too of course :)

Yeah, but I have stopped reporting those when they are just clashes
between people adding new entries at the end.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__12_May_2010_16_51_30_+1000_coEJ9PXMt2d0oT7R
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvqT/IACgkQjjKRsyhoI8zWTgCgk88/Y4c//Moi9u67xWJO+u9l
tK8AoL0p2WQKHc1HXQ5cnVDIo0ZS7lHU
=0WTZ
-----END PGP SIGNATURE-----

--Signature=_Wed__12_May_2010_16_51_30_+1000_coEJ9PXMt2d0oT7R--
