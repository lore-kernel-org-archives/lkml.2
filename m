Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab2DJFLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 01:11:00 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55994 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2DJFK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 01:10:59 -0400
Date: Tue, 10 Apr 2012 13:01:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the regulator tree
Message-Id: <20120410130135.662efa37bb9072cbe6ed5f21@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Apr_2012_13_01_35_+1000_ast8iDtLg9oCgpIn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Apr_2012_13_01_35_+1000_ast8iDtLg9oCgpIn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the regulator tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/regulator/ab8500.c: In function 'ab8500_regulator_probe':
drivers/regulator/ab8500.c:783:9: error: invalid type argument of '->' (hav=
e 'struct regulator_config')
drivers/regulator/ab8500.c:784:9: error: invalid type argument of '->' (hav=
e 'struct regulator_config')
drivers/regulator/ab8500.c:785:9: error: invalid type argument of '->' (hav=
e 'struct regulator_config')

Caused by commit c172708d38a4 ("regulator: core: Use a struct to pass in
regulator runtime configuration").

I have used the regulator tree from next-20120405 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__10_Apr_2012_13_01_35_+1000_ast8iDtLg9oCgpIn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPg6KPAAoJEECxmPOUX5FEr7MP/2pTfByc4LmtAzlUiOCpeKXO
tlgNs8xrDv1d+jHGOmKjEok7TSINfFN8m4QDrWps6KIEIy67xTls5HnJOaZ3B7mv
f0mlkRk/txLH8FeNvJvUK884WE/UMS04l5BKm3j14G+ru1ySUB3nHpPOpYBmEXGk
hCicmsuhfuN8ASB5b4oYabF8cC6aBNYt4tUEK88xtzUyK8Bph+u4ITwvdWYJnkoE
BnJJNlV95OCtz18lAAebfe3kmDSm9su7OHC7gexmaNy+rUADEXyQ36hoaCaQ6lYy
9FRKTPerpr17+v2WvjZQbPcPeBS2ywAXIkrtQZ3LLKfBhjt36zUqLL06I0T2b9uV
XATeV39ezyMEhzKXEuV20zchhVQ/939j9FztB6QufrIwz9rgSe7UnTZrZQHWSwK9
spOXBXdcLKy2XFwACbL49xXU4CtzTSQJUjREUastFcOi7B04haEa/6shpoAdVDba
WgK2X/8S1jk2ZLYXzOZJ2GAKj62/5Lkym3SfFikAsSjbBr+g+7bWJmw3AbSdQBeQ
h0RHJvWKd7AcjfKqd6ai8e2arF1JUx0FM9UT0jbA/18Tau3MJR2QVEZlCxym1f9k
0k3fCWyp2fFnvdeGCNOVsfovuot35IqyBJhBGv6u9CBXeaPoS4QMKDGiXrlJk4cb
EQP6zzzcwnhWaQKZa9MI
=CdfS
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Apr_2012_13_01_35_+1000_ast8iDtLg9oCgpIn--
