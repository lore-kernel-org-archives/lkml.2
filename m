Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab0LPDBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 22:01:31 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49863 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284Ab0LPDBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 22:01:30 -0500
Date: Thu, 16 Dec 2010 14:01:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bob Liu <lliubbo@gmail.com>, Mike Frysinger <vapier.adi@gmail.com>,
        Felipe Balbi <balbi@ti.com>
Subject: linux-next: manual merge of the usb tree with Linus' tree
Message-Id: <20101216140122.ca745f1f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__16_Dec_2010_14_01_22_+1100_WH_lfQTTF8NR3q1/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Dec_2010_14_01_22_+1100_WH_lfQTTF8NR3q1/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/musb/blackfin.c drivers/usb/musb/musb_core.c
drivers/usb/musb/musb_core.h between commit
1e393c6eece048052d4131ec4dad3b98e35a98e2 ("USB: musb: blackfin: pm: make
it work") from Linus' tree (v2.6.37-rc2) and various commits from the usb
tree.

It was not immediately obvious how to fix these up, so I just used the
versions from the usb tree.  This may not be correct and it would be good
if this was fixed properly in the usb tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__16_Dec_2010_14_01_22_+1100_WH_lfQTTF8NR3q1/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNCYECAAoJEDMEi1NhKgbscIYH/jscsxlLjzhjvND+qOAOJACS
+KJfR4GEGn9UqMSTOAjTP/qsU+jcM5cdqplgizfDRYjTvWhn2ZmCyNlCLyQ4sX5l
6t9D1hpLthPBBWBga4sI+UfKYaO02xHCsjoUv1mWsGGvGycwITWAjrldF3tN5avH
IdDWjBXsGyvHDGn+F/H7PXFsCG3usk+ID3zp/dB62+7P7TWEDmpf8nUCCAiGSh3x
9opuKRRKN8yOyI7SCaJW4TVFMp4zV5h/BdzCwe4gqo+HUt2jpw9s+Biu8X1W+RH0
CCv2otZyNRnOUemOeVjujzVdSXXBwGw5AoEQII6w0Mi5u48weN5hV9JNwA+Is7c=
=C0xv
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Dec_2010_14_01_22_+1100_WH_lfQTTF8NR3q1/--
