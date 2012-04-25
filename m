Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab2DYAOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 20:14:16 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56723 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757566Ab2DYAON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 20:14:13 -0400
Date: Wed, 25 Apr 2012 10:14:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 1/3] kernel,sched,time: Clean up gcc work-arounds
Message-Id: <20120425101402.509a00996f5f1c0d0f228569@canb.auug.org.au>
In-Reply-To: <20120424162224.454623618@chello.nl>
References: <20120424161039.293018424@chello.nl>
	<20120424162224.454623618@chello.nl>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__25_Apr_2012_10_14_02_+1000_h4F_m7pEw+GgchLg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__25_Apr_2012_10_14_02_+1000_h4F_m7pEw+GgchLg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Peter,

On Tue, 24 Apr 2012 18:10:40 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> =
wrote:
>
> We've grown various copies of a particular gcc work-around,
> consolidate them into one and add a larger comment.
>=20
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/compiler.h |   12 ++++++++++++
>  include/linux/math64.h   |    4 +---
>  kernel/sched/core.c      |    8 ++------
>  kernel/sched/fair.c      |    8 ++------
>  kernel/time.c            |   11 ++++-------

You should, of course, include linux/compiler.h into those last 4 files ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__25_Apr_2012_10_14_02_+1000_h4F_m7pEw+GgchLg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPl0HKAAoJEECxmPOUX5FE3h8P/2Wak+q5fppvUfz9fWnIyZW7
LrT+Jy6DEYrvtO/W7aNNq/+7Mtk2oM7pZ5Q7RUFfPG1Rd3zmaO/1GHE04UzMBDgy
1Kqj0G5E6ei4vnllTRvFPl72AipqTLRUI7zwf3gyI47UyPP2gGKDXyVGHGh9HlMN
EKw9nS28fh0CPm3ShOAqyRwSbIu4VToSqhjs3Y2AbhSA7tJubWWR4ruiEga2eLFh
XlRD4Sc2xcvKGdU79NLo0zD+WfSfQ8P9a+WDbF2v5QNItm29RhCcC6t7MONiylEx
QbbGfr5+rR2MSCAj6TKPM948MNXZ+9RYSMSQgxtuYrB6WvXs2ojBZm0cTJSLFwaV
D7U6bbg5V8kpyGLHLFdgm+lwiUZQaK1FXwPjoP+NSGrv/cCFO4jMv5vCnM8rcR1m
DWXvLy8UuhObCwdzzARzBXnQGrn1hA/DLoOnMuL1ld40Gu8fx9RM47maNDvfyT0G
Dl4UQ0qoqw5DgDbdOms0AmVF8T1+7JkZln4w6w/dOivC+ImmlI03UomyYfqdnoNW
Sw7onRsIzMrtj5ylx0SRhuKflgG9FZevhaeUa76FRcECCL/QAWH0P+v241m028uF
4EACCSsEFNX0IBwV73nWMsVeVRtLI4R9Rch0qwOmyn3gffYn+9Z6GyUbgBHPPQBO
IGCXuYCOmdoFSAwKmmmq
=Hvyw
-----END PGP SIGNATURE-----

--Signature=_Wed__25_Apr_2012_10_14_02_+1000_h4F_m7pEw+GgchLg--
