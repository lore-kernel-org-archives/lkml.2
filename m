Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab0LGDM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 22:12:57 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47792 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab0LGDM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 22:12:56 -0500
Date: Tue, 7 Dec 2010 14:12:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Javier Cardona <javier@cozybit.com>
Subject: linux-next: build failure after merge of the final tree (wireless
 tree related)
Message-Id: <20101207141249.d10c5afc.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__7_Dec_2010_14_12_49_+1100_F2b9.88d+.y.EiRR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_Dec_2010_14_12_49_+1100_F2b9.88d+.y.EiRR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

After merging the final tree, today's linux-next build (i386 defconfig)
failed like this:

net/mac80211/main.c: In function 'ieee80211_bss_info_change_notify':
net/mac80211/main.c:250: error: 'union <anonymous>' has no member named 'me=
sh'

Caused by commit 29cbe68c516a48a9a88b3226878570c6cbd83c02
("cfg80211/mac80211: add mesh join/leave commands").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__7_Dec_2010_14_12_49_+1100_F2b9.88d+.y.EiRR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM/aYyAAoJEDMEi1NhKgbsE08IAIW9wrzgzUSOuKr0BRfluD9Z
+ynBop5ChjmpAngOkGXSuFWwe/p0jrhPeScgfBueSn2NiX/x/qPW50leya/39Sb4
MaDh/DygjgBiw79sB6x5PY03u1PrYsadvlwMswW/JUYHUkMoDhAT17adZok8u+EF
3so/ISFOl0LVAvChheZ0r34nnShrCDxd+DkVDfLvtlmYYQrHCJCyZJUVaGT9r/0U
jyskIARQ70QSil5lQEaDlGzLFj+uyupm7c3huivnkecTXqqp0560johYh7Da+oBO
eQSEzsAv8UG/Tvw+SzQw1CaKgCLrIQjFpTp0X8WQ2bTIcudsJYRbo2iFLE1ZDG4=
=3tSZ
-----END PGP SIGNATURE-----

--Signature=_Tue__7_Dec_2010_14_12_49_+1100_F2b9.88d+.y.EiRR--
