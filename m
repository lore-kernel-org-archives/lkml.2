Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972Ab1IIEWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 00:22:25 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:35834 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1IIEWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 00:22:22 -0400
Date: Fri, 9 Sep 2011 14:22:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Sebastian Reichel <sre@debian.org>,
        John Stultz <john.stultz@linaro.org>,
        Ilkka Koskinen <ilkka.koskinen@nokia.com>
Subject: linux-next: manual merge of the mfd tree with Linus' tree
Message-Id: <20110909142213.918fdb6a133cdf452e4eb572@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__9_Sep_2011_14_22_13_+1000_nQxhfGNsIlBwdnu7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Sep_2011_14_22_13_+1000_nQxhfGNsIlBwdnu7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

Today's linux-next merge of the mfd tree got a conflict in
drivers/rtc/rtc-twl.c between commits dec35d19c4ec ("rtc: rtc-twl: Switch
to using threaded irq") and 34d623d11316 ("rtc: rtc-twl: Remove lockdep
related local_irq_enable()") from Linus' tree and commit 02e964b17e2f
("rtc: Move twl to threaded irq") from the mfd tree.

The 2 commits from Linus' tree do exactly what the single mfd tree commit
does.  I used the version from Linus' tree (which had further changes).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__9_Sep_2011_14_22_13_+1000_nQxhfGNsIlBwdnu7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOaZR1AAoJEDMEi1NhKgbsaz8H/3mTu4OJQqOCA4pqXfHm/Oy9
1giZ9t7gdUL2BEX+3N7Qz2i15/Fvc+s0X3G7wrH6Od0xxilEUGW7E5s7j8qpNS5A
LtQNWQsc3DsQil6gdsYaDDCgxpaAuRiwnXEhxkJdBe5lS2R6KwxQxQuYnjHY2y9N
aVj/vHrL623SD7Bfh+gwsFCc+1A042qup7O+KlHByLAYIWQeurLYiefU3X62lCh/
AC3Wf3io8vUIfbJEtZB4gxq9vhKUTx2nyeBGeSoTPE2vYfxET4OmVLedKYTxUDDu
QwQNhkRlxZhtdHHL8oKjqdwCW5IpgFTR53QN3pYt/4Nck7nWQws9PoVg6DXXGlQ=
=nPa7
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Sep_2011_14_22_13_+1000_nQxhfGNsIlBwdnu7--
