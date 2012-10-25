Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038Ab2JYDas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 23:30:48 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46407 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab2JYDaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 23:30:46 -0400
Date: Thu, 25 Oct 2012 14:30:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: Re: linux-next: build warnings after merge of the akpm tree
Message-Id: <20121025143044.d21e2c29b16ee2005f93a371@canb.auug.org.au>
In-Reply-To: <20121025142854.1924363d6a607004f918ac63@canb.auug.org.au>
References: <20121025142854.1924363d6a607004f918ac63@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__25_Oct_2012_14_30_44_+1100_2K_CMV4dHD8ivxaB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__25_Oct_2012_14_30_44_+1100_2K_CMV4dHD8ivxaB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 25 Oct 2012 14:28:54 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the akpm tree, today's linux-next build (powerpc
> ppc64_defconfig) produced these warnings:
>=20
> drivers/infiniband/hw/cxgb3/cxio_resource.c: In function '__cxio_init_res=
ource_fifo':
> drivers/infiniband/hw/cxgb3/cxio_resource.c:62:3: warning: comparison of =
distinct pointer types lacks a cast [enabled by default]
> drivers/infiniband/hw/cxgb3/cxio_resource.c:74:4: warning: comparison of =
distinct pointer types lacks a cast [enabled by default]
> drivers/infiniband/hw/cxgb3/cxio_resource.c:81:4: warning: comparison of =
distinct pointer types lacks a cast [enabled by default]
> drivers/infiniband/hw/cxgb3/cxio_resource.c:86:4: warning: comparison of =
distinct pointer types lacks a cast [enabled by default]
> drivers/infiniband/hw/cxgb3/cxio_resource.c:89:7: warning: comparison of =
distinct pointer types lacks a cast [enabled by default]
> drivers/infiniband/hw/cxgb3/cxio_resource.c: In function 'cxio_init_qpid_=
fifo':
> drivers/infiniband/hw/cxgb3/cxio_resource.c:123:4: warning: comparison of=
 distinct pointer types lacks a cast [enabled by default]
> drivers/infiniband/hw/cxgb3/cxio_resource.c: In function 'cxio_hal_get_re=
source':
> drivers/infiniband/hw/cxgb3/cxio_resource.c:184:6: warning: comparison of=
 distinct pointer types lacks a cast [enabled by default]
> drivers/infiniband/hw/cxgb3/cxio_resource.c: In function 'cxio_hal_put_re=
source':
> drivers/infiniband/hw/cxgb3/cxio_resource.c:193:2: warning: comparison of=
 distinct pointer types lacks a cast [enabled by default]
> drivers/infiniband/hw/cxgb3/cxio_resource.c:193:2: warning: comparison of=
 distinct pointer types lacks a cast [enabled by default]
> drivers/infiniband/hw/cxgb3/cxio_resource.c:193:2: warning: comparison of=
 distinct pointer types lacks a cast [enabled by default]
>=20
> Probably introduced by commit "include/linux/kfifo.h: replace open-coded
> type check code with typecheck()".

Also:

drivers/scsi/libiscsi.c: In function 'iscsi_free_task':
drivers/scsi/libiscsi.c:507:2: warning: comparison of distinct pointer type=
s lacks a cast [enabled by default]
drivers/scsi/libiscsi.c: In function 'iscsi_pool_init':
drivers/scsi/libiscsi.c:2510:3: warning: comparison of distinct pointer typ=
es lacks a cast [enabled by default]
drivers/scsi/libiscsi.c: In function 'iscsi_conn_setup':
drivers/scsi/libiscsi.c:2881:2: warning: comparison of distinct pointer typ=
es lacks a cast [enabled by default]
drivers/scsi/libiscsi.c: In function 'iscsi_conn_teardown':
drivers/scsi/libiscsi.c:2944:2: warning: comparison of distinct pointer typ=
es lacks a cast [enabled by default]
drivers/scsi/libiscsi_tcp.c: In function 'iscsi_tcp_cleanup_task':
drivers/scsi/libiscsi_tcp.c:462:3: warning: comparison of distinct pointer =
types lacks a cast [enabled by default]
drivers/scsi/libiscsi_tcp.c:469:3: warning: comparison of distinct pointer =
types lacks a cast [enabled by default]
drivers/scsi/libiscsi_tcp.c: In function 'iscsi_tcp_r2t_rsp':
drivers/scsi/libiscsi_tcp.c:570:3: warning: comparison of distinct pointer =
types lacks a cast [enabled by default]
drivers/scsi/libiscsi_tcp.c:586:3: warning: comparison of distinct pointer =
types lacks a cast [enabled by default]
drivers/scsi/libiscsi_tcp.c:596:2: warning: comparison of distinct pointer =
types lacks a cast [enabled by default]
drivers/scsi/libiscsi_tcp.c: In function 'iscsi_tcp_get_curr_r2t':
drivers/scsi/libiscsi_tcp.c:998:5: warning: comparison of distinct pointer =
types lacks a cast [enabled by default]

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__25_Oct_2012_14_30_44_+1100_2K_CMV4dHD8ivxaB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQiLJkAAoJEECxmPOUX5FEhVIP/1rx9cdjzOHRBSoq6AHuDdkq
ik2gtr4ZqjO3blJFCHmzygbXUGbl7tT868OiBSPukXF5CqybW3RzvvaoSD3uAnrm
2sQaiTwX1Xp0fz+CWzOAomVmb/t70BFY1Hra3rUqh8+j/0vCV8waDzveYgM3lsGk
lSS1oTmLZ96EFFrgJCvwHkZbMQoAJ5IK2hZk3lPGF5ZPYYKmUPUcbok5iIoCrQds
xPy7G4QjHjVRSHLA4WpnUhiqfGajVe8YxS81QtucS5D1RNdyrM+Ks23bTJdN21i1
C7AVGGIAEsMrh+00XA/Ki9v06qRBRNFSz0eK04UGXVWboAyNOs9aHu2kyb2GBLCs
A9P7KTkHU4DzJOIKixKMChP+a9SyinKdteCnG9YX8zgKb50YxfboaJ6Pq2tKutbn
kx7c0Zn//UiSldSlTmqz7PpqS2HuPFrD5/XPDqgVu7NXTY71G+CJeEcTAszj2kZH
MgrZEpKxLB0wPgONT0hA9bH2gf3m3S1LfYtIfZv/uXP1EjJfU4Rtgx8lT3Mlu+eW
3o9g9hC4ijfY9sBA5vQjyG1zx+MHarUKOz+E57XwFbFe8auA1t8rtFZAw+gPkJ/v
kLAbdwHQWrNZTiUYCU+iGB24EwblBsl66gD2I7VHDogSSdg0jokuMPm0yxboPQps
TesR3Yqrrn5O+2prwiKP
=e3Xc
-----END PGP SIGNATURE-----

--Signature=_Thu__25_Oct_2012_14_30_44_+1100_2K_CMV4dHD8ivxaB--
