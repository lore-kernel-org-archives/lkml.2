Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab1HLBx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 21:53:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34948 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab1HLBx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 21:53:26 -0400
Date: Fri, 12 Aug 2011 11:53:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warnings after merge of the net tree
Message-Id: <20110812115319.c48966a412362f68c00c19dc@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__12_Aug_2011_11_53_19_+1000_5i4o4=G8APB099OD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Aug_2011_11_53_19_+1000_5i4o4=G8APB099OD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net tree, today's linux-next build (powerpc ppc64_defconf=
ig)
produced these new warnings:

warning: (SCSI_BNX2_ISCSI && SCSI_BNX2X_FCOE) selects CNIC which has unmet =
direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_BROADCOM && PCI)
warning: (SCSI_CXGB3_ISCSI) selects CHELSIO_T3 which has unmet direct depen=
dencies (NETDEVICES && ETHERNET && NET_VENDOR_CHELSIO && PCI && INET)
warning: (SCSI_CXGB4_ISCSI) selects CHELSIO_T4 which has unmet direct depen=
dencies (NETDEVICES && ETHERNET && NET_VENDOR_CHELSIO && PCI)
warning: (MLX4_INFINIBAND) selects MLX4_CORE which has unmet direct depende=
ncies (NETDEVICES && ETHERNET && NET_VENDOR_MELLANOX && PCI)
warning: (SCSI_BNX2_ISCSI && SCSI_BNX2X_FCOE) selects CNIC which has unmet =
direct dependencies (NETDEVICES && ETHERNET && NET_VENDOR_BROADCOM && PCI)
warning: (SCSI_CXGB3_ISCSI) selects CHELSIO_T3 which has unmet direct depen=
dencies (NETDEVICES && ETHERNET && NET_VENDOR_CHELSIO && PCI && INET)
warning: (SCSI_CXGB4_ISCSI) selects CHELSIO_T4 which has unmet direct depen=
dencies (NETDEVICES && ETHERNET && NET_VENDOR_CHELSIO && PCI)
warning: (MLX4_INFINIBAND) selects MLX4_CORE which has unmet direct depende=
ncies (NETDEVICES && ETHERNET && NET_VENDOR_MELLANOX && PCI)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__12_Aug_2011_11_53_19_+1000_5i4o4=G8APB099OD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJORIePAAoJEDMEi1NhKgbs3ioH/i6QNVtOno63uWdEM9YOmNqn
oEqIn5l9P+i0zMCvZYIWtrsIyvQu6Uig2y6pkFxyQft8UhqiEUxNVrdKtYRHo5j7
jdy0BXUEEjEQ/ZlVBJxht5aagsPqW8JR10PnGZJPEJbDGJeF86NduojJcYBxOedV
i5VYt/xZiTxOEYojUJcQs7AcGNA8BI22POeZSatwxor/cUAl/MsRoU4q65239wHC
rXVg1R/4P0avazU9nsAJrlJ3UgUqYQ5/AHSWzXQRnMoGM9HDE0NMyAHn/EEVteQq
j2ylJIt2Wnlcv9U7FoeFMuRChS6fsncHeP+80A2IPMqnOWnOF00CCa9Xc2DLVV4=
=Q+95
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Aug_2011_11_53_19_+1000_5i4o4=G8APB099OD--
