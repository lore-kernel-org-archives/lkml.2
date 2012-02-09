Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab2BIXuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 18:50:40 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56074 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208Ab2BIXuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 18:50:39 -0500
Date: Fri, 10 Feb 2012 10:50:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20120210105026.0075dcf9eba39eb98e7b44ef@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__10_Feb_2012_10_50_26_+1100_zLeIPl4nyTMRP6PF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__10_Feb_2012_10_50_26_+1100_zLeIPl4nyTMRP6PF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-at91/at91cap9.c between commit fa23e771d863 ("Merge branch
'fixes' into for-next") from the arm tree and commit 9918ceafd4a9 ("ARM:
at91: code removal of CAP9 SoC") from the arm-soc tree.

The latter removes the file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__10_Feb_2012_10_50_26_+1100_zLeIPl4nyTMRP6PF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPNFvCAAoJEECxmPOUX5FE1lQP/2U8YejWkfc0LMjUmQODJFID
KKkeGoexad02sipUgC8XhLwA4auSRCExcC1g4co3JD+1v51XB+Ov1Ku9EUCv17Lt
695NRjrOWyFCeaYoA8Jmx1+D+sE91BPD4gXT0ysXCEy7q/0Dwkwv8SVxRxMazXrv
MmEp2LHqu+i2NYPyTeCNjapivrnT3UcpJ9LbYtcjsWM8f5rLMpYzQ2wgwsw3sL+R
bQroIeIfvvPJP+7mOk4ARuY4T/mbc4qo72uAUW4J8SFHUVEpkHfCMSJT7nn92OQM
AEBli/8VdXu1QLKw7ugV/qkT0cD+/g3E0ntKajVJz81KRukoNP2h/snajXjM4mzc
pyF8byJoOkBF7wLk7+LfQN/l/AKPU5oQA9UvDaYBLOo6DfzQVurdXFgJrc3VJ7HW
OZaRP/y7Q1mmBuElvWMzuLXwvQnK+PNGrU9492xudmSQFt+GUdhS6sNBQyyFb/cS
SBY4hErh9V3SH8wE+EJWyeQlL6c2MHcoE8NaGh2Z+11XAGZIEwKItZpzTQjHLJit
Cq2j0Cbkxeb/IG9PusSHwSI+t6S8X459Vt2S5EUjU/HVAA+qXREDv31CPxKCXB2v
ZBGfmKDckuFCQTQgUx/Zo5p9JFqsm/+Jrvr/NbjorKpETagKzIFRreyDpATmDrSh
e4RKbJcl+1u/Z4jyUcoD
=ENb1
-----END PGP SIGNATURE-----

--Signature=_Fri__10_Feb_2012_10_50_26_+1100_zLeIPl4nyTMRP6PF--
