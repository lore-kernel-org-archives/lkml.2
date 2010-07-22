Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab0GVIkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 04:40:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44287 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab0GVIkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 04:40:09 -0400
Date: Thu, 22 Jul 2010 18:40:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: divya <dipraksh@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        David Airlie <airlied@linux.ie>
Subject: Re: build failure with kernel 2.6.35-rc5-git6/git7 on power box
Message-Id: <20100722184001.a0333496.sfr@canb.auug.org.au>
In-Reply-To: <4C47F861.8080501@linux.vnet.ibm.com>
References: <4C47F861.8080501@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__22_Jul_2010_18_40_01_+1000_+RCjRm2yMI7vqnNP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Jul_2010_18_40_01_+1000_+RCjRm2yMI7vqnNP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 22 Jul 2010 13:20:57 +0530 divya <dipraksh@linux.vnet.ibm.com> wrot=
e:
>
> The kernel versions 2.6.35-rc5-git6(commitid f4b23cc2d5dc78ef) and 2.6.35=
-rc5-git7(commitid cd5b8f8755a89a5) fails
> to build on power6 and power5 machines with the following error
>=20
>=20
>    drivers/gpu/drm/ttm/ttm_page_alloc.c: In function 'set_pages_array_wb':
>    drivers/gpu/drm/ttm/ttm_page_alloc.c:227: error: implicit declaration =
of function 'unmap_page_from_agp'
>    drivers/gpu/drm/ttm/ttm_page_alloc.c: In function 'set_pages_array_wc':
>    drivers/gpu/drm/ttm/ttm_page_alloc.c:238: error: implicit declaration =
of function 'map_page_into_agp'
>    drivers/gpu/drm/ttm/ttm_page_alloc.c: In function 'ttm_pool_mm_shrink_=
init':
>    drivers/gpu/drm/ttm/ttm_page_alloc.c:419: warning: assignment from inc=
ompatible pointer type
>    make[4]: *** [drivers/gpu/drm/ttm/ttm_page_alloc.o] Error 1
>    make[3]: *** [drivers/gpu/drm/ttm] Error 2

See https://patchwork.kernel.org/patch/113504/
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__22_Jul_2010_18_40_01_+1000_+RCjRm2yMI7vqnNP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMSAPhAAoJEDMEi1NhKgbsn00H/0qENZuxDKUiGsPmRyi2mWgt
f46jERuDla909rE1wlGCexh2wEgzVmrr4trs+bGh+tEKSmJzW4KcHcF3xsUtQ7VL
ABLmiN+0RtGb83KID64jV1sto8BOT7BFaQDQCzuL4Uqmzy6GVu2Ln21TxPEddUDU
12+6th6RoPjmM5kkXRazhzhHXel3nWh+2R5VV4HLQdBebCIyccXSVsJwQ3r1T2rK
+jr0ayBuHV8hoJbwkjTg3XYKbBh24zKFATXuQiejVuji9iPYv2IdnIlooM8bCxDq
HbApjeYra5JPZbxPOnAixMjxcC6Nz9b5KJrZqv7cN9ryYguJw5rJaq7Rc+1SEQA=
=vL5t
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Jul_2010_18_40_01_+1000_+RCjRm2yMI7vqnNP--
