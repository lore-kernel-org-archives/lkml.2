Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab1ELBme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 21:42:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43592 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab1ELBmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 21:42:32 -0400
Date: Thu, 12 May 2011 11:42:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Cardona <javier@cozybit.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: linux-next: manual merge of the wireless tree with Linus' tree
Message-Id: <20110512114223.ef04696e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__12_May_2011_11_42_23_+1000_1sUHDI7z=Yvkpnwm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_May_2011_11_42_23_+1000_1sUHDI7z=Yvkpnwm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
net/mac80211/sta_info.h between commit 25985edcedea ("Fix common
misspellings") from Linus' tree and commit 9c3990aaec0a ("nl80211: Let
userspace drive the peer link management states") from the wireless tree.

The latter removed the code updated by the former.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__12_May_2011_11_42_23_+1000_1sUHDI7z=Yvkpnwm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNyzr/AAoJEDMEi1NhKgbshgQH/iYXNNYel+cVP6dK+2eSNwwv
cSXwiupGPt1ki4sjgXI0suZhenCyzh+h71oXcTtWtkvTaTkbveqTHAGSmp/VeiMQ
3rUb7KqtO4kk6jws9MP2LeTGQA9iKL1WnLH50KfNke3/1rYqySb9fGj+lxOkrSBG
1Jpi2JNEKBRuu+oW7TjNP349pri3aHCv89YPLerjJmIoNwOagFgNCTtuhLfFsTIE
MGa9O0J8vZzZ5HjTeVzMu4dLyVSg1LKZ7LlVZer0MkcXFCv6QNf0hHbrxS5tL207
44ZLIpcDHQ3wUdddfwwaBuFevdR3+XY0ypkDtyEztd/6AKRl8ienFJ9Zt0N332o=
=WPQf
-----END PGP SIGNATURE-----

--Signature=_Thu__12_May_2011_11_42_23_+1000_1sUHDI7z=Yvkpnwm--
