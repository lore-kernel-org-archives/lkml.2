Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab1JNEry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:47:54 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:60537 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab1JNErw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:47:52 -0400
Date: Fri, 14 Oct 2011 15:47:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        David Miller <davem@davemloft.net>
Subject: linux-next: manual merge of the ptrace tree with the sparc tree
Message-Id: <20111014154738.5aee83104a71266012e46a9d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Oct_2011_15_47_38_+1100_h2vmu3x.TuRv49mR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Oct_2011_15_47_38_+1100_h2vmu3x.TuRv49mR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the ptrace tree got conflicts in
arch/sparc/kernel/signal32.c, arch/sparc/kernel/signal_32.c and
arch/sparc/kernel/signal_64.c between commit faddf598f0ba ("sparc: Use
set_current_blocked()") from the sparc tree and commit 383fe35697e4
("sparc: Use set_current_blocked() and block_sigmask()") from the ptrace
tree.

I used ther version from the ptrace tree as these seem to go further (and
have a later Auther Date).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__14_Oct_2011_15_47_38_+1100_h2vmu3x.TuRv49mR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOl77qAAoJEECxmPOUX5FEeiYP/3UqsSkh+YhlbH/QAJYZZZwq
idouWmxie4nKF+5Y4ir/6UFTTiL6+TzGPtZKAAQxJ09B6A8qggsFzEWidRTK7ky1
pxmXkqDQwk7yaUBzDGKO2BI1DFMvpChglWha90U4mhgncqQdPdtxY4NnFhoQYKat
XIUGmq5yRn3ltHQYjTO09U/Bt3eQIyOxqIOgQkTByDTxIRF2XkW1qsalNES5BXmA
cu99CnXUIUmfWklcQk71zHdVjcXUPtfR4vL+WAOzl0XoTCQumG4PnB3LvVAxyhN2
JZosZ/wI0rSsFCF9uEkw4AGkIVFFCAbq9Epfan8nX8jsFrGJgck4o8RGkLxBRamf
k8jXqYmkb2orfcEm0n4S2kRmRuSM9BeHJ5IkZV6cl1JBDUQNWhu6/9zgnhetAn1T
LuxUPjUav0H5cLgxfaZDAPket4tcmxH8yMMaAxnNtAskZ3+ssRHoY8WTsu06ZcaE
zMD7HZ9pl1EHclh6fznOohfyRY8bEk7h+VOAw+501kweGs2cUszHc6tTPmYFllHJ
amKA9a3830Zh6J+WkYyR5KN5uz8umkBxJy/KUhz3UxDHVUYdnoIohrNtPjjz4gVQ
maOW5wrWxt5eEHk+A7uDDPaBT5emNKwaHBckGy4Oapb23Yx2uXEKwmiLNkPez8YW
l0VGewbrxRGen/wrnhQh
=h6AK
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Oct_2011_15_47_38_+1100_h2vmu3x.TuRv49mR--
