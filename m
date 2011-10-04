Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab1JDGqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 02:46:55 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:34532 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab1JDGqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 02:46:54 -0400
Date: Tue, 4 Oct 2011 17:46:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: manual merge of the moduleh tree with the wireless tree
Message-Id: <20111004174642.64d42f2bdd6c3b5fd316644a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Oct_2011_17_46_42_+1100_3_fgbSe_SSUwhtm0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Oct_2011_17_46_42_+1100_3_fgbSe_SSUwhtm0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
drivers/net/wireless/ath/ath6kl/init.c between commit c6efe578fc5d
("wireless/ath6kl: use of module_param requires the inclusion of
moduleparam.h") from the wireless tree and the same patch as a merge fix
for the moduleh tree.

I dropped the moduleh tree merge fix.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__4_Oct_2011_17_46_42_+1100_3_fgbSe_SSUwhtm0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOiqvSAAoJEECxmPOUX5FEqOYP/RLYmsTPD3Vmm990xfJIRjhx
l4qeAY8xHKgmN++uDJPt05E5elKgRYMRRvqUERplqowh47UXKM/eE1fLEjA9hxPz
IauJsRUAgMdnZv+Qtafim30o2JReUF8U9uZGPH3hqU37kZQ8fwG9eU2I6FzcBelH
XTukgFezHZ+HQrMqQphQOfxOqic/uF7TOUqunaOEr/jGxnILlNPTgDMW+zJWfGTd
ZsL4z1IqN/mrRF/+cVdWobTKp+tcK9GcP4VQVRNn3q42qRHfKJpQJguyTr4asdjS
21xxnovoGCvL0u+XNCCbGG+ep2BrH756wpd+/aKI43z0wvDk6jwmq3TiyqRL6aMu
xQGyktIXXY1Rvv3yyL1FYqTkJpOKeKEWJPsydv1bW5XKmk0vPOcwyZKetprZMwxO
twWqyiXnKyJmduDBN9yZBDGJBzqVBOPPnAHeNBgMGHeps7HLp8Y2nrlHet+CxqRz
chEjRfQbQkrMfiqRxxrL4zuMdLsNcDXrMabtGAji8Gk9kxkm/gHZvdpAoe98imug
Y10jeiRD4Eb6NV8Pre7GlP5BdJcFZ9yPdjnrTTCyj7/oMqOFA93vuEcb7ZK43XLp
53iuZuE+ocZxLxEsSBd+zeBDa7VWUYX3MTGcO4oxPWRjo8Uwv0Liy/GOARHqjrod
M1myJ0bt/ufZcCY1YANe
=fn1U
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Oct_2011_17_46_42_+1100_3_fgbSe_SSUwhtm0--
