Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab0EFCa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 22:30:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39076 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab0EFCaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 22:30:55 -0400
Date: Thu, 6 May 2010 12:30:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
       David Howells <dhowells@redhat.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: linux-next: manual merge of the security-testing tree with Linus'
 tree
Message-Id: <20100506123049.082e98cc.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__6_May_2010_12_30_49_+1000_=icsQtVAix_kd2xT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_May_2010_12_30_49_+1000_=icsQtVAix_kd2xT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next merge of the security-testing tree got a conflict in
security/keys/keyring.c between commit
cea7daa3589d6b550546a8c8963599f7c1a3ae5c ("KEYS: find_keyring_by_name()
can gain access to a freed keyring") from Linus' tree and commit
c5b60b5e67af8be4c58d3ffcc36894f69c4fbdc1 ("security: whitespace coding
style fixes") from the security-testing tree.

I just used the version from Linus' tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__6_May_2010_12_30_49_+1000_=icsQtVAix_kd2xT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkviKdkACgkQjjKRsyhoI8xkYQCfeq9InynYIUjh3rbynXF4Me3N
aI4Anix1PNYSmE1ekvVbxXSF80AVr2kR
=fIII
-----END PGP SIGNATURE-----

--Signature=_Thu__6_May_2010_12_30_49_+1000_=icsQtVAix_kd2xT--
