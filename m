Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab0IUGGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 02:06:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56755 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab0IUGGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 02:06:46 -0400
Date: Tue, 21 Sep 2010 16:06:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sven Eckelmann <sven.eckelmann@gmx.de>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: linux-next: manual merge of the bkl-llseek tree with the
 staging-next tree
Message-Id: <20100921160637.c61d4322.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__21_Sep_2010_16_06_37_+1000_fFeYMTsBe1orEyoK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__21_Sep_2010_16_06_37_+1000_fFeYMTsBe1orEyoK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

Today's linux-next merge of the bkl-llseek tree got conflicts in
drivers/staging/batman-adv/icmp_socket.c and
drivers/staging/batman-adv/bat_debugfs.c between commit
2d77bb592f6cabc5ee5322c03ee92b9f96c45f60 ("Staging: batman-adv: Mark
debugfs files as nonseekable") from the staging-next tree and commit
5295184fb318693b4ef2cd8056bf1a7cb43586d7 ("llseek: automatically
add .llseek fop") from the bkl-llseek tree.

I used the versions from the staging-next tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__21_Sep_2010_16_06_37_+1000_fFeYMTsBe1orEyoK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMmEttAAoJEDMEi1NhKgbsBOwH/1lLy+1s0jA3nnmqfnOK+Ai3
FBSENcDK9/LF1fIybI015VOIw2MiY/CXbc6SCISOOrpCLuICohpd7EACb8bWJ1Bp
0L58m4skRxL5g9ge1bFZhSIB/jY1rPhAqdjDrfnXuoRVVWnw4+ZuS0wma/0OIrri
CYOPQVVSPLKoMGhnvXjZ7gEGeP3+jgvSjiJOjflrE5gkD22mh8fgrR/KLpiXaZL2
g7DhOGHs/CjTrNvOHA9TqiLgRBFIR47spbO15BPOP9jrcP/6w5rzoGQIpxyXlleW
tiEEQ1ma3VOkaSJKM+2JH96vIBtYpDjUVy6peqAnOStx0xhiuD9vJzY2pWRezrs=
=Ragl
-----END PGP SIGNATURE-----

--Signature=_Tue__21_Sep_2010_16_06_37_+1000_fFeYMTsBe1orEyoK--
