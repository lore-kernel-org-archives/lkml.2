Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab2C0Awm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 20:52:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48087 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab2C0Awj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 20:52:39 -0400
Date: Tue, 27 Mar 2012 11:52:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martin <javier.martin@vista-silicon.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: linux-next: build failure after merge of the slave-dma tree
Message-Id: <20120327115232.ef58a6f97da2d29ed3c8bdb6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Mar_2012_11_52_32_+1100_gwzG/HFaQaVXkuw7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Mar_2012_11_52_32_+1100_gwzG/HFaQaVXkuw7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

After merging the slave-dma tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/dma/imx-dma.c:31:22: fatal error: mach/dma.h: No such file or direc=
tory

Caused by commit 6bd081277ea0 ("dmaengine: imx-dma: merge old dma-v1.c
with imx-dma.c").

I have used the slave-dma tree from next-20120326 for today.

I was wondering why this new work appeared during the merge window ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__27_Mar_2012_11_52_32_+1100_gwzG/HFaQaVXkuw7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPcQ9QAAoJEECxmPOUX5FEfNwP/0c2AaH/BXtXxIlmPg3weFEE
Mzn/cbbZl9GF60bHOFm4kfdQ+p2HoQtu9ihR67QmvuD9dLvTH7vUv4KqAktBHOZL
v14lSffp0xkyhchmn+ptTN7ZDSzqUeRcF08vnt9O8WeF6JIp0qBCzxYGvhqCecIR
BahEQGp8o/Q20YPXBlXN68+q8fdG49AsvQGK8nBWoV74Yxbj55rIpkNxg/dGW8Gp
sWJVPXoNdYg2Afcmjok/wLgtMVrQ1CIAGhYpa3VBfJOiw+4xfOCZ6mslG0U1VEtL
HiP1VJ4hcL2l6iATVcuBEZqpPmBXYrLforfdYo4coHNha4+kr18Sz7kOY3QoT+RC
MWXUsNpftiG00OcSjTUafZaed7c/Acij5h2Qmf7kq4/qZ/clM1Om5m8RAunzSjSI
VIlazrU18gKT7JZBHiAqMDpTJMOvWD39hl68OqSCnVzSFw/VBuSoAGD/kKo3xzNm
p/qFkmpDsxQsO2H6IvJkblpvgZ5bVwqRQSrLxNbUU97TzoaZtOsHm1IWqQ2Oxe4o
rTVzJ0MjtcCbEtOhhtwpjz/kRlJK6u0ejumJzg/NuJsyhMNlljHwLkAWxW8uVjZG
t3Kmo6IHoryslD2loLj0L6TYJkTrVLBUJ+dlJpqxz5wcSJhHWr7Q9c2SEcgzox7a
fPO0hZl2oRtHg2z6MZQm
=6LTz
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Mar_2012_11_52_32_+1100_gwzG/HFaQaVXkuw7--
