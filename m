Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761580Ab2DLAcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 20:32:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44165 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374Ab2DLAcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 20:32:12 -0400
Date: Thu, 12 Apr 2012 10:31:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: Re: linux-next: build failure after merge of the final tree
 (devicetree tree related)
Message-Id: <20120412103157.70669ff82b81d5d926c36d4d@canb.auug.org.au>
In-Reply-To: <20120411151155.b1a614f174442a592d1c1561@canb.auug.org.au>
References: <20120411151155.b1a614f174442a592d1c1561@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__12_Apr_2012_10_31_57_+1000_YJCNiWmem=5aN819"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_Apr_2012_10_31_57_+1000_YJCNiWmem=5aN819
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

On Wed, 11 Apr 2012 15:11:55 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the final tree, today's linux-next build (sparc64 defconfig)
> failed like this:
>=20
> drivers/of/of_mdio.c: In function 'of_mdiobus_register':
> drivers/of/of_mdio.c:75:4: error: implicit declaration of function 'irq_o=
f_parse_and_map' [-Werror=3Dimplicit-function-declaration]
>=20
> Caused by commit e46c11b94787 ("of/irq: add empty irq_of_parse_and_map()
> for non-dt builds").  SPARC has CONFIG_OF but not CONFIG_OF_IRQ ...
>=20
> I have reverted that commit for today.

That commit is actually in the devicetree-current tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__12_Apr_2012_10_31_57_+1000_YJCNiWmem=5aN819
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPhiJ9AAoJEECxmPOUX5FEmJsQAI5pN5/0Nf+lfXJVdP3eZILZ
/T5lBJRLe5Lwf0JX4qzIarIZUdb+jCscqUCkHnlerk1kRk0jLHOATYsTR1r10xu5
JJPHQ3+LboV9qC2RYPoPbttS/zmwTbHjyG7xqcvmLIbZLv1xw6AjsL5ydMDcFnT/
bPQzlUZ3aDxWmgm/vmsFq/sQDC9j0WuRpVbBfZzyuaSOv/9P1vKz9LEbX4fkiNzG
hWc4SldFWxhP72piwOa+vUTUC87LtnWAWWeTeWIz+3aiWHXgvaX2o4/UsoCnh/3Z
eJe1pQuiZEJ2GsN9LcvwYQrdwgkRAuTV8uOOYXaPWM6ecF7WZ+vbNYMrcLfPDMlK
TiFtPoJdFs9STfoulsy131fFuMLiJkXmehi0ZHSA0VdBAm4oFkZYzvTl5eZ4tl4n
NiHqPLj/W//3TxnEytsNLqwfSNTlMB3VqDTYXfiitUYOFGPYfZlayzAt4/+uT3RN
z6I+ZCg5ffdBddYw66+8/V7A0yTcdwSLbeJmVVEltAy4Ycv9ZCzmUWUlK2JUyyqP
kyNogX2Pmsedkf9oSATRix1RfuevdvQwCF0pxZSkGyBgAvQqLM6wJfcxarZ6P7ES
jZw4zj4ZruiPREleU+elZREHBl3HA3Zc7qIosY43ilyMjryNdq8AgmRPF0pQx8Fc
EWck9uo1LqmQIk8iPhLS
=xlSJ
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Apr_2012_10_31_57_+1000_YJCNiWmem=5aN819--
