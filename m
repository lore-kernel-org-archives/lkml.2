Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab1LTCSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 21:18:13 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:57753 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab1LTCSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 21:18:12 -0500
Date: Tue, 20 Dec 2011 13:18:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zefir Kurtisi <zefir.kurtisi@neratec.com>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: linux-next: build failure after merge of the wireless-next tree
Message-Id: <20111220131802.e3782dfbf8172281a7df5a5c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__20_Dec_2011_13_18_02_+1100__gkaBSMz4Onyt8A_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__20_Dec_2011_13_18_02_+1100__gkaBSMz4Onyt8A_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

After merging the wireless-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/net/wireless/ath/ath9k/dfs.c: In function 'ath9k_postprocess_radar_=
event':
drivers/net/wireless/ath/ath9k/dfs.c:73:1: error: 'ATH_DBG_ATH_DBG_DFS' und=
eclared (first use in this function)
drivers/net/wireless/ath/ath9k/dfs.c: In function 'ath9k_dfs_process_phyerr=
':
drivers/net/wireless/ath/ath9k/dfs.c:166:1: error: 'ATH_DBG_ATH_DBG_DFS' un=
declared (first use in this function)

Caused by commit 29942bc12537 ("ath9k: add DFS radar pulse processing").
ath_dbg prepends ATH_DBG_ to its second argument.

I have used the wireless-next tree from next-20111219 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__20_Dec_2011_13_18_02_+1100__gkaBSMz4Onyt8A_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO7/BaAAoJEECxmPOUX5FEzLMQAJo6USdgdFiAV/vr3UUzfmgX
MhFTTfopVBjSIhBDVqwiStKYGnzml4ycubcgDyIsAcuCosqh4vPKHVYwAPCjLW/F
TZaWnDF66x56/T8yodT8Qm+8BWF46cFySl1ezYi2L9bIoiG1kG7aZ0pi1bZMr+PY
9sA5BWl159fXCS557zvtkvLFAVvU6dSW75JYbfSAnlsWKqLSU8ecqXy+0vaAAM6O
AznT3jANiZEY3MUzRypSPMvAxFjZArGWpKd6NRkG4ftWgsKAEhKwMS4HN7C4qDnD
2goUh+2moXi/DlzYyFXA5X9BRWnIokPyPq2gp8KL774L4PTwU3u6Or1RPx/OFOFR
8Sihq94MX3N2S1Mo/TnO2vy5PxGGsovwL0ObPyG9+rvVTOFyAT+IBpSAUi7LB2uf
AgunhNVLi1n1N9MqZEImg6EI3EsW1mOr8novzfv/Xkt0ldxnbCiKXUYBnu/wftFi
e1MesjhYrwMqWR1FeQPOFsetHIpUaSYvILt66tQalf17XevISna8x3cg5LIcDMdg
IVpAt5UJcz9E8BxT3gjfd6iT1f6hF/B+xc3eQomYbg15UgXGsFsk5pqGc9MXu135
lGGb82r25B4z1rGA8/BTJeHuYCe2KmXxYjqk2RaCvo7dxzFpPhQw8WLnZeC7U/QQ
G/pxuCwLetxaEq4wIysI
=BZqK
-----END PGP SIGNATURE-----

--Signature=_Tue__20_Dec_2011_13_18_02_+1100__gkaBSMz4Onyt8A_--
