Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab1D0BnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 21:43:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45820 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707Ab1D0BnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 21:43:15 -0400
Date: Wed, 27 Apr 2011 11:43:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Chaoming_Li <chaoming_li@realsil.com.cn>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: manual merge of the trivial tree with the wireless tree
Message-Id: <20110427114309.38d87c9d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__27_Apr_2011_11_43_09_+1000_bW2cOJn5yl=27.uQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_Apr_2011_11_43_09_+1000_bW2cOJn5yl=27.uQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
drivers/net/wireless/rtlwifi/pci.c between commit c7cfe38ee0f9 ("rtlwifi:
Convert pci routines for addition of rtl8192se and rtl8192de") from the
wireless tree and commit 6eab04a87677 ("treewide: remove extra
semicolons") from the trivial tree.

The former removed the code that the latter fixed.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__27_Apr_2011_11_43_09_+1000_bW2cOJn5yl=27.uQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNt3StAAoJEDMEi1NhKgbsIEIH/0ImiL/K6zc03P+e7PqqZ3Wi
eI0LHusRqWI8aQl3wqq+w3P0hreKi/mifRrjp5Z7jcogSHiksXxnWtVHNzv7QQcl
73Z6ixwYEnTq2XBCo4Bnqum4hj+Ut+GvrcZDTkdc0SUC9LNV65elowhVKtIaknWk
ibePcx4fOFh/Gu5wUuoCqLxN19nyMQ+zbFDiEjwXw5hwD940nJgdnfQJmaYFmYVS
ruuveR+J9h4rjD4WcL3tnEKhE8Hh3t18UTThZ01vfY4SMoGEhXySaTsifiN7iMX/
9JtI1H3pfv3kiCA80s4qKgdazedQztHwRAZ1x2wGde/81fZFErV7uAMhA3CBR1E=
=isI4
-----END PGP SIGNATURE-----

--Signature=_Wed__27_Apr_2011_11_43_09_+1000_bW2cOJn5yl=27.uQ--
