Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab0LQAYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 19:24:07 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57646 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485Ab0LQAYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 19:24:05 -0500
Date: Fri, 17 Dec 2010 11:23:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warnings after merge of the ia64 tree
Message-Id: <20101217112357.ec7879f1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__17_Dec_2010_11_23_57_+1100_8icTkEePM7hLgNP/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Dec_2010_11_23_57_+1100_8icTkEePM7hLgNP/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tony,

After merging the ia64 tree, today's linux-next build (x86_64_allmodconfig)
produced these warnings:

drivers/acpi/apei/erst.c: In function 'erst_reader':
drivers/acpi/apei/erst.c:826: warning: passing argument 1 of 'spinlock_chec=
k' from incompatible pointer type
include/linux/spinlock.h:272: note: expected 'struct spinlock_t *' but argu=
ment is of type 'struct raw_spinlock_t *'
drivers/acpi/apei/erst.c:829: warning: passing argument 1 of 'spin_unlock_i=
rqrestore' from incompatible pointer type
include/linux/spinlock.h:338: note: expected 'struct spinlock_t *' but argu=
ment is of type 'struct raw_spinlock_t *'
drivers/acpi/apei/erst.c:834: warning: passing argument 1 of 'spin_unlock_i=
rqrestore' from incompatible pointer type
include/linux/spinlock.h:338: note: expected 'struct spinlock_t *' but argu=
ment is of type 'struct raw_spinlock_t *'
drivers/acpi/apei/erst.c:840: warning: passing argument 1 of 'spin_unlock_i=
rqrestore' from incompatible pointer type
include/linux/spinlock.h:338: note: expected 'struct spinlock_t *' but argu=
ment is of type 'struct raw_spinlock_t *'

Introduced by commit ae85bdfb6bd024fab5556f9b78668b1c6aab6fb8 ("pstore:
X86 platform interface using ACPI/APEI/ERST").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__17_Dec_2010_11_23_57_+1100_8icTkEePM7hLgNP/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNCq2eAAoJEDMEi1NhKgbsOuUH+gM4WSTE24D3lLBXUc864h7/
gc95WtYNZ1SUvQBklxEdcCCs19av/JiPEax1gzd73TRmuVPbkwC13NxihyCrVAOH
kkaBCzpvaFs8r+h6kQksh5XHWAyKo4EYWpemQ651wGq7xfKioka15SD3ugerCMOe
MQSJ8W9um/wKn9tXH+3ULT62/kXCd8y08OJDK20tuWysKZ23O+Cz3THy6EQNsvK/
NLtofk6sCHvqleCIhQWoF+0hhW4EQUoiEAFM2Tpm1KL5mr6n5oq4aP9ElNr98BWt
Yd+mij0WU6mhHrN/dREc7Tzsmb0FNlTGgoDqSTMcNT9liYqvuPYSRgrugoCpauo=
=bxbm
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Dec_2010_11_23_57_+1100_8icTkEePM7hLgNP/--
