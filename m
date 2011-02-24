Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab1BXGYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 01:24:21 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51711 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab1BXGYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 01:24:19 -0500
Date: Thu, 24 Feb 2011 17:24:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: linux-next: build failure after merge of the final tree (wireless
 tree related)
Message-Id: <20110224172408.3cbecb03.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__24_Feb_2011_17_24_08_+1100_wWyJ.l7oZ9UROPEL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Feb_2011_17_24_08_+1100_wWyJ.l7oZ9UROPEL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c:701: error: __ksymtab__r=
tl92c_phy_txpwr_idx_to_dbm causes a section type conflict
drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c:701: error: __ksymtab__r=
tl92c_phy_txpwr_idx_to_dbm causes a section type conflict
drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c:677: error: __ksymtab__r=
tl92c_phy_dbm_to_txpwr_Idx causes a section type conflict
drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c:677: error: __ksymtab__r=
tl92c_phy_dbm_to_txpwr_Idx causes a section type conflict

Caused by applying EXPORT_SYMBOL to static symbols in commit
1472d3a87586eb7529d1d85f7c888055650b7208 ("rtlwifi: rtl8192ce: rtl8192cu:
Fix multiple def errors for allyesconfig build").

I have just left it for today (assuming it will be fixed soon).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__24_Feb_2011_17_24_08_+1100_wWyJ.l7oZ9UROPEL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNZfmIAAoJEDMEi1NhKgbscfoIAIbHnSWLUWsG8sMKKMyrA91l
n00RntCb4HHS688mkzbY8Rx9gYCQXbxANRZl3tfjWTfVN8SS+eFt68EBKgE9ZM3K
6DGx17xuiWWX8MAdcghxNUqLeTK0VAtkYuGA0JS8vYmfaBiVAqb9p94bjLYeOOql
vvAm1bfnnsZ2znuDB9JQ5xAlPdSpXxlp6qRU8Pd9iDOf5z/aMAuA7HzsXrbnWAli
/3EcG2qVfQ0wU/Ds89GIBacyGYXRJnSejMo2TQC4V+HRxRaNZFFQFHNJjqLXu8LL
W/zIll9dGL5Q+DGdUAvIycoIHxdLFrr5X6Ex/6XrCHU4mGmv3NUDhl6jU0zrhxg=
=Huxf
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Feb_2011_17_24_08_+1100_wWyJ.l7oZ9UROPEL--
