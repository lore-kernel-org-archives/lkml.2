Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab0FWCv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 22:51:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41123 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab0FWCv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 22:51:57 -0400
Date: Wed, 23 Jun 2010 12:51:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the wireless tree
Message-Id: <20100623125149.bdd7b1e6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__23_Jun_2010_12_51_49_+1000_=qlBHA/m++osTcNF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Jun_2010_12_51_49_+1000_=qlBHA/m++osTcNF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

After merging the wireless tree, today's linux-next build (x86_64 allmodcon=
fig)
failed like this:

ERROR: "mesh_handler_def" [drivers/net/wireless/libertas/libertas.ko] undef=
ined!

Caused by commit cbca36ab906ce8c8d959eca1e0b5465e9182b0f0 ("Libertas:
cfg80211 support") which removed mesh_handler_def even though there is
still a reference to it in drivers/net/wireless/libertas/mesh.c when
WIRELESS_EXT is defined.

I have used the wireless tree from next-20100622 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__23_Jun_2010_12_51_49_+1000_=qlBHA/m++osTcNF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwhdsUACgkQjjKRsyhoI8y2dgCeOTBq4VWEP/ZtrZMyjBaRGVmv
61cAn0U+PmYJXTe8TYaFcylXJ6dA6EtG
=Q3MJ
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Jun_2010_12_51_49_+1000_=qlBHA/m++osTcNF--
