Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab2IDCEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 22:04:40 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39337 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580Ab2IDCEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 22:04:39 -0400
Date: Tue, 4 Sep 2012 12:04:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <jiang.liu@huawei.com>
Subject: linux-next: manual merge of the pci tree with Linus' tree
Message-Id: <20120904120436.8a7371f79bb68dee7d38ad8b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Sep_2012_12_04_36_+1000_zzD6MWrhCb6cJETf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Sep_2012_12_04_36_+1000_zzD6MWrhCb6cJETf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bjorn,

Today's linux-next merge of the pci tree got a conflict in
drivers/rapidio/devices/tsi721.c between commit 9a9a9a7adafe
("rapidio/tsi721: fix unused variable compiler warning") from Linus' tree
and commit 5cdaaf8a11ba ("rapdio/tsi721: Use PCI Express Capability
accessors") from the pci tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/rapidio/devices/tsi721.c
index 5d44252,fc22b93..0000000
--- a/drivers/rapidio/devices/tsi721.c
+++ b/drivers/rapidio/devices/tsi721.c
@@@ -2219,9 -2212,8 +2219,7 @@@ static int __devinit tsi721_probe(struc
  				  const struct pci_device_id *id)
  {
  	struct tsi721_device *priv;
- 	int cap;
 -	int i;
  	int err;
- 	u32 regval;
 =20
  	priv =3D kzalloc(sizeof(struct tsi721_device), GFP_KERNEL);
  	if (priv =3D=3D NULL) {

--Signature=_Tue__4_Sep_2012_12_04_36_+1000_zzD6MWrhCb6cJETf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQRWG0AAoJEECxmPOUX5FELlQQAJ5ogxoHMiL/xNH/ghcaKfn3
qX8r6KFbr6FzzCv8ESkEdOmqEQh3RMS2wj/WhxRdgeg1/F7frPfJKWK1NTkp+iF4
o6MbsGpgZDpkTwFgSCS4EsnkmNTdAWVXSaOJ96g35JvsHMGlvo0l6r6Kn4O+jC7o
u8jlg4Hmh4neXYej+2NWqdsc0XZ6M1olbZGJaxvhhntawVfJilfOPjw0/jzD1cm9
+PE/RaPWyDwWMme7EWIYx7WZV0laQZrhHkmOo9RhuEst6W5IcCGKAGLZy7OObELr
H6/FROspKaUHTv3tEER6pO19ufy73da3LOLYLpnApkMkPru59SHVBoA04yHAx6Vi
P4NztTAp3SdCpjo1LDFyt5GGM5t6xkjTM2YYtyFjDbAThKBM2oyHB+MWfSCSqyCL
Wg7p17Ne3JYbf7dGtPq7j8uMHAQmKn4uWEZFgzHppxxaJqWvwsoRmCNaBDJqIC65
AggJxtxW9eU2U1WK/V7Jxdvso8JAdMVT4r/Qh2Bfj+i1JvY8UNxTDHSjl+JmgrzS
v1ooACbVpaBxlQ1Q/U8tbNK8fEDNULEZzb+uc24IHYolHBU9735bzLsMPzQ5BkpX
J1TMGy/URpo08xPH280njhefGE88EKpy0dibZO0B9zeBj3t4g8fwdpkI6mHzh4ph
WDE4lNc8rTHnHArQVTBP
=tviY
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Sep_2012_12_04_36_+1000_zzD6MWrhCb6cJETf--
