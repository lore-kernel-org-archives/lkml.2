Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab0JAAtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 20:49:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40548 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784Ab0JAAtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 20:49:42 -0400
Date: Fri, 1 Oct 2010 10:49:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: unable to fetch leds and backlight trees
Message-Id: <20101001104935.76efd0b8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__1_Oct_2010_10_49_35_+1000_B.JqSsEBq6qdlWUX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__1_Oct_2010_10_49_35_+1000_B.JqSsEBq6qdlWUX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Richard,

Fetching the trees produces this error:

git.o-hand.com[0: 70.86.75.186]: errno=3DConnection refused

Just letting you know.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__1_Oct_2010_10_49_35_+1000_B.JqSsEBq6qdlWUX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMpTAfAAoJEDMEi1NhKgbsE9UH/1nEV7Zs/aZ99bV63Xf0wy7H
xKbSFjPfaic45i8V1YOckeVWtVjRc90s1oDXtaG3qPFDx42wB/CTOtrLFMsoYlH8
CO3MTLuxLE61YNPurxK/CUa9b0tac8yRN0s9akEtncLGV/Ed6Y36yObKmtqOymmC
yi2Z0ukien4ad8oN9f7VyPvTIayxuIAJC/S5LXsghRsIthhohRac+QK7XhymLumz
ywO4fc0HmGz/qaJeSPAXHah1tXysuzbLSBDhvU1CYNEFqZ+s2pzATP3h2n4wwtr7
63cAQXAh8tgvAZpB61rw9bYpHgZcAww32fFjFXv6hdp7IU+Q13gLbjj9HCTBgDk=
=/slT
-----END PGP SIGNATURE-----

--Signature=_Fri__1_Oct_2010_10_49_35_+1000_B.JqSsEBq6qdlWUX--
