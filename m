Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab0IJA0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 20:26:33 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41015 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215Ab0IJA03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 20:26:29 -0400
Date: Fri, 10 Sep 2010 10:26:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: unable to fetch the mips tree
Message-Id: <20100910102614.61909592.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__10_Sep_2010_10_26_14_+1000_qZNySwfZ515c1mtb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__10_Sep_2010_10_26_14_+1000_qZNySwfZ515c1mtb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

For the last couple of days, I have been getting the following error when
trying to fetch mips tree:

git.linux-mips.org[0: 78.24.191.183]: errno=3DConnection refused

Just letting you know.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__10_Sep_2010_10_26_14_+1000_qZNySwfZ515c1mtb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMiXsmAAoJEDMEi1NhKgbs1uoH/ivYU61Ysg404wY3qgNho1QC
N5YTa94s9iVzGRf76+4qY5jDz9yowUaY5/uPGIno37nGi+/5enpZV6pBxj39njo6
ZOK9AeVW9Aqvhx1qJXfwPaQ/y6lrdg0thM0YLso7Wx9mn9qi2A8g+3NHmDwUpYuY
7hevPhIibxAP53vEWNp1VZ5MsEeIgseXeG562zZ/iVhIzA/tk/VCPfTB+VCRpFsm
HfgfA1QjTZB91Rimhu8E5HIUyjoHlyYzjlmW99bD1E/aS0ut9j1SCi9+j6MwgulX
NX5NBikLn0yWjOsu8fVLrBSb8q3FPVN/yFqybZolIwmUXBRPZwjn2COvGVGOaFg=
=oEug
-----END PGP SIGNATURE-----

--Signature=_Fri__10_Sep_2010_10_26_14_+1000_qZNySwfZ515c1mtb--
