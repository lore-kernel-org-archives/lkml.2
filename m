Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031785Ab2CPD5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 23:57:18 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53109 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758648Ab2CPD5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 23:57:14 -0400
Date: Fri, 16 Mar 2012 14:56:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masanari Iida <standby24x7@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: manual merge of the trivial tree with the powerpc tree
Message-Id: <20120316145658.3fb06c5213dbca29d6898c4b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__16_Mar_2012_14_56_58_+1100_sAZwT9CG=3DUQa0t"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Mar_2012_14_56_58_+1100_sAZwT9CG=3DUQa0t
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
drivers/char/viotape.c between commit ba7a4822b48f ("powerpc: Remove some
of the legacy iSeries specific device drivers") from the powerpc tree and
commit a7ccf3775219 ("char: Fix typo in viotape.c") from the trivial tree.

The former commit removed the file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__16_Mar_2012_14_56_58_+1100_sAZwT9CG=3DUQa0t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYroKAAoJEECxmPOUX5FEfWkP+QFOKeYx+wB+r0l46uJSglSL
SjsDyYh/LiPOP7/fZ0TVHp+5hA76ZIZQv1nYKpjyJf3He7nH/Nm6ho9gd0y87KGm
Y+x6rDS35JULF2tMlwSgmR5P0JEhXyDKGlC8fM9MZa9TQjsev2gCOd9CUhGr1PWS
/rx0p3ig1+mD3rPJKvpk0pQP2KJx7zN8BWCIlKm9jukaR7PcLL1ImTfAP5UxjtDZ
6Rl9WZEf3hHjsDJXbfGvnrLsav+gImC3e1zVJrmg0t83E1u0mWMuZnONGPflqMKF
VxWqDULsGmzeaoEQ032sncjCzmNnDRaBBSmvKeziTMpTLBIfVYEKO6cNaNGPPdGr
mJ5gVrXJnzpN2/jOHzLMfjd96gUeZraM7JEwotDFvxvg+9ZQaoQcvcbvqrK3h0fE
oYC04b+Zrr5jWgXmQ/rAOPvcGM/Fm7tZSHxJUtmg3FPmELOcLGk63D6XTuioNFwG
PfrFv7LWn2tvRdMTrRvoz+XOiFruYJGNmtGls5u9/inKsVXvxtO0Pg817Hf0e1Ug
/iy7LfWUTfDagBHJsFOhIPOUZHbMIlmXJrBG5Zv4q7svZkygsdWU1qsRvsdVIPuF
ZVw/LrHJPQhRhrcENDviMXnDpzS7tdUeylCzn3Lo3LwRk6cccQXGC3Ybu/WC2cbZ
bxArC0m4hCZ/1LIhuKBJ
=8cHa
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Mar_2012_14_56_58_+1100_sAZwT9CG=3DUQa0t--
