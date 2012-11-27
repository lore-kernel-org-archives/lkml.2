Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab2K0XQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 18:16:48 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60161 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756452Ab2K0XQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 18:16:43 -0500
Date: Wed, 28 Nov 2012 10:16:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: linux-next: unusual update of the security tree
Message-Id: <20121128101635.d5e864dffc4252ef9d5e1664@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Nov_2012_10_16_35_+1100_x/CrMB83g6JqjlGD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Nov_2012_10_16_35_+1100_x/CrMB83g6JqjlGD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

The security tree
(git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git#n=
ext)
looks a bit strange today ... It appears to have been created by Casey
Schaufler (cc'd) and contains some quite old commits and back merges of
your tree.  I *guess* you have merged in Casey's tree after he merged in
your tree from yesterday.

Just for your consideration.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__28_Nov_2012_10_16_35_+1100_x/CrMB83g6JqjlGD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtUnTAAoJEECxmPOUX5FEIzIP/Rfw6PZc3YZ8L7AIGc2MwHsB
XZHeuEKNBtYjlJlcI79Vj7Or8sA90u7g0Sg5AfIt8pTTdK0ejakeUaoDT+bd2w2p
AaRZQBboMUS9jPPAQ+Bk3NAisjwkCgF26nbEaf887Lg50Sbh9/33uyc9PQrxPe2a
45OrvFixtJEobzWUx/cyoHWx+7TQDo0PBTKM432MDjtJJsQCypx2YYwEl/s3impI
9XGAODFrCsdJzODoWYYxZFcpxD6yM68knVQMUIm7408wVHj2XuYEA1C5UC+Rfrxb
l6+SIcv2T3UFOdRpMb2y81Pp885IP6RRoHZ+bfUB57r6KnfPcdrqIi8QZ5j0h9D5
2Mw6a+EUfWArE+O34r4NrpCIMFV6Kf+bQhZkC+CLzJ4Q56/3kn/f4jM04jyJyxs7
tsUQefckVg6C8fFearo71LTn7pvzyDeelf3NoddM+sqFNzL5fkcl00/n9xeAhSBK
osUxZ/ufGUgJ9apR7HGgSqV7q77Hm8EDZurY0RhmRER81xV7ltwrSNbXJDQKg61q
KVhZZ5tQxVInt6UewkdHkN+TGskvvaOAkUrby19QzKREYY9m09ObyMFLM2whfn5H
Da7TSFE3eJ24ti/Wz+aToZ9WwMRgRjY15o+gdVJ5bBJNGIJbkKteQSgH75R8lScs
2vnitH9fRgN6475kQOgB
=sf22
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Nov_2012_10_16_35_+1100_x/CrMB83g6JqjlGD--
