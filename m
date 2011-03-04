Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931Ab1CDE6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 23:58:10 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47973 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758483Ab1CDE6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 23:58:09 -0500
Date: Fri, 4 Mar 2011 15:58:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Zhao <richard.zhao@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: linux-next: manual merge of the usb tree with the i.MX tree
Message-Id: <20110304155800.b48993d7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__4_Mar_2011_15_58_00_+1100_ZNkDYleLJkHWrzVO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__4_Mar_2011_15_58_00_+1100_ZNkDYleLJkHWrzVO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/gadget/fsl_mxc_udc.c between commit
4d2f13be1e370a670c1cae20c194d5ce961e0fa5 ("ARM: imx3x: clean up
ARCH_MX3X") from the i.MX tree and commit
a51ea8cc9cfcfd719240455ff8f217b4f165d1d0 ("usb: gadget/fsl_mxc_udc:
Detect the CPU type in run-time") from the usb tree.

The latter is a superset of the former, so I used that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__4_Mar_2011_15_58_00_+1100_ZNkDYleLJkHWrzVO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNcHFYAAoJEDMEi1NhKgbsiNoH/iwt1PKuLmyEDxRZBiTQ02Or
PwRKPLnDMjL9Zzf+YONGTyG8an8Vk4sBNiGNVNxjClmF1jYhwgi6uBMok1spa7A6
E1AUqDXTRI2nENIMcJUtiiwbGyDzX2pVjn4+JZyiKIaEI1ORmO9KVo+pKykGGna6
RdPh7Vh42FVpcDbA9oa8aRrK44BqvYkmz9yUZq070s/Jxz98E6SIea0S3UFLTJ5+
XAAybcrkSMQmKeVMGJbtF4fekkGGGggty53/Ayu9mdDpx1icLzdaHuOS4kSmKwMp
YGdKExkGtUsvQFn1up4Of6f06X0USakn48PGZkNBhR+l1voKZkNuYTJfg7u2fnE=
=aVN7
-----END PGP SIGNATURE-----

--Signature=_Fri__4_Mar_2011_15_58_00_+1100_ZNkDYleLJkHWrzVO--
