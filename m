Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab0D3RCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:02:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59976 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932506Ab0D3RCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:02:33 -0400
Date: Fri, 30 Apr 2010 09:35:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>,
       Tomas Winkler <tomas.winkler@intel.com>
Subject: linux-next: build warning after merge of the driver-core.current
 tree
Message-Id: <20100430093534.9fc6ab8f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__30_Apr_2010_09_35_34_+1000_/ayvj170/D/9CpDO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Apr_2010_09_35_34_+1000_/ayvj170/D/9CpDO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

After merging the driver-core.current tree, today's linux-next build
(x86_64 allmodconfig) produced this warning:

drivers/base/firmware_class.c: In function 'release_firmware':
drivers/base/firmware_class.c:597: warning: passing argument 1 of 'firmware=
_free_data' discards qualifiers from pointer target type
drivers/base/firmware_class.c:133: note: expected 'struct firmware *' but a=
rgument is of type 'const struct firmware *'

Introduced by commit 6454d23dedf4019fcae868818ae63c755dd42be0
("firmware_class: fix memory leak - free allocated pages").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__30_Apr_2010_09_35_34_+1000_/ayvj170/D/9CpDO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvaF8YACgkQjjKRsyhoI8zBoQCdGwop4mPi9FxVd5pnQ4GEzVt3
PoMAn0B3/L+KSErb2aAe54O/BFv2AX00
=Nvqy
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Apr_2010_09_35_34_+1000_/ayvj170/D/9CpDO--
