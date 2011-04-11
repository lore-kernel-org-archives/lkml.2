Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab1DKD2z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 23:28:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56586 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab1DKD2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 23:28:54 -0400
Date: Mon, 11 Apr 2011 13:28:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: linux-next: manual merge of the trivial tree with the wireless tree
Message-Id: <20110411132844.fa651c08.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__11_Apr_2011_13_28_44_+1000_PtOqsB98cWLRl+_L"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__11_Apr_2011_13_28_44_+1000_PtOqsB98cWLRl+_L
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
drivers/net/wireless/ath/ath9k/phy.h between commit a9b6b2569cf1
("ath9k_hw: turn a few big macros into functions") from the wireless tree
and commit 6eab04a87677 ("treewide: remove extra semicolons") from the
trivial tree.

The former commit removed the code that the latter changed, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__11_Apr_2011_13_28_44_+1000_PtOqsB98cWLRl+_L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNonVsAAoJEDMEi1NhKgbsy0oH/2AN/lJsLYU+0/q1BYe6Mjei
zl3FrT33okrsu/XsdoPhsnNgAnZWQVs4cVd6FALYoBw54EQBrd3bAOr3Mr+EHhdO
qgvLxGvN2UFrWnGnY6KRFOOaVSuq44zf/N3Tyyzs1YAmxGpxT7iZKj+OqjaUzA0v
JC8PdiwR5g4EKdl42urYFCBogHuzOJjb5D/TP/oe/ovIsZQxD5f0BFN1a/V8sGP1
kS+CKl79xAOiunf1uzQDTs0/z51vDHlWPZM9D5puTZeaBRB0ArLBei0ZAqJwdzWQ
gWkGwfhB9JdxEUz5DMo3h8YLFMH1TG1nh62Scbojx4X/mLn5Uy3s97vqkDlkrJ4=
=b2BD
-----END PGP SIGNATURE-----

--Signature=_Mon__11_Apr_2011_13_28_44_+1000_PtOqsB98cWLRl+_L--
