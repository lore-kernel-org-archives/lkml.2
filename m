Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab0FOCzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 22:55:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39635 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756587Ab0FOCzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 22:55:21 -0400
Date: Tue, 15 Jun 2010 12:55:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Marek Vasut <marek.vasut@gmail.com>, Eric Miao <eric.y.miao@gmail.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Huang Weiyi <weiyi.huang@gmail.com>
Subject: linux-next: manual merge of the battery tree with the arm-current
 tree
Message-Id: <20100615125512.09c79d9b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__15_Jun_2010_12_55_12_+1000_DLcMIFS+VE8M5V/h"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_Jun_2010_12_55_12_+1000_DLcMIFS+VE8M5V/h
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Anton,

Today's linux-next merge of the battery tree got a conflict in
drivers/power/z2_battery.c between commit
56b925fccc58cd43fc553a8302dbbdd440aef288 ("[ARM] pxa/z2: fix missing
include in battery driver") from the arm-current tree and commit
5d111107b7994349feb681466f873b1a4f8a09d6 ("z2_battery: Remove duplicated
#include") from the battery tree.

The former is a superset of the latter.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__15_Jun_2010_12_55_12_+1000_DLcMIFS+VE8M5V/h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwW65AACgkQjjKRsyhoI8zmJQCgkTwCQ96Gwu4V7fe/+QyeEm/4
QBgAn1laYf1m4ETtMNklEIbnBjDelr9V
=x6if
-----END PGP SIGNATURE-----

--Signature=_Tue__15_Jun_2010_12_55_12_+1000_DLcMIFS+VE8M5V/h--
