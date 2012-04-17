Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334Ab2DQEKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 00:10:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45285 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab2DQEKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 00:10:31 -0400
Date: Tue, 17 Apr 2012 14:10:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>,
        Eric Paris <eparis@redhat.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: linux-next: build warning after merge of the final tree (security
 tree related)
Message-Id: <20120417141023.40aefc2ff17c29b2edf51762@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__17_Apr_2012_14_10_23_+1000_8Q0O88w=KhKpINNI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Apr_2012_14_10_23_+1000_8Q0O88w=KhKpINNI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc64 defconfig)
produced this warning:

kernel/seccomp.c: In function '__secure_computing':
kernel/seccomp.c:445:1: warning: label 'skip' defined but not used [-Wunuse=
d-label]
kernel/seccomp.c:381:6: warning: unused variable 'data' [-Wunused-variable]
kernel/seccomp.c:380:6: warning: unused variable 'ret' [-Wunused-variable]

Introduced by commit acf3b2c71ed2 ("seccomp: add SECCOMP_RET_ERRNO").
This build has CONFIG_SECCOMP_FILTER turned off.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__17_Apr_2012_14_10_23_+1000_8Q0O88w=KhKpINNI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPjO0vAAoJEECxmPOUX5FEf2kP/1V/VJuAA4t/el0hWTW7j4KP
Ce6PXFQN1tZZ09STZk27G/Gu/W7K6Owtk+IJhc+YuiuGHIbofOIz/LNJ3h/WoyuD
qLCzvcE8EmOr8BR+jlivLkChLjvDxzoeNLba7BBmLX1cczkJXa6b7mKWI01uP2MC
6Sc9RG2JMgB6adQSlZfUBlfG+TMEeAXAr584ejjqNSKzIWlp13hY9zMqOkZT6h30
F1UrdcUK6bc29XzsuBsldL2GCYzjNuejj+LAErXRoGNa9NGpzG9Xqr1hu+Bk77LH
utEoKTXY/r7fINxEPh4/V0BullV6NilVqkFkWuF6h+6qLQYsVBHZTuguztQ0PLcX
iUnumi3cHZUJa2mQDfaWnr1jgHzObKljytqWTwFzDvz5wE0ZNJXG5HhDXsxNqcAP
Du/FJVqeg9T5s07s/jmxxDtkmHHR2BPKxgmSZiaAGdOJ9yq/6WhG9//wIKNwz987
5CjpNDvhVB3cFJs+tQ+oR/sIh7XX4wfkLbPAXDVJjFhRYFmQQPqaKC9ATLANU9lW
awE4bX+k40TPVr/jL2x11NwfzVwyQAGFNRiKcJYkd9KnW3LP237uAqkHaYqBFXbi
FwFpv/dFSnrOejxkAHQvXpkOlH8n0OWz5G46ivvuCRCoQC/Rl/1FMYjPk5++okmY
KikMquSTNxidf7fQ0Wvo
=NQx5
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Apr_2012_14_10_23_+1000_8Q0O88w=KhKpINNI--
