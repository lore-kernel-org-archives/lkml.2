Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab2CPFwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 01:52:18 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55230 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab2CPFwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 01:52:17 -0400
Date: Fri, 16 Mar 2012 16:52:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masanari Iida <standby24x7@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: manual merge of the char-misc tree with the powerpc
 tree
Message-Id: <20120316165207.5a4f0985863b5ae7c50bdd81@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__16_Mar_2012_16_52_07_+1100_pZRK/URh1E+iqQ6N"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Mar_2012_16_52_07_+1100_pZRK/URh1E+iqQ6N
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the char-misc tree got a conflict in
drivers/char/viotape.c between commit ba7a4822b48f ("powerpc: Remove some
of the legacy iSeries specific device drivers") from the powerpc tree and
commit 5fb15db4376f ("char: Fix typo in viotape.c") from the char-misc
tree.

The former removed this file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__16_Mar_2012_16_52_07_+1100_pZRK/URh1E+iqQ6N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYtUHAAoJEECxmPOUX5FEIbMQAI7+lm2VCotsYT3Ac2hqKxZk
AQ/hFemsdWgbvl9hgF7OO0lFHjA9A5VX7+bMyFirTjxdkE06IyPRP+vvx7edwEJt
3h/ETOyDDlfZk2Y/oF7Z888t4KXPg9Ln4KJGaz1ZDCfHIeDNn/Ub31Aj30bvpcX+
bcJYzmd+EiRXAQcls4oay3pt3u7gZwmEZOx7L462+GF3ATpyqpgfCbMtRFU4XkdD
bSZ+Yn2ar5ObO2SGROvcetCXtKFl+/etJz4u96f6MhdSw92EU/C0yMLSLAbAnUBh
5D9XVNTSDwMcOxNV+7jyUuPkkyixfm3CIRqUo8B5ZznKPgKdeTySNO3KviNIdx9C
67qt9gGcXIB8G5TXVWqYx98HWTo5d9IL1X67j9QDK1mmG4R8KJrzoggdL4HIeiao
3EZHgtWWP21S//rjVwQAicbeqweU38DeD2hBxw/jUv7j5DsY2ozSZYF9eVRERBce
phC06cg1/Tnvha7SH2aghdp9f8p15IAyVpLitUqJ5hUYtz6apu0lF6VDp+j3l13o
QfdWAU+k6eXjmawSQd1Wmw1Hbsmy6M+6tjToe18M77cxydoyyxYGNfqpoLx/u/QF
QDHSJX4asD8GsMZpnnbc4Qacb/CdQlbo8+Q8RmrDW+JtKmFHuoUl7AXmbQ9lGV2t
Q12qtB5lHzyojqgtNNkc
=IPdg
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Mar_2012_16_52_07_+1100_pZRK/URh1E+iqQ6N--
