Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab2C0QVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 12:21:09 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:44003 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab2C0QVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 12:21:06 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.4-dev
To: Matthew Garrett <mjg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Daniel Drake <dsd@laptop.org>,
        mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org, dilinger@queued.net, pgf@laptop.org
Subject: Re: [PATCH v4] x86, olpc: add debugfs interface for EC commands
In-Reply-To: Your message of "Tue, 27 Mar 2012 17:07:14 +0100."
             <20120327160714.GA8398@srcf.ucam.org>
From: Valdis.Kletnieks@vt.edu
References: <20120326180710.8DF9C9D401E@zog.reactivated.net> <20120326142908.c5248aec.akpm@linux-foundation.org> <4F70E042.4020703@zytor.com> <20120326145146.23fde0db.akpm@linux-foundation.org>
            <20120327160714.GA8398@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1332865125_1966P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 27 Mar 2012 12:18:46 -0400
Message-ID: <22573.1332865126@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020202.4F71E867.00AB,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1332865125_1966P
Content-Type: text/plain; charset=us-ascii

On Tue, 27 Mar 2012 17:07:14 +0100, Matthew Garrett said:

> If a previous author has given a Signed-off-by then they've clearly
> indicated that their code is under an appropriate license and may be
> submitted to the kernel. If someone else then takes that code, modifies
> it and submits it then there's no obvious reason why we still need the
> original Signed-off-by. Giving credit to the original author is
> obviously appropriate, but I don't see why we need any more than that.

Conversely, if a maintainer does fixups on a patch while commiting
it, we *don't* discard the original Signed-off-by.   I'd say if somebody's
submitting somebody else's patch, the chain should be:

signed-off-by: original author
signed-off-by: the person who did the updates
signed-off-by: <chain of maintainers heading upstream>

--==_Exmh_1332865125_1966P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT3HoZQdmEQWDXROgAQKvuA//UwBhCHoX6oj48o3CYIiVsJxEuJZkbk1W
w8qXSZvNol18GB+vtHl+ajCxU0zAjNiWzV1aUIrZPZ2JZMWzLTLyFG43vFF3E2cS
ppxzYMqH7pRCej6GxE45x5u/4GEL0hYtXNn3HdBrTSy+hzwDsykPW5jlvvOUaLvd
LM+Z7N2JrxerUAWpOC322OHgwqIadgA0PmOVRvu3nf8E43aoQY+iiKK6CI0QwyEL
cRfvcA7Q3jbJTc9yqZGyEFuLQIGRjQ/AbJRY9fkuYt8hmxc0cCXjwPYzGA9obXR7
7wjrfq9/jAFJ8xKwkBN41Aoy49Mp3YDO7Zraw2oW6dnHFmGQnaSyijpemp2IkmOa
1rlKww+M/raK2I0JI8x5M3sOUbCF2Puww5/ZZp1IkYlbho6eXUM2jhMIIf26oLKY
3eXE63LXnP7BBVp+crcBjamTALu4aGse546Zi5mpK5bH9IKFBglF5YSOAOLsNHd0
vsmVe4jm3opu/cu94SORb28GYCuP8G1pLM8PkRn1Q8hvTnhi7ZFri3oImQofwZSa
sUBBY0W25bjJ/QyNK9SgVMLKNJe0SDphmTetz8+AbAZHqyBZoDhQd+2vzfUOpOKi
HfMmnFFTlDZcxXevuSZcKadNxF0lLY4rMNFuMESQ+DxlsjZtpxOb5muo0DKmar42
X5M0qe2DIl8=
=Vwzo
-----END PGP SIGNATURE-----

--==_Exmh_1332865125_1966P--

