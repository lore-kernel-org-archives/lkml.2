Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab1GGBUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 21:20:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44833 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857Ab1GGBUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 21:20:18 -0400
Date: Thu, 7 Jul 2011 11:20:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: linux-next: removed a patch from the akpm tree
Message-Id: <20110707112006.e97656915b4a9fceaf11a315@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__7_Jul_2011_11_20_06_+1000_f6MY8.Y05HGC5mnA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Jul_2011_11_20_06_+1000_f6MY8.Y05HGC5mnA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

I have removed tha patch
drivers-net-wireless-rtlwifi-rtl8192de-phyc-fix-udelay-usage.patch from
my copy of the akpm tree today as it turned up in the wireless tree
yesterday as commit faeef8acb18f
("drivers/net/wireless/rtlwifi/rtl8192de/phy.c: fix udelay() usage").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__7_Jul_2011_11_20_06_+1000_f6MY8.Y05HGC5mnA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOFQnGAAoJEDMEi1NhKgbs6SAH/33a6suuDtDtAK8uVAXDfekZ
EvO4e41Xr8vLGsusre+VWpQepWfI/vkVBJ2EWYF8J4/x3fhmDKwRTxUAGWAzd4RU
PkpYMEoLdb0/CeCXT34VvY5LvP7x2gLEh3perRsJLPLyVZAx+BIwjJFwR9daKHrG
24sIVzDIksE6oIIn9DN/TiJ6/rjP6wuJMM/7Zz24zsEt+NUoVC4vkeTksJwkzcab
mymecfgEYSC4JhF8SItye1BWTl6ZO4NrQCTKh7evF8CKplWU3gTv3qSlqXLyYRJT
ZgMz+cYinfut4iguEvuFNBkJJA9Q+I0ptyQtU3Ki7RTasi+SugDdEaQUrXEB1sU=
=iJA4
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Jul_2011_11_20_06_+1000_f6MY8.Y05HGC5mnA--
