Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab0KVSNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 13:13:05 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:35659 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756863Ab0KVSNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 13:13:01 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Derek Nielson <dereknielson@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Best place to ask this question: error with compiler.h when switching from 2.6.32 to 2.6.36
In-Reply-To: Your message of "Mon, 22 Nov 2010 09:55:14 MST."
             <AANLkTikt2k8jC4ykYqYG_hQPAZt0-GXAvD1DPogu+AB0@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <AANLkTikt2k8jC4ykYqYG_hQPAZt0-GXAvD1DPogu+AB0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1290449579_5325P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 22 Nov 2010 13:12:59 -0500
Message-ID: <9466.1290449579@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020208.4CEAB2AB.01B7,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1290449579_5325P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Nov 2010 09:55:14 MST, Derek Nielson said:

> In file included from include/linux/string.h:10,
> =A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 from
> /mnt/local/home/linux-omap-2.6/arch/arm/include/asm/uaccess.h:14,
> =A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 from /home/my_module/my_module.c:24:=

> include/linux/compiler.h:62: error: expected =91=3D=92, =91,=92, =91;=
=92, =91asm=92 or
> =91__attribute__=92 before =91struct=92
> make=5B2=5D: *** =5B/home/my_module/my_module.o=5D Error 1
> make=5B1=5D: *** =5B_module_/home/my_module=5D Error 2
> make=5B1=5D: Leaving directory =60/mnt/local/home/linux-omap-2.6'
> make: *** =5Brelease=5D Error 2

> I found this thread=A0http://lkml.org/lkml/2007/10/17/213=A0and tried
> following their solution but it didn't fix the problem.
>=20
> Does anyone know how to fix this error?

What does 'gcc -v' say?  And can you give the entire 'make' command that
you issued to do the build?

Other likely possibility is that you haven't done a 'make <something>conf=
ig' in the
2.6.36 directory tree.



--==_Exmh_1290449579_5325P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM6rKrcC3lWbTT17ARAl8RAJwLoPL1Y2Bo3lyu7Z/GwpOAjdEkYACeIG54
2RbEoztIDNO+Gahy59BhQs8=
=JeCS
-----END PGP SIGNATURE-----

--==_Exmh_1290449579_5325P--

