Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab0JLFf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 01:35:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36832 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518Ab0JLFf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 01:35:27 -0400
Date: Tue, 12 Oct 2010 16:35:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Greear <greearb@candelatech.com>
Subject: linux-next: build failure after merge of the final tree (wireless
 tree related)
Message-Id: <20101012163519.a88f2040.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__12_Oct_2010_16_35_19_+1100_GSI0g558P0SUq6JL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Oct_2010_16_35_19_+1100_GSI0g558P0SUq6JL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

After merging the final tree, today's linux-next build failed like this:

ERROR: ".ath_opmode_to_string" [drivers/net/wireless/ath/ath5k/ath5k.ko] un=
defined!

CONFIG_ATH5K_DEBUG is not set ...

Caused by commit 92c68a66a8f73c51f062ae8cae958c86a21fea78 ("ath5k: Print
out opmode in debugfs").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__12_Oct_2010_16_35_19_+1100_GSI0g558P0SUq6JL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMs/OXAAoJEDMEi1NhKgbs2LEIAKLGjZq+9leKTS3M9jJRMxrm
x5mdySUXEinguwIxrqzvXOxBoEDVZsdbZFgEKaIv9XExfYhiosWyePRLbq1RKf9v
NsWSRfAmqXWiaZSE0FQeTJwynZjAJyzFV/xLDv2OVV0wbrXRieGjZoXPJzus6Q21
qMyHLdsD37AemnwiFnnYnJ3lYkn+veh95NDhlw8PNJcgUZCq9ValZHs9H9sLjgxj
gk6/dp4BwJVcTQco+UH5yhGFJC7MEVx1HPHadm6gyNwSXJF/dT6HxEGZ/Jf1Pfcy
aIEMhwoOh9JF1lHye8MKd15JSCy2+22UkFbI98VhKu+UB07rj1GmuoDoyWl8+Iw=
=NaGo
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Oct_2010_16_35_19_+1100_GSI0g558P0SUq6JL--
