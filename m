Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab0K2SFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 13:05:01 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:56380 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab0K2SFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 13:05:00 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Hui Zhu <teawater@gmail.com>, linux-kernel@vger.kernel.org,
        gdb@sourceware.org, hellogcc@freelists.org
Subject: Re: [PATCH] Built kernel without -O2 option
In-Reply-To: Your message of "Mon, 29 Nov 2010 16:52:50 +0800."
             <20101129085250.GF5218@cr0.nay.redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com> <20101129081619.GD5218@cr0.nay.redhat.com> <AANLkTinnJjqmXmbpAYmV9Tsc0VJV=WDM+GY6Gi1cJFCB@mail.gmail.com>
            <20101129085250.GF5218@cr0.nay.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1291053822_5346P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 29 Nov 2010 13:03:42 -0500
Message-ID: <13378.1291053822@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4CF3EAFF.006C,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1291053822_5346P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 29 Nov 2010 16:52:50 +0800, Am=E9rico Wang said:

> >For example:
> >ifdef CONFIG_CC_CLOSE_OPTIMIZATION
> >CFLAGS_fpu.o                           +=3D -O2
> >CFLAGS_aesni-intel_glue.o              +=3D -O2
> >CFLAGS_ghash-clmulni-intel_glue.o      +=3D -O2
> >endif
>=20
> No, I didn't mean this, I meant some function that have to be inlined
> are those who only work when being inlined, e.g. current_text_addr().
>=20
> I think it is not alone. :)

Anything that uses the gcc __builtin_return_adress() extension should als=
o be
audited - that returns different results for inlined and non-inlined call=
ers.


--==_Exmh_1291053822_5346P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM8+r+cC3lWbTT17ARAgGqAKDW6hcAuzTGLrRKQcrTxqhrdBrJmACgnUfb
QfFuxv2LjcXyBo6vAfKHPRE=
=z4qj
-----END PGP SIGNATURE-----

--==_Exmh_1291053822_5346P--

