Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab2ILEdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 00:33:43 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40158 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab2ILEdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 00:33:41 -0400
Date: Wed, 12 Sep 2012 14:33:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jamie Iles <jamie@jamieiles.com>, Gleb Natapov <gleb@redhat.com>
Subject: linux-next: manual merge of the kvm tree with Linus' tree
Message-Id: <20120912143331.beed6ad11cfc753f3c33f5a3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__12_Sep_2012_14_33_31_+1000_NGsW.6Ccl1KcBvsD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Sep_2012_14_33_31_+1000_NGsW.6Ccl1KcBvsD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in
arch/x86/kvm/i8259.c between commit 749c59fd15b2 ("KVM: PIC: fix use of
uninitialised variable") from Linus' tree and commit ec798660cf72 ("KVM:
cleanup pic reset") from the kvm tree.

The latter removed the code fixed by the former, so I just did that (no
action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__12_Sep_2012_14_33_31_+1000_NGsW.6Ccl1KcBvsD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQUBCbAAoJEECxmPOUX5FEPx0P/ihX48AKb/J1m5Ka9Clv0OS7
cNF6yYZR17XoejSwyevjaWTMe7KKyTUvQA/hED7iVcc071VScN5P3CLhhj5fIP4o
+NQCkgFIUhIm9q9s/vqWEyQnQFtUy8I8Pct1Zv60vtAkdfYEcrpXUqhOTZPf4B7n
+EJ/FV7sDSereZRjWlvurraznb0n2linipNbm8B8a/UDP9UKCjhX6vvWfyQtwTYJ
IgdY3KP7u7cKnHEiXLDazhV1zuFF5Jw9GyQjQ7u60YeV3oNBvHuUutCNJOZ9E6L2
b4sWRVhq8A4Cj2Z/v2hOXTfWMkZThTEUCnzNDu0KpTYI8zYSSW4IZF33Ps8W0Hh4
7jvlJL9R0PXDIbKWZuZYYAhW/zTqrfNEDNWtd2JoVuAejHVqjS/kXfAkt2bFjIho
PHkfXMAxxZDEpBBq0s3+pqi0NKz6i77I8MGn8riPkcYj7BnnqbiXUWe8wf5siW6N
GXDse/UrlksHjCtHdr//fw+Kh/v5CgxFI2YKQCjLezF55EHcBEib/Wf3upOOE+M1
K8zvY5yXINUcjRp6MMNZ7yO9u5DaNCXVFxaBGA372meqTGujvFlyEAVhDy2DNB48
2vIIr0iYUzU6V/hq6XUdJyfaNprdlomG05rCadDMTJxfngpoOxnz7vjXeBfmZWpR
H3VwT9Muf6Um3VWalGYB
=EpOU
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Sep_2012_14_33_31_+1000_NGsW.6Ccl1KcBvsD--
