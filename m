Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab1CICmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 21:42:43 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57658 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932073Ab1CICml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 21:42:41 -0500
Date: Wed, 9 Mar 2011 13:42:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Emil Tantilov <emil.s.tantilov@intel.com>,
        Stephen Ko <stephen.s.ko@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: linux-next: build failure after merge of the net tree
Message-Id: <20110309134234.32cd09b7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__9_Mar_2011_13_42_34_+1100_q_6aJhYADQy8Noqn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_Mar_2011_13_42_34_+1100_q_6aJhYADQy8Noqn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/net/ixgbe/ixgbe_mbx.c: In function 'ixgbe_init_mbx_params_pf':
drivers/net/ixgbe/ixgbe_mbx.c:456: error: 'struct ixgbe_mbx_info' has no me=
mber named 'udelay'

Caused by commit d7c8a29fc8bd20ba45ec2f52577ed04a988a9500 ("ixgbe:
improve logic in ixgbe_init_mbx_params_pf").

I am wondering if that was ever built ...

I have used the net tree from next-20110308 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__9_Mar_2011_13_42_34_+1100_q_6aJhYADQy8Noqn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNdukaAAoJEDMEi1NhKgbsr+kIAJQ7ZguNcXxFFkWSh8s6gl97
8tSqQWUKb+4s2otmNCFhxS2WcLsdwVZu3lcGZ2H3qBYw5Z8z8z+0nPQbN4q6q2Vj
WVcdUxyIQATkIyHIKTaoD30Oa7cfxoLkUht7Dbfle8C4g+EGczORU+egYo/1klQw
Y1Z6VnsJ13qEnHUbWCHlLihIUyxShUNLYshP1XIToItD4sRzFqM0exSLJu0GsvFB
qlVlqpiEwMhnQV1BtsDfcITTSMAkASbdiii9V0a2TKHoc/Id2m8rp7kfTVRzFz03
Uvn233opF4GO6//RDmdV8aUw1oFmw3zBQCXobrgW7CQ3qPfSG8WkIKNuh3o9G0c=
=ZqgV
-----END PGP SIGNATURE-----

--Signature=_Wed__9_Mar_2011_13_42_34_+1100_q_6aJhYADQy8Noqn--
