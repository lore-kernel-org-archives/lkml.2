Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab0H3Bma (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 21:42:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53446 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352Ab0H3Bm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 21:42:29 -0400
Date: Mon, 30 Aug 2010 11:42:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: linux-next: build warnings in Linus' tree
Message-Id: <20100830114222.3a1f53e6.sfr@canb.auug.org.au>
In-Reply-To: <20100817112439.18f9d958.sfr@canb.auug.org.au>
References: <20100817112439.18f9d958.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__30_Aug_2010_11_42_22_+1000_bg+xvqMihjQNRumZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__30_Aug_2010_11_42_22_+1000_bg+xvqMihjQNRumZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

On Tue, 17 Aug 2010 11:24:39 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next build (x86_64 allmodconfig) produced these warnings:
>=20
> drivers/acpi/sysfs.c:152: warning: passing argument 1 of '__check_old_set=
_param' from incompatible pointer type
> include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, st=
ruct kernel_param *)' but argument is of type 'int (*)(const char *, const =
struct kernel_param *)'
> drivers/acpi/sysfs.c:152: warning: passing argument 1 of '__check_old_set=
_param' from incompatible pointer type
> include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, st=
ruct kernel_param *)' but argument is of type 'int (*)(const char *, const =
struct kernel_param *)'
> drivers/acpi/sysfs.c:152: warning: passing argument 1 of '__check_old_set=
_param' from incompatible pointer type
> include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, st=
ruct kernel_param *)' but argument is of type 'int (*)(const char *, const =
struct kernel_param *)'
> drivers/acpi/sysfs.c:152: warning: passing argument 1 of '__check_old_set=
_param' from incompatible pointer type
> include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, st=
ruct kernel_param *)' but argument is of type 'int (*)(const char *, const =
struct kernel_param *)'
> drivers/acpi/sysfs.c:154: warning: passing argument 1 of '__check_old_set=
_param' from incompatible pointer type
> include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, st=
ruct kernel_param *)' but argument is of type 'int (*)(const char *, const =
struct kernel_param *)'
> drivers/acpi/sysfs.c:154: warning: passing argument 1 of '__check_old_set=
_param' from incompatible pointer type
> include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, st=
ruct kernel_param *)' but argument is of type 'int (*)(const char *, const =
struct kernel_param *)'
> drivers/acpi/sysfs.c:154: warning: passing argument 1 of '__check_old_set=
_param' from incompatible pointer type
> include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, st=
ruct kernel_param *)' but argument is of type 'int (*)(const char *, const =
struct kernel_param *)'
> drivers/acpi/sysfs.c:154: warning: passing argument 1 of '__check_old_set=
_param' from incompatible pointer type
> include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, st=
ruct kernel_param *)' but argument is of type 'int (*)(const char *, const =
struct kernel_param *)'
>=20
> Introduced by commit 1c8fce27e275fd7c6b75bc6455745f02d3903ee6 ("ACPI:
> introduce drivers/acpi/sysfs.c") interacting with commit
> 9bbb9e5a33109b2832e2e63dcc7a132924ab374b ("param: use ops in struct
> kernel_param, rather than get and set fns directly").

Can we have this fixed, please?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__30_Aug_2010_11_42_22_+1000_bg+xvqMihjQNRumZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMewx+AAoJEDMEi1NhKgbs9EIH/0WxZDbk/LYWggbKb4ZlKttN
WhgSorr+E1hfkJqs92nKb09aGArvgjHPnwHKPBmy0QQ8uBbctrWcuBnf1XiPFfFc
FPS9eA7ADP/SIn7Hu9viAKj8Ut6+5iPc5vdxMUWQLgwbGZaOkg66YWRAja1UjudN
KcTtu5ic7k/O/cKrB8A7Q9JqG4wHcRGM9rvQx9MYt3CNcgG3E5GXy/CwRc1B2QeG
JBwzKQf2fT/QlSgP6+PVC0BxzGSUGmmQ5wFA3FwHLYg0bLK+PNF6lwEvhFBgSffg
KAIDxae0BP+KJT0V6Dy+tgHuqp8HUBY1ZFvl7pC4uw+oOEivB8YvUIt77SInjwU=
=OMZ8
-----END PGP SIGNATURE-----

--Signature=_Mon__30_Aug_2010_11_42_22_+1000_bg+xvqMihjQNRumZ--
