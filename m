Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab0HBQ2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:28:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56321 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865Ab0HBQ2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:28:52 -0400
Date: Tue, 3 Aug 2010 02:28:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>, Russell King <rmk@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: build failure after merge of the final tree (tip
 tree related)
Message-Id: <20100803022845.890e6caa.sfr@canb.auug.org.au>
In-Reply-To: <20100803022310.bec3ba79.sfr@canb.auug.org.au>
References: <20100803022310.bec3ba79.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__3_Aug_2010_02_28_45_+1000_M6sttCO4pDDbt6bb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__3_Aug_2010_02_28_45_+1000_M6sttCO4pDDbt6bb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 3 Aug 2010 02:23:10 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Caused by commit 53e16bfaf19346f59b3502e207aa66c61332075c ("memblock:
> Introduce for_each_memblock() and new accessors, and use it") interacting
> with commit 2778f62056ada442414392d7ccd41188bb631619 ("ARM: initial LMB
> trial") and some others from the arm tree.

That same memblock commit broke the sh builds like this:

c1: warnings being treated as errors
arch/sh/mm/init.c: In function 'bootmem_init_one_node':
arch/sh/mm/init.c:227: error: unused variable 'i'
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__3_Aug_2010_02_28_45_+1000_M6sttCO4pDDbt6bb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMVvI9AAoJEDMEi1NhKgbsDYkH/35MAzoE2FkVa5hM7jzckBh4
6ULsZARR0Yumtbycgrl27Gbyg6/a4yDlQQmfwBbX/owHM20WQgaLDre1ByobA3dA
ggH++Xp3RzsqT3P0aM4c4kuCRenvDqqwGb57am3jTs2tYOCl2qWZS5kfKOABqBIE
PYnijhi0clGer/yZ5QPRQPJ6dmybPuWtl7r97FQ4VjXYCEHiiUIpMArHSoU+WCCY
QaHS8+nc/2Bf1tls4pNoImE3h8qb+AsICVU70cIBJchzm7AbW0xXt5UET8OWGB6u
bIlF3p5BrR2NK+aYLuNFwFrXZ4T55duOV7EwUvPV+4K6CY2JDh3SMztyjkSgzZQ=
=/s59
-----END PGP SIGNATURE-----

--Signature=_Tue__3_Aug_2010_02_28_45_+1000_M6sttCO4pDDbt6bb--
