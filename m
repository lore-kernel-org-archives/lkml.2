Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab2KKWtg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 17:49:36 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58764 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab2KKWte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 17:49:34 -0500
Date: Mon, 12 Nov 2012 09:49:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: comment on the mips tree
Message-Id: <20121112094925.e374a7f7b51df1738c152026@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__12_Nov_2012_09_49_25_+1100_bf4n4U33mc2VkyF4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__12_Nov_2012_09_49_25_+1100_bf4n4U33mc2VkyF4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

After fetching the mips tree today I had a look at the changes (as I
often do when I fetch all trees) and noticed that today's changes are to
add 6 new patches to your mips-for-linux-next branch and then to merge
another branch (current/for-linus) that contains only those same six
patches.  :-(

You really only needed to do one of those two things - and preferably the
second (assuming that you intend to submit that second branch to Linus
shortly).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__12_Nov_2012_09_49_25_+1100_bf4n4U33mc2VkyF4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQoCt1AAoJEECxmPOUX5FECyQP/RpcQT4vy3uP6urrX/M7VSAU
AYR326Jent1SN9Bp1aOrkHtxt6pfpovtHY30piJ6C3D3tmAgCm9y+/ZNkZS5zNng
yo0pbQIE67vCL4JThyvg7zo/SE5yDKpt+/wKXoIW+hCvO6I638GTmV0ArGvmZE/n
lrC7wUrg+vjVkMMmRKaeRy59MEKhJHgY49C4iETNgqTNLtQWDJCcruiByq7/gdzJ
yjA2YI7M0Nrx70ps0TxrNS8+V07NoUNhv2cmaJR3Y6ioGFQVjT1d0ld7iXMI6KkS
EzliiqTPI17Sj3niwlBVyDH4AfWWqHStHfSH6vVEYBflgLmVvfm8CXF09X/WtJGL
knW043fHvSJ4xer/97izRiSyGNbfr1a/lYfyf4NiruYbZZgQw11olbeZetasEZaB
znHkc2WF/NAAmx1rJFeBSrWblSJCsggPvpkNaVPGAu+hrCAEKBrQSrKbQPcgSvNV
NLPpsOmRK2E/TtT+cB1RnCBQ/5KL4h4NPcf4ZBk3IUL0Vn0rk5xSlL4IBmqGdtGs
2PMCVbFpsbPhRRDZgmXcSx21br6wx6mV6aZi7a9tR0sJSPBH57rx0cQ1m22l5en6
Ot2NI8pa5sLI0sxj+tgqHOe3r7srOtu6D/H9Y6bs0IONjqlOiYgSBd2ly6EHkQQ5
uFsvrrjOpp6Ep3+7j3ta
=xJop
-----END PGP SIGNATURE-----

--Signature=_Mon__12_Nov_2012_09_49_25_+1100_bf4n4U33mc2VkyF4--
