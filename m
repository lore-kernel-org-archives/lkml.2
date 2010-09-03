Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab0ICBwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 21:52:33 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38098 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983Ab0ICBwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 21:52:31 -0400
Date: Fri, 3 Sep 2010 11:52:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Giuseppe CAVALLARO <peppe.cavallaro@st.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: linux-next: build failure after merge of the final tree (net
 tree related)
Message-Id: <20100903115226.52d0ccb3.sfr@canb.auug.org.au>
In-Reply-To: <20100903114750.3d8994b7.sfr@canb.auug.org.au>
References: <20100903114750.3d8994b7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__3_Sep_2010_11_52_26_+1000_o1TWxblW/af20o3o"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__3_Sep_2010_11_52_26_+1000_o1TWxblW/af20o3o
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 3 Sep 2010 11:47:50 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Exposed by commit ac75791aa943c7953521cb4fa7728bf51f9abd2d ("stmmac:
> remove dead option in the driver's Kconfig")  That allowed the driver to
> be built on a lot more platforms that previously.

That commit was the result of the only platform that this driver was ever
used on being removed by commit f96691872439ab2071171d4531c4a95b5d493ae5
("sh: Kill off the remaining ST40 cruft").  So maybe this driver should
actually be removed from the tree as well?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__3_Sep_2010_11_52_26_+1000_o1TWxblW/af20o3o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMgFTaAAoJEDMEi1NhKgbs1RIIAIN2P2kPzSeDQNrLQlf7Psp8
/WjhmyJoR889Qjl9ORbK2ji33tmSvGGoiakZQ3f1H/5x8l9ZGx0fP2Lm11quBI4I
01EOaXVhE7JHKY+ZqAQcUJdxhFkO4ZDBfSfCWIdnDgO94wrkkMacYXHU6xBWIUzk
Gw9rl+I7goRJT/uZBptnZGcQF76Z7eymiI5pLPiatsNXqTyn3rdL02VP8jGHm2dl
1b6qvyH6Fa9W8VFMgciM9tEOmpLwwmlegxDgVDUSDzgfT+azf2hBn6pinPPXipZf
3Mlnfcekci9Ziu8dZvSo4ZICa6DExll7FNomlm71tqVJ1Ro5rtSOXmXlu8nGLfU=
=szY4
-----END PGP SIGNATURE-----

--Signature=_Fri__3_Sep_2010_11_52_26_+1000_o1TWxblW/af20o3o--
