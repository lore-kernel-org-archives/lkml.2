Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab1EXDmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 23:42:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44457 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757060Ab1EXDmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 23:42:17 -0400
Date: Tue, 24 May 2011 13:42:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (suspend
 tree related)
Message-Id: <20110524134216.1033c885.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__24_May_2011_13_42_16_+1000_nCJeb4GDaQLP9nNS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__24_May_2011_13_42_16_+1000_nCJeb4GDaQLP9nNS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

kernel/swsusp.c:13:25: error: asm/suspend.h: No such file or directory
kernel/power/hibernate.c:28:25: error: asm/suspend.h: No such file or direc=
tory

Caused by commit 8f6404f39725 ("PM / Hibernate: Remove
arch_prepare_suspend()" which completely removed asm/suspend.h on
powerpc, frv and s390.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__24_May_2011_13_42_16_+1000_nCJeb4GDaQLP9nNS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN2ykYAAoJEDMEi1NhKgbsLaMH/03dV8m8qG+8Bf8lNR2fGL+R
cj37LMhHuXJChADR02Om7LjjuS7xFgHKukSGZ/r8Tm5RTS6lg7Wuhypm5UknNAOT
xDXG0jE1DdgHmAicTDEgl/+UcX+IiqCda4bSdOQ8Umv9TjIE+d4Bly01ltPO0rpO
aXFhBZ8ZxD1wRBY3LY10NELCJq+tlc1/ENiG2AUh1ZarUiAPWeDZ4cuuj1HRVpkM
sq3iN/aKczzKYtw2LD0Ulq4b3616KUElyLmTBp9YRd5R6LiVGzs8eCivtS0TzuwN
K6TUmHXwpv/aE6Vv0My56AL4Ah+cDuLZVgGIXV/uYNTgyGo7igMPtffIm2RtsQg=
=lry2
-----END PGP SIGNATURE-----

--Signature=_Tue__24_May_2011_13_42_16_+1000_nCJeb4GDaQLP9nNS--
