Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab0EJDoS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 23:44:18 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43963 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab0EJDoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 23:44:16 -0400
Date: Mon, 10 May 2010 13:44:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warnings after merge of the rr tree
Message-Id: <20100510134409.4bbf1873.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__10_May_2010_13_44_09_+1000_PNp6M7jZBSlOOiNO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_May_2010_13_44_09_+1000_PNp6M7jZBSlOOiNO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

After merging the fsnotify tree, today's linux-next build (x86_64 allmodcon=
fig)
produced thes warnings:

drivers/acpi/debug.c:140: warning: passing argument 1 of '__check_old_set_p=
aram' from incompatible pointer type
include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, stru=
ct kernel_param *)' but argument is of type 'int (*)(const char *, const st=
ruct kernel_param *)'
drivers/acpi/debug.c:140: warning: passing argument 1 of '__check_old_set_p=
aram' from incompatible pointer type
include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, stru=
ct kernel_param *)' but argument is of type 'int (*)(const char *, const st=
ruct kernel_param *)'
drivers/acpi/debug.c:140: warning: passing argument 1 of '__check_old_set_p=
aram' from incompatible pointer type
include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, stru=
ct kernel_param *)' but argument is of type 'int (*)(const char *, const st=
ruct kernel_param *)'
drivers/acpi/debug.c:140: warning: passing argument 1 of '__check_old_set_p=
aram' from incompatible pointer type
include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, stru=
ct kernel_param *)' but argument is of type 'int (*)(const char *, const st=
ruct kernel_param *)'
drivers/acpi/debug.c:141: warning: passing argument 1 of '__check_old_set_p=
aram' from incompatible pointer type
include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, stru=
ct kernel_param *)' but argument is of type 'int (*)(const char *, const st=
ruct kernel_param *)'
drivers/acpi/debug.c:141: warning: passing argument 1 of '__check_old_set_p=
aram' from incompatible pointer type
include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, stru=
ct kernel_param *)' but argument is of type 'int (*)(const char *, const st=
ruct kernel_param *)'
drivers/acpi/debug.c:141: warning: passing argument 1 of '__check_old_set_p=
aram' from incompatible pointer type
include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, stru=
ct kernel_param *)' but argument is of type 'int (*)(const char *, const st=
ruct kernel_param *)'
drivers/acpi/debug.c:141: warning: passing argument 1 of '__check_old_set_p=
aram' from incompatible pointer type
include/linux/moduleparam.h:165: note: expected 'int (*)(const char *, stru=
ct kernel_param *)' but argument is of type 'int (*)(const char *, const st=
ruct kernel_param *)'

Introduced by commit a1c3b92923eced4ee034fa15bf058f91e435e08c ("param:param=
_ops").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__10_May_2010_13_44_09_+1000_PNp6M7jZBSlOOiNO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvngQkACgkQjjKRsyhoI8yS1ACgoeo65pdiSvEktzSRyUqKpt1j
GkcAnRxpYao5Qtmn1OJxlm2ZzZrsyrl2
=dcjP
-----END PGP SIGNATURE-----

--Signature=_Mon__10_May_2010_13_44_09_+1000_PNp6M7jZBSlOOiNO--
