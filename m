Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab0HQBYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 21:24:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48508 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341Ab0HQBYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 21:24:47 -0400
Date: Tue, 17 Aug 2010 11:24:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>
Subject: linux-next: build warnings in Linus' tree
Message-Id: <20100817112439.18f9d958.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__17_Aug_2010_11_24_39_+1000_rWgcAkuVN0b13g=0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Aug_2010_11_24_39_+1000_rWgcAkuVN0b13g=0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (x86_64 allmodconfig) produced these warnings:

drivers/acpi/sysfs.c:152: warning: passing argument 1 of '__check_old_set_p=
aram' from incompatible pointer type
include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, stru=
ct kernel_param *)' but argument is of type 'int (*)(const char *, const st=
ruct kernel_param *)'
drivers/acpi/sysfs.c:152: warning: passing argument 1 of '__check_old_set_p=
aram' from incompatible pointer type
include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, stru=
ct kernel_param *)' but argument is of type 'int (*)(const char *, const st=
ruct kernel_param *)'
drivers/acpi/sysfs.c:152: warning: passing argument 1 of '__check_old_set_p=
aram' from incompatible pointer type
include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, stru=
ct kernel_param *)' but argument is of type 'int (*)(const char *, const st=
ruct kernel_param *)'
drivers/acpi/sysfs.c:152: warning: passing argument 1 of '__check_old_set_p=
aram' from incompatible pointer type
include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, stru=
ct kernel_param *)' but argument is of type 'int (*)(const char *, const st=
ruct kernel_param *)'
drivers/acpi/sysfs.c:154: warning: passing argument 1 of '__check_old_set_p=
aram' from incompatible pointer type
include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, stru=
ct kernel_param *)' but argument is of type 'int (*)(const char *, const st=
ruct kernel_param *)'
drivers/acpi/sysfs.c:154: warning: passing argument 1 of '__check_old_set_p=
aram' from incompatible pointer type
include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, stru=
ct kernel_param *)' but argument is of type 'int (*)(const char *, const st=
ruct kernel_param *)'
drivers/acpi/sysfs.c:154: warning: passing argument 1 of '__check_old_set_p=
aram' from incompatible pointer type
include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, stru=
ct kernel_param *)' but argument is of type 'int (*)(const char *, const st=
ruct kernel_param *)'
drivers/acpi/sysfs.c:154: warning: passing argument 1 of '__check_old_set_p=
aram' from incompatible pointer type
include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, stru=
ct kernel_param *)' but argument is of type 'int (*)(const char *, const st=
ruct kernel_param *)'

Introduced by commit 1c8fce27e275fd7c6b75bc6455745f02d3903ee6 ("ACPI:
introduce drivers/acpi/sysfs.c") interacting with commit
9bbb9e5a33109b2832e2e63dcc7a132924ab374b ("param: use ops in struct
kernel_param, rather than get and set fns directly").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__17_Aug_2010_11_24_39_+1000_rWgcAkuVN0b13g=0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMaeTXAAoJEDMEi1NhKgbsXtEH/2kZK+pdSL5c+sL/gbpEaAgS
Qc1m/1KMfQiOQ1Pihw3rFz8v0UyrFQNGnKCoSP4Aa8ECCmTUPx+6T4i2m27/BP4s
ychU3P+4SxTQVlhnJaeXeCpIPlex1mYQMm9BSYqQf5Bp5HOjjtOLkBCZGEkcJSoN
thn3QAFpst/zzmK2YfZ+wAGuIQ5WXfmdPAg5YMyM9G5q8cjHx42uYCt31ewlY2ZJ
3yShEmHSRQpyyn2YFWZkXY4hF4AaZv007YBFIHej2JUvbf9t8+nnppRrRRNMzOTR
Rpevornx9XSFrydCf7xLmoFbLpMR74JVJcHy5POqJH3DPSicg2WKUfWmzEE571c=
=ldsk
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Aug_2010_11_24_39_+1000_rWgcAkuVN0b13g=0--
