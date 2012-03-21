Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964896Ab2CUFwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 01:52:23 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53099 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964802Ab2CUFwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 01:52:14 -0400
Date: Wed, 21 Mar 2012 16:52:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Azael Avalos <coproscefalo@gmail.com>
Subject: linux-next: build failure after merge of the drivers-x86 tree
Message-Id: <20120321165204.3b9e1995dc363b685d8018dc@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__21_Mar_2012_16_52_04_+1100_nO+2m1wjTc5QHH7r"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Mar_2012_16_52_04_+1100_nO+2m1wjTc5QHH7r
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matthew,

After merging the drivers-x86 tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/platform/x86/toshiba_acpi.c:141:1: error: unknown type name 'sturct'
drivers/platform/x86/toshiba_acpi.c:141:32: error: expected '=3D', ',', ';'=
, 'asm' or '__attribute__' before '*' token
drivers/platform/x86/toshiba_acpi.c: In function 'toshiba_acpi_i8042_filter=
':
drivers/platform/x86/toshiba_acpi.c:877:18: error: 'toshiba_acpi' undeclare=
d (first use in this function)
drivers/platform/x86/toshiba_acpi.c:877:18: note: each undeclared identifie=
r is reported only once for each function it appears in
drivers/platform/x86/toshiba_acpi.c: In function 'toshiba_acpi_remove':
drivers/platform/x86/toshiba_acpi.c:1050:6: error: 'toshiba_acpi' undeclare=
d (first use in this function)
drivers/platform/x86/toshiba_acpi.c: In function 'toshiba_acpi_add':
drivers/platform/x86/toshiba_acpi.c:1083:6: error: 'toshiba_acpi' undeclare=
d (first use in this function)

Caused by commit 5ea3879c8e16 ("toshiba_acpi: Support alternate hotkey inte=
rfaces").

Please build test this stuff :-(

I have used the drivers-x86 tree from next-20120320 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__21_Mar_2012_16_52_04_+1100_nO+2m1wjTc5QHH7r
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPaWyEAAoJEECxmPOUX5FEqb0QAIdqfmCoSS2zwIBC4dNdOJbx
v13lizZFBPmR9EaWbbGI3hyPG64s5pZoKEqmlMtIl7h1r5yWLWbmlNvey+ZsiNfh
/s0WGdwJyEiX/nYAdYsznAnbcILAUbPZR6sid5+7FPJdqrS9Kq8JxPDwT4zU9BTM
Sgs2AY45o+mEu3AsYcLx3b/lG0s6g4KtaIGp7/HYZNQC+aPlIJ33R1Dp/uziB0Vg
00CvNnOnjnaPQlD2tEkGBnW7hIWY5l1eUm6jh+wgbqIzSl4iS6cxgkjT/wmu+kVq
7nTTxReD/VUngxALcu65xUACK4dT9bIr2NImb/sGeAQ1q9QjuhURSYD2eqlRrC1O
syMbf+Ytn8S/JwbEgnJ/jM41tILgd8ELyHafICk3anVth/hmyqBVLg31p8ROW1/X
9R2kCBnkyw1bdqGITcSGf+tS0Sdox30Lkd08kfxFD/sbCWYVd20sTtO9tn2gA5A1
ho7YVmBmvY93B4nmfLJY0O40UlKRTXFOX91kN55syW9q6vpUTM5k6UZtdUSjMdij
cyy/Fj8v6l6mu9gz1NiQry6NEoflQaN97SDWSPoXW9pKlQJEp/yLPyEXES5Kcwrf
owPlADeQST3l3iYWq54kj8tE3PCZajTYHbwElqW650TsbcFw3sO7EKanvOtCgQ0k
gAsz/gpkyJPegNMpKx/8
=/poY
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Mar_2012_16_52_04_+1100_nO+2m1wjTc5QHH7r--
