Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933517Ab1JYNzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 09:55:53 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:60619 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933347Ab1JYNzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 09:55:51 -0400
Date: Wed, 26 Oct 2011 00:55:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-Id: <20111026005530.a4bd779e1a8182ea57dbf99f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__26_Oct_2011_00_55_30_+1100_+b=cS15HvDQ15HZi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_Oct_2011_00_55_30_+1100_+b=cS15HvDQ15HZi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc
pseries_defconfig) failed like this:

drivers/net/ethernet/ibm/ehea/ehea_main.c: In function 'write_swqe2_data':
drivers/net/ethernet/ibm/ehea/ehea_main.c:1692: error: implicit declaration=
 of function 'frag_size'

Presumably caused by commit 9e903e085262 ("net: add skb frag size
accessors").  I guess it should have been "skb_frag_size()".
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__26_Oct_2011_00_55_30_+1100_+b=cS15HvDQ15HZi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOpr/SAAoJEECxmPOUX5FEd+AQAIGk6I3YRTJ9RGHMU6MUEeEl
J/VtRXodJfUdQxPGVPZth2F4ygGf4zRd+f2eYjikSL3RNCBZ9pdBzbffhtVaIO/U
myXMPzXuk4DWryMj9wknqH5pnazxHXH65fTllQLwcjVOgfYHOmGFAVSMIbhlrjM7
zBDG1dWLbth9v3z2/AkCQo6G09D57qGkXkDlszAVCyosmntJBmdvAHXkLJCMVDhm
cAbxOW5ZBAh8PRspnIKYSyCAG4vC20t7DsY/V0krPU5Xi9KoAR2iud6lUSNK5sH8
vFy4vxJQo5U6RnlZKPV2j3vEfYRlJABHwWdcNnTD+TrDweMLXq2kp3cjoZBDLBGx
fiNs9DKgm1OjdvaA/nV+Bs/gXI2iVF6u4nXKg/gC+6Ona0eN2y1HBZ2PAOoBg4oF
ZRqViID3mMhWFXMUTwjrDyVpYONGoFCVU85c8cST3ThUlo0tHvbinGQeocs5dbWW
iqyZ0pgzWJa/wR4IDS2is4MQAPyoVeGXbVqQpYoKEW8Hmr9TerX+hB2nKrJCG4Ug
uvAPjcR/Y4XrGE035hflNHRzWGS/UBUWsw0KmAXLE3aIJa2T6pmVDoxqSnrp1bLd
H0eX+XO8J4+Qz+CMg0ypbnel+xXnjeeMaJiLF18Mvgy+kmjdV8GL+XRS5+DDDqJI
WfXGMPn4mWU9YCdv+A8s
=L8W+
-----END PGP SIGNATURE-----

--Signature=_Wed__26_Oct_2011_00_55_30_+1100_+b=cS15HvDQ15HZi--
