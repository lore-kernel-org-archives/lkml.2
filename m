Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184Ab1FTErT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 00:47:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34084 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab1FTErS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 00:47:18 -0400
Date: Mon, 20 Jun 2011 14:47:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the rcu tree with the tip tree
Message-Id: <20110620144705.c9a5513b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__20_Jun_2011_14_47_05_+1000_1QboXMiol9YMg_sE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__20_Jun_2011_14_47_05_+1000_1QboXMiol9YMg_sE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the rcu tree got conflicts in
kernel/rcutree.c and kernel/rcutree_plugin.h between various commits from
the tip tree and various commits from the rcu tree.

I can't easily resolve these, so I have dropped the rcu tree for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__20_Jun_2011_14_47_05_+1000_1QboXMiol9YMg_sE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN/tDJAAoJEDMEi1NhKgbsQsUIAImC8bzTGHGr7mIq3+97L7Po
aCAJH0q1QFyJGDhMtwd03pc8y8H19OYaIJBzXOVGhJUxknl3Xxtm9BOCgtkplXP+
0njNhJ/cfDgne8NnSNKiumVXfr+brwJiC/BM8Q1TpB3awniNbrI3I+9w2y8+ybYK
AWV2cUihdWv6deu+enGXttcYDYrimAQhUiWERvXB/sRtMcCe4Hmkjg+WSx5Iy1MD
f0Ln9Z3SHZomLiJ5aXllw9W1nymZ9jd0K6B2EpvbCvVh09hy/mdm82FnvBjlREId
xznBxGS+rCykKxMJqzDCM64PEYdSMkR2Qk3vvNcbbtWU/YBWYvwprmMD173n6oM=
=dPFc
-----END PGP SIGNATURE-----

--Signature=_Mon__20_Jun_2011_14_47_05_+1000_1QboXMiol9YMg_sE--
