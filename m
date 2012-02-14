Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab2BNAyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 19:54:37 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:36361 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab2BNAyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 19:54:36 -0500
Date: Tue, 14 Feb 2012 11:54:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Evgeniy Polyakov <zbr@ioremap.net>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the vfs tree with Linus' tree
Message-Id: <20120214115419.f4b1300a82ef7e94c450ecb1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__14_Feb_2012_11_54_19_+1100_=jjvkfTnwwcE.ZCO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Feb_2012_11_54_19_+1100_=jjvkfTnwwcE.ZCO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
drivers/staging/pohmelfs/inode.c between commit 67435319866f ("staging:
pohmelfs: remove drivers/staging/pohmelfs") from Linus' tree and commit
044ff9e29029 ("switch open-coded instances of d_make_root() to new
helper") from the vfs tree.

The former just removes this file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__14_Feb_2012_11_54_19_+1100_=jjvkfTnwwcE.ZCO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPObC7AAoJEECxmPOUX5FEyNUQAJqUgztCYgMu5BZQkbZoEeld
7O+hor3n19KBCkHle3UjRYZVli8AQNCcRNngqsJVqURlakC4jLgUhrOxxXaAtiVF
Gk78bMHxTFASfa4lMg9TiBtyG/hc2GbccvktwUzM5AtnViHCySxBw8jq0ShLGDqG
FF53r2eUeb9Jxh+wlKtJqe6YTlX/+sjoRr5w47jqx4HGlt3AbI7XCqig9KbTBO5o
zeyaVuAlQ8ud2lWwEYxHL0xpBAm6548asQJmyPb9IzbPYNPUJdMkLg9E8bqrp/W1
adcdrJOApVUnQU+fVnonvtepYHE4di5IypAXbhYkrKWnc/b1wBgTkd5hi4rTa46S
UPUZXEgEPGJq8HIPSEayeQxrZ1hcjGXHU4alx4EDpTKdNTA6olj+Bsc/j91ledHk
N5L3lksRWqWKChil46LH0FXohh7q3O9+D2vPi0mU8YDU3C+iQIz4o4qxstcZqm6F
beadX/TM1eFdLpkJ+/8koEXw79EYbWNkBxrXmoCRjOqMPQqpY6y32VGI+cBEkMmM
tJRWRD8YSHpVs48mdODLDSZyDfSZj6AsBSmOII7nhp65ayGfY2lN50vdKW1i1NDg
9m8c0E55HSS0HYTlgjhfud8VkCO7o6MeIkCMC1hlC+yu81MUktI3plHHHv1oDiKB
Gh3dvANJ+OkEdV6W6HxZ
=AnFK
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Feb_2012_11_54_19_+1100_=jjvkfTnwwcE.ZCO--
