Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab2GaB7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 21:59:04 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48046 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab2GaB7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 21:59:03 -0400
Date: Tue, 31 Jul 2012 11:58:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sage Weil <sage@newdream.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Elder <elder@inktank.com>
Subject: linux-next: manual merge of the ceph tree with Linus' tree
Message-Id: <20120731115853.a642cbd22bddb96f667520d1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__31_Jul_2012_11_58_53_+1000_wYdTEsOSu=D1+LUR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__31_Jul_2012_11_58_53_+1000_wYdTEsOSu=D1+LUR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sage,

Today's linux-next merge of the ceph tree got a conflict in
net/ceph/messenger.c between commit 5bdca4e0768d ("libceph: fix messenger
retry") from Linus' tree and commit ab166d5aa3bc ("libceph: separate
banner and connect writes") from the ceph tree.

I fixed it up (removed the calls to ceph_con_out_kvec_reset()) and can
carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__31_Jul_2012_11_58_53_+1000_wYdTEsOSu=D1+LUR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQFzvdAAoJEECxmPOUX5FEeUQP/Az9+hMxPhQVnETe1SB7KAFi
jNu+5vm7aF/m2p4qUmu6Qqy9ozHMKK3lmOWN9CAOA5ghc5uM3unS7npaY4CGLp0h
Erxw5+lGdyrtDudYEbHbfa+WuV1TTthe+srRchxw5tw877xQDSh4D4oXji8AbstJ
4n+WN0QrzyHLcVeWamD49cSJjMcZ4iCg0rM/mn+4VN1z+DD7S5yR2CiTdu+Rt0Jl
bTaAVJ16PAua32lfMhe8+kKInV3Z77juAJ6/gk4+wsOaE8BfyHSgr3X9mrMfrtz2
Q8YRhlAYVrjNRpmry1bA1s9vGzQzKko46KfWaeCVtkOIgjeshZ3+yu2OVPOhu6a4
3PJ3C39VGnZBD2UpeDncjZD9io38vLduHtxEbDo/wy+CJZVfP/vuQu0GDh2bTbfo
BWG/gQEjMSBphtctpo0aQV6UKERTbw6QvAkGLG9qpiOmqFD5c5NdF45IegP5B9OG
uFG9StQVCTJCSH9PN8ZApxb9o/FJaxwzL341wSwgCcvic2vwQw1Y56Ek7WKj1ccy
ntTbNuyiTZ242rV75hQqzLxrNd/CKgpCSJowv1F09s910IaPwyhFldJ8wGI0WRL3
w4WKdqTI/16BER6hfibK0ZFSUTNteao1iOAlQ81p5Gn1fs3GBZU8hBJbqcEj3EYZ
B9a+f9ZWH0bPS6zu70bu
=9rxo
-----END PGP SIGNATURE-----

--Signature=_Tue__31_Jul_2012_11_58_53_+1000_wYdTEsOSu=D1+LUR--
