Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab0K2Ruy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 12:50:54 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:50169 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab0K2Ruw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 12:50:52 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: microcai@fedoraproject.org
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
        Lisa Milne <lisa@ltmnet.com>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: VT console need rewrite
In-Reply-To: Your message of "Mon, 29 Nov 2010 10:14:06 +0800."
             <1290996846.877.23.camel@cai.gentoo>
From: Valdis.Kletnieks@vt.edu
References: <1290941875.13526.15.camel@cai.gentoo> <73BC440E-833E-4E1B-ACCC-5D68BAB89D83@mit.edu> <1290951770.13526.18.camel@cai.gentoo> <AANLkTimQDWHo4-8-H+5bB_uzrgzU=gqbDBuerq983moR@mail.gmail.com> <20101129020610.7ea7c79e.lisa@ltmnet.com> <1290961207.13526.31.camel@cai.gentoo> <20101128194624.GP2767@thunk.org> <4CF3081B.9090307@gmail.com>
            <1290996846.877.23.camel@cai.gentoo>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1291053037_5346P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 29 Nov 2010 12:50:37 -0500
Message-ID: <12794.1291053037@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020202.4CF3E7ED.024C,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1291053037_5346P
Content-Type: text/plain; charset=us-ascii

On Mon, 29 Nov 2010 10:14:06 +0800, Microcai said:

> The thing is, you really should agree that, implementing UNICODE font in
> kernel isn't a bad idea.

Let us know when you have implemented support for bidirectional
scripts that require compositing or half-spacing characters.  Without
blowing out the 8K kernel stack.

Doing it *right* is important:

http://gizmodo.com/382026/a-cellphones-missing-dot-kills-two-people-puts-three-more-in-jail

Two dead, three in jail.  All because of broken font support.  That's a good
reason to not even try unless you can do it *right*.


--==_Exmh_1291053037_5346P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM8+ftcC3lWbTT17ARAlxKAKCTOUIUHdlat0z4yt3eMrwDFXF/LgCg/wFQ
hzNT/SfHoi4UBOJHaiDDzgc=
=ypM3
-----END PGP SIGNATURE-----

--==_Exmh_1291053037_5346P--

