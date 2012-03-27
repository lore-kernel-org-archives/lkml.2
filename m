Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab2C0BQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 21:16:20 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36481 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab2C0BQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 21:16:17 -0400
Date: Tue, 27 Mar 2012 12:16:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Gerecke <killertofu@gmail.com>,
        Chris Bagwell <chris@cnpbagwell.com>
Subject: linux-next: manual merge of the input tree with Linus' tree
Message-Id: <20120327121610.e39e648811d5b00ae328077b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Mar_2012_12_16_10_+1100_32vQm3OtyoPEBItL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Mar_2012_12_16_10_+1100_32vQm3OtyoPEBItL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

Today's linux-next merge of the input tree got a conflict in
drivers/input/tablet/wacom_sys.c between commit 24e3e5ae1e4c ("Input:
wacom - fix physical size calculation for 3rd-gen Bamboo") from Linus'
tree and commit 16bf288c4be6 ("Input: wacom - create inputs when wireless
connect") from the input tree.

The latter seems to incorporate the former, so I used that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__27_Mar_2012_12_16_10_+1100_32vQm3OtyoPEBItL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPcRTaAAoJEECxmPOUX5FE5aUP/0GCRAO2trsUrtjFO5Uv+ApI
LZaU61tJ4emaBo8vleTjZuBSN+2jb6K1xdntn7tzW8QCTLWuLxvjW3eDP59WK4sv
TD8dIjyMbSGNuhZ+5ZCjUgQukJwPSs55quydL0kVLfeCLQYVsoDHhdq7uFSCMPO4
vm887XkuCC7Uo5QPygcxDgx7sfmaQfeOyRrWi1A1ZaQsuNq5uwi++VEmv6R+Ldo/
7KavbZ8WQYWjtgww+DNTACPRhOTnVa5On/oOXOhMfyXrZZYeATjOoye/A4Z+SUG4
k05iqCJavru+fxfhRSG2l7wCqI6O8mCHSshJXThMVDSnWXhCUaSw44M4Yi+kBTQS
pi7gk+8P0dpQT0g2psnV6Ks5l2hsaFkui4j/2JZtUR1jaVPUDf7EtL3FNzYnenMF
rfVrMxXoSVZtgQo5yupxhSCCPJSxYnC4n5CygOGQZCWde0HGvy4p7wxNs0qGq3DC
xZUQiQKT50O11118hfM7iQM0Yep7Y5h4RTlCWibPBK4qQdspDiHHWyFk/J8xvCnj
fcJ6G3hV9dyAvKCWUC3JbMW97b5CIxC6GUJzT/jTEoM8/Ra0Yccug0rt+LlfUgQN
2Pupjz3zT1Vaa5tOfamLZsrASbIXCNXSVrKO9J2JJauaXh+c3Vi9gR8ZfSvOXU7p
OxZExqfijZSXQd5X0p5d
=QV5M
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Mar_2012_12_16_10_+1100_32vQm3OtyoPEBItL--
