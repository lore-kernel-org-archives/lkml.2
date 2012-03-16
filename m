Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161886Ab2CPB6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 21:58:16 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59598 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab2CPB6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 21:58:13 -0400
Date: Fri, 16 Mar 2012 12:58:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, David Miller <davem@davemloft.net>,
        <netdev@vger.kernel.org>, Sujith Manoharan <c_manoha@qca.qualcomm.com>
Subject: linux-next: manual merge of the wireless-next tree with the
 net-next tree
Message-Id: <20120316125802.195a7ffcbcb0c3fd666d3257@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__16_Mar_2012_12_58_02_+1100_dtx+VDHKtpYrPzhP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Mar_2012_12_58_02_+1100_dtx+VDHKtpYrPzhP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless-next tree got a conflict in
drivers/net/wireless/ath/ath9k/hw.c between commit 23677ce3172f
("drivers/net: Remove boolean comparisons to true/false") from the
net-next tree and commit caed6579c2f9 ("ath9k_hw: Cleanup
FastChannelChange") from the wireless-next tree.

The latter commit included the fix from the former, so I just used the
latter.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__16_Mar_2012_12_58_02_+1100_dtx+VDHKtpYrPzhP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYp4qAAoJEECxmPOUX5FETuYQAKIrk21qqOlkinZBYj4HnVZr
eMpy525zdXpP5IjlXKac7By5QJ9m2rq3l0JLfP6oj4PDMwoIIzCIVKw310lFhyxh
HSk2qDDmOai1d+2BqizCgPitEWWfmH5rzO3s59F8kN2rrsi95K5thczmqh6yBp93
xV21FHdbXWsccFb5RKwp/BuMnH9+3u5DeaW+hRqZEVBcJ4bvPlY+Oe0UjGccseJd
+2QsJI54Od1huKVWm8dMdflF6GQcLWyZDFCSjF1Ncjy1C81HoCi6NiIabnFImth5
aim/3Nohnlr0kFQGEWWx6yKtaBryHFkWp5KJO8Bh1KD7TtF5bbZuMYZNq+d6Y9nF
maz+cENC28h8knA7qvJJUoQNni/3arzFJT3gO7jhNHMH2BJ+Wudx/ggiFagZNeAV
QB8SVjnyMQEiZMUWFrR2HZIfrdsxWGFhACHM7DuGrFu1oVFYW0YoCP43BUuLp0hD
ddz8kMTh2BkENI511ub4bii8kIrPxpwGq9qMLpk34HE2+V5ZeRirGapS8qdMqMGq
KlZSgEi7DgTi0+bmxZ/KfgbCdJ0aG0PKXZqt56alzK9AjCW+iNxBTf3WoTv8Pnsm
8BSimen7pyDW5AtS3BX+pVg3Dgm+gSnNohORzGN7UQeC3CZcZ1iURCoZFuKHmSS/
I64ywwcC6CXjGoZ97weB
=52PI
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Mar_2012_12_58_02_+1100_dtx+VDHKtpYrPzhP--
