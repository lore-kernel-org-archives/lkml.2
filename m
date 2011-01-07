Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab1AGBtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 20:49:49 -0500
Received: from mail.openrapids.net ([64.15.138.104]:39228 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754975Ab1AGBts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 20:49:48 -0500
Date: Thu, 6 Jan 2011 20:49:45 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <axboe@kernel.dk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: linux-next: build warnings after merge of the block tree
Message-ID: <20110107014945.GA5109@Krystal>
References: <20110107110229.c586455a.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <20110107110229.c586455a.sfr@canb.auug.org.au>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 20:48:30 up 44 days,  6:51,  6 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Stephen Rothwell (sfr@canb.auug.org.au) wrote:
> Hi Jens,
>=20
> After merging the block tree, today's linux-next build (powerpc
> ppc64_defconfig) produced these warnings:

Sorry about this, I will issue a patch that updates the blktrace code
according to the new callback prototype expected right away.

Thanks,

Mathieu

>=20
> kernel/trace/blktrace.c: In function 'blk_register_tracepoints':
> kernel/trace/blktrace.c:999: warning: passing argument 1 of 'register_tra=
ce_block_bio_complete' from incompatible pointer type
> include/trace/events/block.h:240: note: expected 'void (*)(void *, struct=
 request_queue *, struct bio *, int)' but argument is of type 'void (*)(voi=
d *, struct request_queue *, struct bio *)'
> kernel/trace/blktrace.c: In function 'blk_unregister_tracepoints':
> kernel/trace/blktrace.c:1038: warning: passing argument 1 of 'unregister_=
trace_block_bio_complete' from incompatible pointer type
> include/trace/events/block.h:240: note: expected 'void (*)(void *, struct=
 request_queue *, struct bio *, int)' but argument is of type 'void (*)(voi=
d *, struct request_queue *, struct bio *)'
>=20
> Probably caused by commit de983a7bfcb7c020901ca6e2314cf55a4207ab5a
> ("block: trace event block fix unassigned field").
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/



--=20
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFNJnE5PyWo/juummgRAr9AAKCWeOJ9AKGyJfWjuMh9auUGboH4WgCeKYbB
HxlbKTJ8HBFuYTyKKQD52lo=
=+7ep
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
