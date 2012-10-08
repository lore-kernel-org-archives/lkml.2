Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab2JHXSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 19:18:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44374 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab2JHXSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 19:18:03 -0400
Date: Tue, 9 Oct 2012 10:17:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dong Aisheng <dong.aisheng@linaro.org>
Subject: linux-next: long standing commit in devicetree-current tree
Message-Id: <20121009101753.8f0e0ae7293b76c1c3794c18@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__9_Oct_2012_10_17_53_+1100_3CNp7tWCi=dFsb0="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Oct_2012_10_17_53_+1100_3CNp7tWCi=dFsb0=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

The devicetree-current tree has one commit in it:

4e8383b6b06b	of: release node fix for of_parse_phandle_with_args

It has been there since May 26.  Just wondering if it is going anywhere?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__9_Oct_2012_10_17_53_+1100_3CNp7tWCi=dFsb0=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQc18hAAoJEECxmPOUX5FEYFAP/AkWxHjPnRecrvldXXp6fJY8
0IWlRSByT0SnI9c7aJSPMnyyyTG8jrOUfCep3tsIh8Tt4zGzJcW1VavTKPsyznLy
VTcya9HkN2fORMBGbRImP7PfRJk/3RAONdfDUQZh8XxwzTysYijcio4Clht5Y8bE
yYSjlaokVaINYbSFSTYbRgYoPPLn2V8M720bSfYtTQzo2C5UWxzAHzJ7HmSndbal
Ff1D6xGqF8u+jT8n61VbVDRJwO43dIStUHTjNABJ+c9QMNQwy8mDoOm9JjYebdjJ
DxN+DofSWvsC54TkHQghPrxdhCEJYRu7v1vZ0irWX918MjZH7dBdgi3lEpPPCG2D
bvzfMMi7mHakmhzajig3z9gMi1W5NF0QpT7E67huvF6a29aGeo03+ECt6t5zpeOr
H46sQ+CFP+SiY7G55aD3qBj/G3XfCd7uiII82QVnMqt5qii9FnFUpY0OkeUtXqeU
aICFRylolrKWC0+NFiF/raqLeH7H1/epU22bdN6hy+7ImGqCWtT7lodd61gEaGs3
WbnV/tPed1JTTrjNslijBfh2lqJHdt81Va5Ybxnq7XaP7gBXUH3H2cQL/pvOVLkp
VQV07xxiO1eWUTsl9jPz/0JP7d/6XeYxbh/l/6c68vqkhur6vEZKnDmuU/VrxLCI
/3t/4g1H9VrGOKfQArdD
=1//9
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Oct_2012_10_17_53_+1100_3CNp7tWCi=dFsb0=--
