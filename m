Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697Ab2JYD3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 23:29:05 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60928 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab2JYD3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 23:29:03 -0400
Date: Thu, 25 Oct 2012 14:28:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: linux-next: build warnings after merge of the akpm tree
Message-Id: <20121025142854.1924363d6a607004f918ac63@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__25_Oct_2012_14_28_54_+1100_l2B7eGeF9zMOF8Gd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__25_Oct_2012_14_28_54_+1100_l2B7eGeF9zMOF8Gd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc64_defconfig) produced these warnings:

drivers/infiniband/hw/cxgb3/cxio_resource.c: In function '__cxio_init_resou=
rce_fifo':
drivers/infiniband/hw/cxgb3/cxio_resource.c:62:3: warning: comparison of di=
stinct pointer types lacks a cast [enabled by default]
drivers/infiniband/hw/cxgb3/cxio_resource.c:74:4: warning: comparison of di=
stinct pointer types lacks a cast [enabled by default]
drivers/infiniband/hw/cxgb3/cxio_resource.c:81:4: warning: comparison of di=
stinct pointer types lacks a cast [enabled by default]
drivers/infiniband/hw/cxgb3/cxio_resource.c:86:4: warning: comparison of di=
stinct pointer types lacks a cast [enabled by default]
drivers/infiniband/hw/cxgb3/cxio_resource.c:89:7: warning: comparison of di=
stinct pointer types lacks a cast [enabled by default]
drivers/infiniband/hw/cxgb3/cxio_resource.c: In function 'cxio_init_qpid_fi=
fo':
drivers/infiniband/hw/cxgb3/cxio_resource.c:123:4: warning: comparison of d=
istinct pointer types lacks a cast [enabled by default]
drivers/infiniband/hw/cxgb3/cxio_resource.c: In function 'cxio_hal_get_reso=
urce':
drivers/infiniband/hw/cxgb3/cxio_resource.c:184:6: warning: comparison of d=
istinct pointer types lacks a cast [enabled by default]
drivers/infiniband/hw/cxgb3/cxio_resource.c: In function 'cxio_hal_put_reso=
urce':
drivers/infiniband/hw/cxgb3/cxio_resource.c:193:2: warning: comparison of d=
istinct pointer types lacks a cast [enabled by default]
drivers/infiniband/hw/cxgb3/cxio_resource.c:193:2: warning: comparison of d=
istinct pointer types lacks a cast [enabled by default]
drivers/infiniband/hw/cxgb3/cxio_resource.c:193:2: warning: comparison of d=
istinct pointer types lacks a cast [enabled by default]

Probably introduced by commit "include/linux/kfifo.h: replace open-coded
type check code with typecheck()".
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__25_Oct_2012_14_28_54_+1100_l2B7eGeF9zMOF8Gd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQiLH2AAoJEECxmPOUX5FEoWUP/12EGD411XBVfvv+xJ8sHCj8
AHS1PYKkMW2HG0Wywaz2a4ppNypOn4j2PsKxwRnFlwropRzL2IxYJcdcuX/vGV2z
pg7jNulj/vAnXtFY7GVvTse0q6M+Y8qtkULo1RSSqvSioaV4iUANgdLC0oZvAc+T
rXEG2pNAfKt3zHY7qYtCkvP6MeOEHfNfErxhyWR6DqpQXNFpyWWb5TF0jOqhEh5U
nUvKgpPkmr6HUzyqHqnRsnR7vpGsEY6QCjLTmik8U7cexGhjr7VR+Xa/kCDgz+ii
q3VTc0KysGFI88edRPjYZIeEVGeVqIpUJ5DkhULDDONybm22AbZKlmvscbCoqRvy
NzxgTMuX0L4jy5I0m7GCOgwzHB93avhD0EVuoY3xKrjIj6LnYRIwL4wlOMTU4M23
t4AegJ0SwzitGJlCDvGcudPyrv/jKgCuIgzDXZHqET0eU9hyGixBVy84sb7NBPuk
O96ADNUqmrgi6ZJoVsHsHwlaBD+komFVmHAaMwmbjXHAU+nmdX4K75yr4p8XqK+q
jcw6ENYhdpg0xFZJmrQmuiwJazhQb/zhOPyjEI7AuM46Qv0xeuA7fRjOiD8kOxMg
EiG9OJtIiqgk+h5M9IILb368q4UL6XYuMRXTBLASnuMB46KyFQaomx/2X8xNXQXN
ctqw/w+KtbmeaPhBhHef
=LYa5
-----END PGP SIGNATURE-----

--Signature=_Thu__25_Oct_2012_14_28_54_+1100_l2B7eGeF9zMOF8Gd--
