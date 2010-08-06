Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935173Ab0HFBn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 21:43:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45264 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758937Ab0HFBnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 21:43:23 -0400
Date: Fri, 6 Aug 2010 11:43:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Joonyoung Shim'" <jy0922.shim@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
Subject: Re: linux-next: manual merge of the input tree with the s5p tree
Message-Id: <20100806114314.6d15d4fb.sfr@canb.auug.org.au>
In-Reply-To: <004801cb3500$69824bd0$3c86e370$%kim@samsung.com>
References: <20100722114655.1140fb61.sfr@canb.auug.org.au>
	<20100806102419.3e875933.sfr@canb.auug.org.au>
	<004801cb3500$69824bd0$3c86e370$%kim@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__6_Aug_2010_11_43_14_+1000_OrijStOwQgi27aGM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Aug_2010_11_43_14_+1000_OrijStOwQgi27aGM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 06 Aug 2010 09:43:34 +0900 Kukjin Kim <kgene.kim@samsung.com> wrote:
>
> I know that Dmitry's 'Input: samsung-keypad...patch' which includes
> plat/keypad.h has been merged Linus' tree in this merge window.
> And Joonyoung's another patch which is in my tree needs to update it, but=
 my
> tree is don't having it against Linus' 2.6.35.
>=20
> So happened conflict...how can/should I handle this...
> Should I rebase my tree against Linus' latest?

Either rebase (worst), or just merge Linus' tree (better) into yours or
(best) merge what Dmitry merged into Linus' tree.  To do this last, you
need to merge commit d01d0756f75e7a5b4b43764ad45b83c4340f11d6 from Linus'
tree.  Doing this brings in the minimum amount of extra stuff to your
tree, but allows you to sort out the conflict.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__6_Aug_2010_11_43_14_+1000_OrijStOwQgi27aGM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMW2iyAAoJEDMEi1NhKgbsbgsH/2vDPkAJu0oPdEBsjOBmq5Ex
/hGCdQGXOIe/JfGQATNGHVNlUhDFvCq4hq9qGmaQV+MOfMtVVWj/KkLWOYqyWZxy
4d4DtH+yXLkmhUz5D7+dvry0IAq8RS+vu/sV+Mh4fdmuCYqHu9UquOXkwdndE3/n
i5crMv99qvtPl5V6mGqK0DPFHpQo84dtW5EXMiPW0L7pVOwaeLq0+xeuMWS+OXmv
jPel43gfoJkSywtoZEC1bk1OBVsXPnmBAt88CUv1r8Gx9F9SfrybnTeY+74s0cET
7rqA0JQd8RgBBmuVVycpmwcc9IJA+KHzcZKTewqaLPn9yhKgrOV3r/t3P4UelXM=
=3+OQ
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Aug_2010_11_43_14_+1000_OrijStOwQgi27aGM--
