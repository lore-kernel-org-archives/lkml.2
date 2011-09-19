Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751090Ab1ISFOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 01:14:45 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:35151 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab1ISFOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 01:14:44 -0400
Date: Mon, 19 Sep 2011 15:14:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luciano Coelho <coelho@ti.com>
Subject: linux-next: manual merge of the wireless tree with Linus' tree
Message-Id: <20110919151434.e710fc8eb95675a2c6a278cd@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__19_Sep_2011_15_14_34_+1000_1/j1V+AgmZ/NpxIt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Sep_2011_15_14_34_+1000_1/j1V+AgmZ/NpxIt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/net/wireless/wl12xx/main.c between commit 7a5e4877c14d ("wl12xx:
add max_sched_scan_ssids value to the hw description") from Linus' tree
and commit f952079a19c6 ("wl12xx: add support for multiple SSIDs in
sched_scan") from the wireless tree.

I used the version from the wireless tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__19_Sep_2011_15_14_34_+1000_1/j1V+AgmZ/NpxIt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOds+6AAoJEDMEi1NhKgbseQQH/2yQ96a1tBKntxo3indJVbfQ
CK7iwim+jb1YUcchGfPNQsX3WFsW738pjXiUzKx03thbpgs9xf2mdMNs9VD7eyTY
Yo6Eg9gL1pkBqPB3JQHrI5WphMJfDON+ZqiAZRRCsqWEgpj/DdrQ+bYquUuFajdI
HJDb/ITRjEyX1HLDl3otzR4pcucx/ewzncoEj346lHqe+fZBwLzFLM56ZE8J8EHD
EfolZOfUTOecMYXYNwLvnefaV0Pux0CkZF5wvw9JHyIRF2LtAA8k9w6H2Nmf/miQ
o7uaQjUekQ8hxW1giNpXe9sN+hK1nJMP2+cLE+vcA6ifD7m6v9/uOopoMaTg/t4=
=MIfS
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Sep_2011_15_14_34_+1000_1/j1V+AgmZ/NpxIt--
