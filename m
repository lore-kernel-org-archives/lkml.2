Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab2L2WeT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 17:34:19 -0500
Received: from ngcobalt07.manitu.net ([217.11.48.107]:54831 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab2L2WeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 17:34:18 -0500
X-manitu-Original-Sender-IP: 127.0.0.1
X-manitu-Original-Receiver-Name: ngcobalt07.manitu.net
Date: Sat, 29 Dec 2012 23:33:28 +0100
From: Roland Eggner <edvx1@systemanalysen.net>
To: Dmitry Voytik <dvv.kernel@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: [PATCH 2/2] nconf:  function keys line, change background color for
 better readability
Message-ID: <20121229223328.GA28355@mobil.systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
Mail-Followup-To: Dmitry Voytik <dvv.kernel@gmail.com>,
	Michal Marek <mmarek@suse.cz>, Stephen Boyd <sboyd@codeaurora.org>,
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
References: <20121228185108.GA13644@voyt-hp>
 <1356723607-17027-1-git-send-email-dvv.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <1356723607-17027-1-git-send-email-dvv.kernel@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>From: Roland Eggner <edvx1@systemanalysen.net>

=E2=80=A2  In function keys line descriptions black on darkblue are almost =
impossible
   to read.  Change colors to black on brown.

Signed-off-by: Roland Eggner <edvx1@systemanalysen.net>
---
--- a/scripts/kconfig/nconf.gui.c	2012-11-16 17:47:22.000000000 +0100
+++ b/scripts/kconfig/nconf.gui.c	2012-12-23 23:51:40.929833170 +0100
@@ -48,7 +48,7 @@ static void set_normal_colors(void)
 	init_pair(INPUT_FIELD, -1, -1);
=20
 	init_pair(FUNCTION_HIGHLIGHT, -1, -1);
-	init_pair(FUNCTION_TEXT, COLOR_BLUE, -1);
+	init_pair(FUNCTION_TEXT, COLOR_YELLOW, -1);
 }
=20
 /* available attributes:

--=20
Roland Eggner

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlDfb7gACgkQdN/hKfT7G/LLNACfdz3PGHpj1T65Y9oZVIVeAy3e
YbsAn1r9v1iWbcq9NfeSuW/lZ8knu5jM
=gPIp
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
