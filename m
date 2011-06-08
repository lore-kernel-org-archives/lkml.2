Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab1FHBlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 21:41:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36874 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198Ab1FHBlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 21:41:39 -0400
Date: Wed, 8 Jun 2011 11:41:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "Igor M. Liplianin" <liplianin@netup.ru>
Subject: linux-next: build failure after merge of the staging.current tree
Message-Id: <20110608114130.444a7f99.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__8_Jun_2011_11_41_30_+1000_4S8im8GV3r.0g/IX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__8_Jun_2011_11_41_30_+1000_4S8im8GV3r.0g/IX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the staging.current tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/media/video/cx23885/cx23885-cards.c:28:28: fatal error: staging/alt=
era.h: No such file or directory

Caused by commit 85ab9ee946da ("Staging: altera: move .h file to proper
place").

I have used the staging.current tree from next-20110607 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__8_Jun_2011_11_41_30_+1000_4S8im8GV3r.0g/IX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN7tNKAAoJEDMEi1NhKgbs6scH/jXwMsDJlXdaeMlBNHrOOEML
PblCfPGPjIAEVfHK0suQmwLFR3iD62mA+pQwZluRpqwrGk1sDqK9ratWbV3BVsq2
9lxXjKvCrAmQMTXpAl8hSIZZDPWUKYc03xk0BhjvJQgb4d0GAsvZjC8tBLh2PLWf
/Pj9WaFQUwDmZlPNQjjZORt8xyvJ7uvIgwRi4smv8JVl8dYtDiLoO1YEupSL3fS/
UCc3RKVOs25XFJM2Ix8ohFMkSS6AWuQ1GDsYDDVjPqrsEfdgv77EBj6nhsE/Na5s
tiOHcHUYmiKHb6x5zH3p/FS1Cd01DwcXXX0VJEQMsmGIpU/HmURP0D9wMqxgdzA=
=41NR
-----END PGP SIGNATURE-----

--Signature=_Wed__8_Jun_2011_11_41_30_+1000_4S8im8GV3r.0g/IX--
