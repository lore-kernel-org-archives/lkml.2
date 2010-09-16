Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab0IPVbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 17:31:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53712 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601Ab0IPVbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 17:31:35 -0400
Date: Fri, 17 Sep 2010 07:31:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <randy.dunlap@oracle.com>, Will Drewry <wad@chromium.org>
Subject: Re: linux-next: Tree for September 16 (do_mounts.c)
Message-Id: <20100917073126.f382c799.sfr@canb.auug.org.au>
In-Reply-To: <20100916091125.f12cc17c.randy.dunlap@oracle.com>
References: <20100916152805.c9f31656.sfr@canb.auug.org.au>
	<20100916091125.f12cc17c.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__17_Sep_2010_07_31_26_+1000_fcC0XdsVcFSNL=sZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Sep_2010_07_31_26_+1000_fcC0XdsVcFSNL=sZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Sep 2010 09:11:25 -0700 Randy Dunlap <randy.dunlap@oracle.com> w=
rote:
>
> When CONFIG_BLOCK is not enabled:
>=20
> init/do_mounts.c:71: error: implicit declaration of function 'dev_to_part'
> init/do_mounts.c:71: warning: initialization makes pointer from integer w=
ithout a cast
> init/do_mounts.c:73: error: dereferencing pointer to incomplete type
> init/do_mounts.c:76: error: dereferencing pointer to incomplete type
> init/do_mounts.c:76: error: dereferencing pointer to incomplete type
> init/do_mounts.c:102: error: implicit declaration of function 'part_pack_=
uuid'
> init/do_mounts.c:104: error: 'block_class' undeclared (first use in this =
function)

Caused by commit b5af921ec02333e943efb59aca4f56b78fc0e100 ("init: add
support for root devices specified by partition UUID") from the block tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__17_Sep_2010_07_31_26_+1000_fcC0XdsVcFSNL=sZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMkoyuAAoJEDMEi1NhKgbsT/oH/1AZ6gvXzCEluqm1Q+lGUAgO
4TH9cN9oD1WAc0mb4GNnbpHMO7s7ytJqafBdBgyQfHeM87MyuQkKXTLkQjG6HSsp
WGQKwf3wEdwdJgozlcmMvQ+i83PZQP9AIyA+QrEDqae1mnCbmqoqzB3oE9IA9UO6
/B4/AU5DiO4klcdy2XA3Yk+ujCH5YxtdFKJSCV12m+9k2rQszulEgqVjNBxKfeeU
+wu0r/Lmdh+Ld/6w48ATluIvAvpLdtQ8V7xotILAS9/tTvKzp/Jd+mbysAxlS12U
2PHAbN2L4KNh/Rem02pkpjdR3qiDLKdyGowiUnwrBfQrSaB6yonp3vbmhz0eXR0=
=V2Z+
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Sep_2010_07_31_26_+1000_fcC0XdsVcFSNL=sZ--
