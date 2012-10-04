Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab2JDCVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 22:21:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39870 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab2JDCV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 22:21:28 -0400
Date: Thu, 4 Oct 2012 12:21:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Martin Peres <martin.peres@labri.fr>,
        Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>
Subject: linux-next: manual merge of the drm tree with the  tree
Message-Id: <20121004122125.a501fc314016f967fd914c55@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Oct_2012_12_21_25_+1000_brN3boo0ORNYiYdE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Oct_2012_12_21_25_+1000_brN3boo0ORNYiYdE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/nouveau (lots of files) between commit 760285e7e7ab
("UAPI: (Scripted) Convert #include "..." to #include <path/...> in
drivers/gpu/") from Linus' tree and various commits from the drm tree.

There is a large reorganisation under drivers/gpu/nouveau in the drm
tree (which only appeared in linux-next today :-().

I used the drm tree versions of the files and but this needs to be done
properly.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__4_Oct_2012_12_21_25_+1000_brN3boo0ORNYiYdE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQbPKlAAoJEECxmPOUX5FEhwwP/1xiKS+q3EDhaBCr1K4VyXpI
vQ0stHrQS6wre3ilYBQKNmpSmder4TRqLqp+7YREzz6siPqcn5RUBhsA4k9oroTk
NAY2CcJNHXj78m/M/gHcoe7CfrOt/UaL47yOPj5zN6YSyJvgxyrSkvQatf5ooGG9
kYF5Fi8G7Nwc9qmSTPp5vACIP66cUy/hY9G2b9P68sUERFbTTx0WM4T1CPI3lSWe
JYyzKwfvIi96ZRkfDRjKR3EHTAb9UoiPqOaEy/WPUfcI7q4f+QiYLr50iLCpx+WS
YkMKf9ANcZEMrQIOxsWieT4dQW5vSsmA5A5IOyYh1IKAWyy/RPjCtZUEXQNy2gDy
SslkLUvHYISCOiEbS+EuRf+tZ9LAmIO1Sfhyx8BHV9YzoZdpt7wnPVpetyaaDGjt
SOji6kTZeZ8tL8++jjXWD+++Ck4O6fK2aX251UyQaVgkD//JOQP6XDBMPLUpH2Cr
M+8KXGofnDa3M/l6mOWjQSfYA9kMIPDl24Pkl+RFCJDz3IKEIZRxGN2zlXckcme9
Hkvj52U2Cvf/+VpkI4JE0b/lflHqWe/8R1bJ0eotAV8TVDI7w6SKamFnWDr9uNtx
pgQjdLOcT9NdpqkxDyJftv6cvgAavtFFowrV38qDNKEyNdw/uhkTF1mk1iTGd2Y5
3M9aFDvxNqRR1F0lnJ+i
=2Ah0
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Oct_2012_12_21_25_+1000_brN3boo0ORNYiYdE--
