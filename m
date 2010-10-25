Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab0JYCji (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 22:39:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42720 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479Ab0JYCjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 22:39:37 -0400
Date: Mon, 25 Oct 2010 13:39:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Miller <mike.miller@hp.com>, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: linux-next: build warning in Linus' tree
Message-Id: <20101025133930.9da8afa0.sfr@canb.auug.org.au>
In-Reply-To: <20101025114520.fb19b192.sfr@canb.auug.org.au>
References: <20101025113858.feeff8a7.sfr@canb.auug.org.au>
	<20101025114520.fb19b192.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__25_Oct_2010_13_39_30_+1100_OPBOKFIcxZ.u9sps"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Oct_2010_13_39_30_+1100_OPBOKFIcxZ.u9sps
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Oct 2010 11:45:20 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Mon, 25 Oct 2010 11:38:58 +1100 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > After merging the hid tree, today's linux-next build (x86_64 allmodconf=
ig)
>   ^^^^^^^^^^^^^^^^^^^^^^^^^^
> Ignore this :-)

It been pointed out that I may have not bee clear enough.  My statement
above was meant to mean:

"Ignore the bit about merging the hid tree, but the report is otherwise
valid"
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__25_Oct_2010_13_39_30_+1100_OPBOKFIcxZ.u9sps
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMxO3iAAoJEDMEi1NhKgbsEzsIAInXCrnMt5pqybFHhOfkCXrV
tBoIDBvEpSfLocEFEsv+dYj6SmyOa9KNO7BvexJzg6rbx0aMuPHixWof9mC08iYJ
ZOLDAxUDoG5+n2InIHhY6uExn1gxfyJkdbKBAyyPeOrKIArQ6kAoIKtOdXtVkZHu
5GLgR4Y8XQmWkT2jmyWkFHMJxVVCDEAUeHfEJXZqdZddJEkv/kAEXzmdaHfU8GxG
LQ1qWMz/rtYAW1/V6dw6lKE1pWgbQAeafPG4NqBP0SlpjiIZB9mc4QQZLer2luVH
W5uVWKnCiy1kXfxQPT0dLAs2is0vAKahzHx3eTYTtIDieYLdFSasppqqYbfLt7I=
=hvMn
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Oct_2010_13_39_30_+1100_OPBOKFIcxZ.u9sps--
