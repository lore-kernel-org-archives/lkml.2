Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab1DPOeI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 10:34:08 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:35214 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab1DPOeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 10:34:01 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Francis Moreau <francis.moro@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Kbuild: how to cleanly retrieve information compilation about the last build
In-Reply-To: Your message of "Sat, 16 Apr 2011 16:04:57 +0200."
             <BANLkTi=wdDsrV+ikoxLhnTpLhQTuVKW0mA@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <BANLkTi=GXro_xEiRyzZY86kWM9duJ3KAUQ@mail.gmail.com> <BANLkTi=2aRu6x3uZtpMvPd2BSpYpkT5yfQ@mail.gmail.com> <20110416135912.GA1044@merkur.ravnborg.org>
            <BANLkTi=wdDsrV+ikoxLhnTpLhQTuVKW0mA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1302964434_54890P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 16 Apr 2011 10:33:54 -0400
Message-ID: <61322.1302964434@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.4DA9A8D6.0058,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1302964434_54890P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Sat, 16 Apr 2011 16:04:57 +0200, Francis Moreau said:

> For example a user can do:
>=20
>   =24 make ARCH=3Darm CROSS_COMPILE=3Darm-linux-
>=20
> Then call my script and expect it to pass the same flags to make.

Odd, don't ARCH and CROSS_COMPILE get saved in the .config?

What *are* you trying to pass to kbuild that isn't either saved in the .c=
onfig
or deduced at build time (the cross-compile gets saved, stuff like =22whe=
re is
python?=22 is deduced).  Is there a *real* problem you're hitting here, o=
r is
it merely theoretical?

--==_Exmh_1302964434_54890P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNqajScC3lWbTT17ARAo5tAJ9SgPtQ2MzDP1TW0u0EMVmnKaLfEQCgtC+F
wWPqPXayb/HxymZwJfVnztI=
=yaAl
-----END PGP SIGNATURE-----

--==_Exmh_1302964434_54890P--

