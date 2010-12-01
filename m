Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab0LAWNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 17:13:18 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:37846 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab0LAWNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 17:13:17 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] sched: automated per session task groups
In-Reply-To: Your message of "Wed, 01 Dec 2010 13:01:29 +0800."
             <20101201050129.GA5210@cr0.nay.redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <1291052268.32004.171.camel@laptop> <1291057565.20709.2.camel@marge.simson.net> <20101129192033.GA18372@elte.hu> <AANLkTi=jra_M+F9OKj31uS6EMu+ZkPT++GSrNd_bgXSy@mail.gmail.com> <1291090455.7550.7.camel@marge.simson.net> <AANLkTi=YDHyRcP5NSdVDRMW0_oj1L85aLzGV9hFGw1FN@mail.gmail.com> <1291123083.28239.18.camel@marge.simson.net> <20101130151749.GE26758@redhat.com> <1291137221.28239.70.camel@marge.simson.net> <20101130193622.GF26758@redhat.com>
            <20101201050129.GA5210@cr0.nay.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1291241535_5106P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 01 Dec 2010 17:12:15 -0500
Message-ID: <17128.1291241535@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4CF6C840.0065,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1291241535_5106P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 01 Dec 2010 13:01:29 +0800, Am=E9rico Wang said:

> Hmm, maybe we can make AUTO_GROUP depend on =21CGROUPS?
>=20
> It seems that autogroup only uses 'struct task_group', no other cgroup =
things,
> so I think that is reasonable and doable.

A non-starter if you have a Fedora Rawhide box that has systemd installed=
, as
that won't even make it to single-user if you don't have CGROUPS in the k=
ernel config.


--==_Exmh_1291241535_5106P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM9sg/cC3lWbTT17ARAsDVAKCrfx904Qd4LT1Vcw4dr0RpR4u/ZgCgg1y/
IFHWndCqeeSfLisdha3vlLQ=
=+Tat
-----END PGP SIGNATURE-----

--==_Exmh_1291241535_5106P--

