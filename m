Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935651Ab1JFF2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 01:28:24 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:33855 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255Ab1JFF2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 01:28:22 -0400
Date: Thu, 6 Oct 2011 16:27:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Barry Song <baohua.song@csr.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: linux-next: manual merge of the moduleh tree with the pm tree
Message-Id: <20111006162756.c2ce5222b2cd9061d471986f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Oct_2011_16_27_56_+1100_ZVY/04=pWsIJnp0K"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Oct_2011_16_27_56_+1100_ZVY/04=pWsIJnp0K
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
kernel/power/hibernate.c between commit 55415f553b8b ("PM / Hibernate:
Add resumewait param to support MMC-like devices as resume file") from
the pm tree and commit 5ee961c64584 ("kernel: Fix files explicitly
needing EXPORT_SYMBOL infrastructure") from the moduleh tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/power/hibernate.c
index 0f87850,ce21f25..0000000
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@@ -14,7 -14,7 +14,8 @@@
  #include <linux/reboot.h>
  #include <linux/string.h>
  #include <linux/device.h>
 +#include <linux/async.h>
+ #include <linux/export.h>
  #include <linux/kmod.h>
  #include <linux/delay.h>
  #include <linux/fs.h>

--Signature=_Thu__6_Oct_2011_16_27_56_+1100_ZVY/04=pWsIJnp0K
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOjTxcAAoJEECxmPOUX5FEgT0P+wbp9jpUv6O9dc2H/Gj72OSS
EOl5tpm8k1jpsm2yVOb+z31dhbff3YQR6jCs8wPZ7kK+solBk5RrTPpKAg5+OE3s
S3AUm41bkTR4mVqBYiumQceKQHC6VRomVrziGKJ/fLlM4CG8auSwNl1ydweWwiVz
6+A0M9U1gDN+SYb6dVN0L3AHMgS6TZ0FUqiDuaTZgI6DoC6wiWCk01G26MFxPq0P
8S8PB4IfMxKBTtmCR/tUFENcYTtvoElzGEOz6EIYgrlJSqCYgO0BnkmuqS6e2hEK
rmOsIha6zTvIeSP2Q0tzZwpF4WUSjMWCZ9bJhPuaM5RRcPRbhC+/vzfxUjg4VRtQ
610uVI+PmnEZCpWuGmPA6NBiLsTwb8xmCmvrC13dlF6+U/M/vRQ0JUYTJiw7EylS
9ePn7sTr/QW6OGvLsOIiy64NWi92yxEXCfZrZ1Vjfc5GXXHDgNKbR8lgM6vXB+H6
E6acpcFGRt+GV2LhQfwzZBgoe3LCyJ/EnCfuxKTZuhQU054ao0dsGf8cePxM/x6M
JOi1ogHB3JCzzU7O7yOey18nWgCEbHru4Fr8t6wQRtiJ6AMEr6DUrk0MxmdnvqWO
lKZ6Ovq75L3CNqWhDBHCFot0hiKQSQICNa2ESSHOtUPSTwuFfD8MZgaiz7JsvXuK
g/fRWQRCeIDoeKw47mz9
=4l3k
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Oct_2011_16_27_56_+1100_ZVY/04=pWsIJnp0K--
