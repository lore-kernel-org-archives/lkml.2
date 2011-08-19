Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab1HSA76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 20:59:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34370 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890Ab1HSA75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 20:59:57 -0400
Date: Fri, 19 Aug 2011 10:59:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Pirko <jpirko@redhat.com>, David Miller <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: linux-next: manual merge of the wireless tree with the net tree
Message-Id: <20110819105946.a46aa8a997f466d8a2e7f2f3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__19_Aug_2011_10_59_46_+1000_3TWA2cR.Qq.Q7=VJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__19_Aug_2011_10_59_46_+1000_3TWA2cR.Qq.Q7=VJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/staging/ath6kl/os/linux/ar6000_drv.c between commit afc4b13df143
("net: remove use of ndo_set_multicast_list in drivers") from the net
tree and commit af2bf4b4ee58 ("staging: remove ath6kl") from the wireless
tree.

I just removed the file.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__19_Aug_2011_10_59_46_+1000_3TWA2cR.Qq.Q7=VJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOTbWCAAoJEDMEi1NhKgbsSGcH/3cyiezvgd2uvLSO2JICN5+w
cNoFte40/9NxTDNxVmALuqWSCcKd/UjUXRgxb9Y7xAd1wwlMfayCq1Yb6VgO6yE3
9l9BY2kjOm/dv3fZbwpUwVhQhvKc3ODSQCI+ZJRylsUZBuXir+O16I5NuDXi9/t+
pYDTnRoGNxT9R0EhAyBveuBuWiTl8tm/ZUbD2/HzYAXrY7Lgeb8rI/6Y/K8LMQBr
Kih2oALEcSe57CPRrWqwIPfJUP5pGqLL883UJxgdTFzjsY8r/CVRrcT9OFIZipQd
rbQY5RtofbsGlFA3lQHvyvvHLbIxFULviJt60Q9B75HMIPvVyHtXgEzdIGX5enQ=
=nNmG
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Aug_2011_10_59_46_+1000_3TWA2cR.Qq.Q7=VJ--
