Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab0K2SLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 13:11:12 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:40363 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab0K2SLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 13:11:10 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: =?GB2312?B?x8ez5w==?= <qiaochong@loongson.cn>
Cc: hellogcc@freelists.org,
        =?GB2312?B?QW2opnJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org, gdb@sourceware.org
Subject: Re: [hellogcc] Re: [PATCH] Built kernel without -O2 option
In-Reply-To: Your message of "Mon, 29 Nov 2010 17:45:15 +0800."
             <4CF3762B.9010102@loongson.cn>
From: Valdis.Kletnieks@vt.edu
References: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com> <20101129081619.GD5218@cr0.nay.redhat.com> <AANLkTinnJjqmXmbpAYmV9Tsc0VJV=WDM+GY6Gi1cJFCB@mail.gmail.com> <4CF36741.9000808@loongson.cn> <AANLkTiktPFtCdYpZai-L_WCOpBrZYN5yN_V7GZ5tKGXG@mail.gmail.com>
            <4CF3762B.9010102@loongson.cn>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1291054229_5346P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 29 Nov 2010 13:10:29 -0500
Message-ID: <13700.1291054229@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4CF3EC95.0259,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1291054229_5346P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 29 Nov 2010 17:45:15 +0800, 乔崇 said:

> change mycc to this will work,:)
>=20
> =23=21/bin/sh
> gcc =22=24=40=22 -O0 =7C=7C
>  gcc =22=24=40=22 -O1 =7C=7C
>  gcc =22=24=40=22

That may result in issues - the problem is that there are places in the k=
ernel
where 'gcc -O0' will *compile* cleanly, but not actually *run* correctly.=



--==_Exmh_1291054229_5346P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM8+yVcC3lWbTT17ARAtCwAJ9sOL0h3muu0If6DS8EMeeYm/1mbwCfSwID
5xRV4P1ewn72coIjaViOrnU=
=kmTU
-----END PGP SIGNATURE-----

--==_Exmh_1291054229_5346P--

