Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030577Ab2B2Hwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 02:52:55 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:37061 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030366Ab2B2Hwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 02:52:53 -0500
Date: Wed, 29 Feb 2012 18:52:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Kelly <ckelly@ozmodevices.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree
 (staging tree related)
Message-Id: <20120229185227.7f14b1863c7a5d16220bac3f@canb.auug.org.au>
In-Reply-To: <57C28D85C66F5C49B9E212CBFAFDAC1F23010F80@CH1PRD0802MB120.namprd08.prod.outlook.com>
References: <20120227181303.9aa93b8a8ed02428e9310c5e@canb.auug.org.au>
	<20120227211630.GA18418@kroah.com>
	<57C28D85C66F5C49B9E212CBFAFDAC1F23010F80@CH1PRD0802MB120.namprd08.prod.outlook.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__29_Feb_2012_18_52_27_+1100_Ir80ll8LsjUAqTBl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Feb_2012_18_52_27_+1100_Ir80ll8LsjUAqTBl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

On Wed, 29 Feb 2012 07:35:35 +0000 Chris Kelly <ckelly@ozmodevices.com> wro=
te:
>
> Hi Greg,
>=20
> I believe I understand the cause of the problem and would like to submit
> a patch to fix it. However, I am unclear on what the starting point is gi=
ven
> that the final patch was reverted from linux-next. Do I assume that patch
> will be reapplied before the applying the new patch or should I provide
> another patch to reapply the reverted patch? Is it acceptable to submit
> patches generated against the head of linux-next?

Your patches are all still in Greg's tree which I merge into linux-next
every day.  I have then been reverting that last patch each day.  Your
patch should be against Greg's tree (or your last patch) and then when
the fix is in Greg's tree, I will get it in linux-next and stop reverting
the other patch.

> Before submitting the patch, I would like to test that the patch really
> does fix the issue found by Stephen. Since it doesn't occur when building
> for x32 or x64 then I need to setup a PowerPC cross-compile tool chain. Do
> you have any suggestions as to where I can pull a prebuilt tool chain or
> do I need to build directly from the GNU sources.

http://www.kernel.org/pub/tools/crosstool/files/bin/x86_64/4.6.0/x86_64-gcc=
-4.6.0-nolibc_powerpc64-linux.tar.xz

That is am x86_64 hosted powerpc64 compiler suitable for building the
kernel.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__29_Feb_2012_18_52_27_+1100_Ir80ll8LsjUAqTBl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPTdk7AAoJEECxmPOUX5FEJjEP/0B5u2CevOE8zSzHroYPh/Y2
OS5CupYclrzi9hlN+8WqRZMhvNgToZkaEcrRBEfxrhwU2kcZG0ChPAjO/t9rNxB9
qedv35SMkC03foOjA/k/g3SUC97gLlF/jub+zKIs/WGMoNrtfa+2rxBhzTHXhKWz
dfNtMZn6O+xTJKAInnQ35G60z4ddxTb7qjE5ByAYQJRTZUHmVb8iNT31gzMoCth7
7YFhVv0mLVIjRO8wMcJHXO5lHTsrifseBoT+L6MAraWD2c1ZQXUa/hMzleAHm01o
QqO5fvVuJb8Swyw/U//GMzyPc9QIiXb4nZnWT20htnQEKx5nMYDJ+V2bKfEHmoci
Jp3HE3yyECchqY6jauLFyxw+JztFHeVcsleTqIlnfV87HQv0bKXoBliIwQpzogtI
m+sv8ikV6z81YOW2AhCWqaPjE0KWq1aZqDnBYAztlZzCGC7nIgwPdCZxpVGpKzng
Bw3B8opxFZL/n39YoA0mn2JtWhQ9uR85jZV5FcuSZATSOco3TyRWROuNbeolXKex
sp6KPVWga3VmmD4ORZHXIXNrKEs50iIH06vFiU17iA1E2p8oT8XCtcYTV9pduktd
HhdkOx/9mlMTm0Y6TkrSulq0qhA6GTv6kV+0xLVrLpEsFf+5alAMnlJBtRbaSw1y
eOMLmxquAeMk8o+LjJnl
=W9Gl
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Feb_2012_18_52_27_+1100_Ir80ll8LsjUAqTBl--
