Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab0HPCnJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 22:43:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37483 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928Ab0HPCnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 22:43:06 -0400
Date: Mon, 16 Aug 2010 12:43:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, sedat.dilek@gmail.com,
        Andi Kleen <ak@linux.intel.com>, len.brown@intel.com,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull request] ACPI patches for 2.6.36.merge
Message-Id: <20100816124300.e72258c9.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTinBAgk_Ay4vCcTxTEsq-uwn=RwQpTA6O86JXGCM@mail.gmail.com>
References: <AANLkTikV2eVo6KM5dSqfDwAwT=bVxnuWSpBE7F+JQU+_@mail.gmail.com>
	<AANLkTi=vngT_5XYz1=3P6GjExFNtCVCdBMhaz4Sc4oEk@mail.gmail.com>
	<20100815133015.883c7069.akpm@linux-foundation.org>
	<AANLkTi=Ok3NH3k5EF1Da2Z3xA7uahABRtH7pEdOEuZH2@mail.gmail.com>
	<20100815182153.994179c1.akpm@linux-foundation.org>
	<AANLkTinBAgk_Ay4vCcTxTEsq-uwn=RwQpTA6O86JXGCM@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__16_Aug_2010_12_43_00_+1000_P0iKKu9weEjU4+8E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Aug_2010_12_43_00_+1000_P0iKKu9weEjU4+8E
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 15 Aug 2010 18:35:22 -0700 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> It's that simple. It clearly never ever saw -next, because it _cannot_
> have seen next. That particular commit can never have compiled.

Yeah, it turned up in Len's tree that I fetch over the weekend.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__16_Aug_2010_12_43_00_+1000_P0iKKu9weEjU4+8E
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMaKW0AAoJEDMEi1NhKgbspAYH/ixCgkYI1G1CgASPQ3vb6DdC
85OLIAuaCDlJmncf6+mr4I6fdo8Z+9g4QPL8MzE5NRSHAlYZgWUiOk1ZcPqIEX7q
WMYnnkdnTGTqbBO2m0CUqQKHvsZ2atDFT0YRqBLizf2Minz94UU0watdPLPjZdUR
ihycQ22rVB+NsCmOR3Ab8rqe2OKEaofS3w6v8YvlFgkSDoOcW1irAiz5P/FFeodZ
dtMnpwWlEMqtG6n6r128TFA+zRUue59snzTSy4IIoxZWEjqBzgFHzHjZn6Jjp9RT
eAVZrkUx8NP+B5YeT7Fc2aMLJzaq1b0NnXe55zFFb1nrz3+j+FUBvOwFhyfVH9w=
=Yac+
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Aug_2010_12_43_00_+1000_P0iKKu9weEjU4+8E--
