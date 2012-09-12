Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab2ILFhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 01:37:55 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:32965 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab2ILFhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 01:37:53 -0400
Date: Wed, 12 Sep 2012 15:37:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>, Felipe Balbi <balbi@ti.com>,
        Ravi Babu <ravibabu@ti.com>, Ajay Kumar Gupta <ajay.gupta@ti.com>,
        "Santhapuri, Damodar" <damodar.santhapuri@ti.com>
Subject: linux-next: manual merge of the usb tree with the usb.current tree
Message-Id: <20120912153743.5c209bd50317bb1a878eb10c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__12_Sep_2012_15_37_43_+1000_wYSBTSdDSXVHBik."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Sep_2012_15_37_43_+1000_wYSBTSdDSXVHBik.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/musb/tusb6010.c between commit ff41aaa3b6c1 ("usb: musb:
tusb6010: fix error path in tusb_probe()") from the usb.current tree and
commit 65b3d52d02a5 ("usb: musb: add musb_ida for multi instance
support") from the usb tree.

They both updated the same goto - I used the latter (no action is
required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__12_Sep_2012_15_37_43_+1000_wYSBTSdDSXVHBik.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQUB+nAAoJEECxmPOUX5FEP5AQAKHrczSK6qZMjHHAHYN+ckOF
cknESvwLh0Rd6PWsMG9KcpQEw9bFWsQ3Fp7CCdv/nvn9QH60zyy3+vVahHoeWzvG
quCwO6YcNByJ6LIjlFSQjoX9HSkFOmRJv8Y1YaBMUTAxqNVT65SKEHBmq+BznuPE
SxKyOdICfWlbg4ZRdXi+XQI86tQjrdrJJ5cP8ZXR8GOaYEZ60fJ5P4lpgNpr8Vji
cV0tYaFxQqqtf3sa8rqXgSUWM08tgRaRgVw3Mbh6qFHPFoMNHtXpieQr2ls88b0R
R05J9zbxnTXSmYm+CiLd8/x0zKJmvmRqcOIBpbGVGVB3K7kwKAd6FmrUy5LxXj9r
43R6KTOtisOcNeUVoRAqqzRJRROZPhp3iQ8/3ml0HLAi+5s7SWCHy2W4FH5fpqxB
ZtwjaSHik4BZU/C3WeG2HOFEOZsk1lUbbsMhqPolc8AwvdUtq+Qn/eSoc0nHy1sD
MzLK/aLKcKxkt850aTzo1LsVhNj2JHUqEeO4K+2O8Ylu8hYEy1+D0noR6isCBn2O
z50ZJpEzgGaS3O7aHbIVGGB5XhDZCTjzK99u9K/OcVpz/5EZJevGSnfo5PhEj9Zo
iTDywwa/49bDWjLqKf4hPQOwlN/8e3DU23r8xlQEz//o7dCSCl+1xGAbgMJYLu7G
aoRU9Q8odyfja7z3oNHi
=5Ytk
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Sep_2012_15_37_43_+1000_wYSBTSdDSXVHBik.--
