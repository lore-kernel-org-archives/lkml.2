Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab1AGMR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 07:17:59 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43599 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583Ab1AGMR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 07:17:57 -0500
Date: Fri, 7 Jan 2011 23:17:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: sedat.dilek@gmail.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Sedat Dilek <sedat.dilek@googlemail.com>, Jens Axboe <axboe@kernel.dk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the block tree
Message-Id: <20110107231748.76170ff3.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTinyaZfsYv43046LWgu8U3kg6_79y+PTFO1RxtnY@mail.gmail.com>
References: <20110107110513.30776114.sfr@canb.auug.org.au>
	<4D26C179.7030704@kernel.dk>
	<AANLkTinyaZfsYv43046LWgu8U3kg6_79y+PTFO1RxtnY@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__7_Jan_2011_23_17_48_+1100_XXYeebMryn8lA0g_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Jan_2011_23_17_48_+1100_XXYeebMryn8lA0g_
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi All,

On Fri, 7 Jan 2011 11:52:08 +0100 Sedat Dilek <sedat.dilek@googlemail.com> =
wrote:
>
> JFYI:
> I pulled in patches from linux-2.6-block#for-next (up to commit
> 6573422f81efa3bd71848dc584c35d4318d3de0b):
> "Merge branch 'for-2.6.38/core' into for-next"
> ...into linux-next (next-20110107) and now I get:
>=20
> $ grep block build_linux-next_next20110107.dileks.2.log
> 30886 blocks
>   CC      fs/block_dev.o
>   CC      mm/memblock.o
>   CC      kernel/power/block_io.o
> /home/sd/src/linux-2.6/linux-2.6.37/debian/build/source_i386_none/kernel/=
trace/blktrace.c:999:2:
> warning: passing argument 1 of =E2=80=98register_trace_block_bio_complete=
=E2=80=99
> from incompatible pointer type
> /home/sd/src/linux-2.6/linux-2.6.37/debian/build/source_i386_none/include=
/trace/events/block.h:240:1:
> note: expected =E2=80=98void (*)(void *, struct request_queue *, struct b=
io *,
> int)=E2=80=99 but argument is of type =E2=80=98void (*)(void *, struct re=
quest_queue
> *, struct bio *)=E2=80=99
> /home/sd/src/linux-2.6/linux-2.6.37/debian/build/source_i386_none/kernel/=
trace/blktrace.c:1038:2:
> warning: passing argument 1 of =E2=80=98unregister_trace_block_bio_comple=
te=E2=80=99
> from incompatible pointer type
> /home/sd/src/linux-2.6/linux-2.6.37/debian/build/source_i386_none/include=
/trace/events/block.h:240:1:
> note: expected =E2=80=98void (*)(void *, struct request_queue *, struct b=
io *,
> int)=E2=80=99 but argument is of type =E2=80=98void (*)(void *, struct re=
quest_queue
> *, struct bio *)=E2=80=99

I reported that separately today and Mathieu Desnoyers (cc'd) has said
that he will supply a patch.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__7_Jan_2011_23_17_48_+1100_XXYeebMryn8lA0g_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNJwRsAAoJEDMEi1NhKgbsc8sIAJbLVWhsTX6lp8f454UYSNtP
F1DdLIxS9809frj/erhre2OT6ci4+WLioNp7mNC2WKjOH/zkZVq5cvV1CA7yNd+M
iGaW44tIwU9Ef4tpEcAKTUKflasHLRh/hFGtObcvbLCLQJ1Cei/7819zTlXTgLd8
R20HUqSPTXCWR/4qnPeoYweJj7I4Rs2sEC1RMNz3SgfhUmLBciQVHAOPZj0Y6zCv
R3l5E9N3UM+UZnHazxM4arTUuN3+3EIG9zKXxIQa5LizlJUmQLLpgfKWPYu+8mir
WgzT/C1q8u4R5YGZpGWGRyCGu/kIP48Oc09faJdgCillE+swlg9hdbGpXGHAqMs=
=mqw7
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Jan_2011_23_17_48_+1100_XXYeebMryn8lA0g_--
