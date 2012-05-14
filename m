Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab2ENJNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 05:13:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55759 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab2ENJNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 05:13:44 -0400
Date: Mon, 14 May 2012 19:13:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the userns tree
Message-Id: <20120514191337.e06ca84184b73b20b5c52689@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__14_May_2012_19_13_37_+1000_MoF7UAlD2SODTuYX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_May_2012_19_13_37_+1000_MoF7UAlD2SODTuYX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

After merging the userns tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/stat.c: In function 'cp_new_stat64':
fs/stat.c:354:61: error: expected ';' before ')' token
fs/stat.c:354:61: error: expected statement before ')' token
fs/stat.c:355:61: error: expected ';' before ')' token
fs/stat.c:355:61: error: expected statement before ')' token

I have dropped the userns tree for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__14_May_2012_19_13_37_+1000_MoF7UAlD2SODTuYX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPsMzBAAoJEECxmPOUX5FEbBsP/3ne4Bfomq6Vt0TgOO2PMoH1
+Flhmk/I8N1fTYvCeC8TkGm995Fp9kNXKBuNA8TOuqlCkdF1kQxijWA1Y6dYDAAc
J+L6yK3/Oipy2OBMykrZLr7K9TBXbqPrfMScjvuYFWaQrN8ZCbc5qk4CWEd8GwMD
jICHkN2nucgNvjlr6p8l6KIna7vrNo6jvnFbQYj+4riLt8LNd8FIUSty3kMCraJ4
M1EpYgW8eWwB+g7o/KK0qZajroZWheTfQJNvFjzXU3BS7JgdJ9AK0HRKelmC/qT7
9EOKl7MlDUfI8zSbR2QoNFIJB0SX6oHQ7yzm3IDOCdTm7eYjJA57yTas5TNVWdsS
Zu266y/gRnIMPgP05M9f+gx3e7ReHaHZwZPd1OmRFlmrqdTiM1QIwRI6YFH4PIA9
qem/AfAkqSKKX329noyN8Ts+iBNnES3Grt5cs8xDB6NSJ8cbCIeFe6+XD29wiSfT
RibmVSAAi7dVlxgkjaFa8hwabkrcFSbdbHUOied+9QJxABArBlKfZ/q09VQ+bCVM
sHOmPXd4txjDbtkEf3Fn96EHTVV7L8wErGUhRjW+A1X1kD7FFIFqknmwOYMXVCnU
sJTaNJobt9pyDK36SVSaD/HykT3gztDjqm7Ff7TSA2uV9WuoMAuxtQgqRWtYt5oJ
ucO7a3bOUk6o1PRQWACg
=Yz3A
-----END PGP SIGNATURE-----

--Signature=_Mon__14_May_2012_19_13_37_+1000_MoF7UAlD2SODTuYX--
