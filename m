Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab1EZMIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 08:08:12 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:49951 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757295Ab1EZMIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 08:08:10 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: Michael Witten <mfwitten@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
        Mike Galbraith <efault@gmx.de>, Richard Yao <ryao@ic.sunysb.edu>,
        linux-kernel@vger.kernel.org
Subject: Re: UNIX Compatibility
In-Reply-To: Your message of "Thu, 26 May 2011 13:30:39 +0200."
             <1306409439.28597.81.camel@thorin>
From: Valdis.Kletnieks@vt.edu
References: <BANLkTin4wu1HNDeo8Rv7iddM9KkgZdhfgA@mail.gmail.com> <A7E21A2F-4338-465D-933A-66B0C4D15BE1@mit.edu> <BANLkTi=q7tDVkahrnng7+BJhvxh=gx71ng@mail.gmail.com> <20110524181619.GC26055@thunk.org> <BANLkTi=QUS5WfAMWTw7vuEwuBOVHsww3mA@mail.gmail.com> <1306297108.4819.28.camel@marge.simson.net> <64e4614dda6f4558a68a314d7b5979b5-mfwitten@gmail.com> <20110525143602.GE8476@thunk.org> <c943132c8c364f95a91e3cf81cb0f2bd-mfwitten@gmail.com>
            <1306409439.28597.81.camel@thorin>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306411679_4127P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 26 May 2011 08:07:59 -0400
Message-ID: <38084.1306411679@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4DDE42A2.0069,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306411679_4127P
Content-Type: text/plain; charset=us-ascii

On Thu, 26 May 2011 13:30:39 +0200, Bernd Petrovitsch said:

> Or take the "unlink a directory gives EPERM" example: why is it
> specified with an errno that indicates that the user is not allowed to
> remove it (and not that the sys-call is the wrong one).

Because on some old Unix's, it wasn't the wrong syscall...

RATIONALE

Unlinking a directory is restricted to the superuser in many historical
implementations for reasons given in link() (see also rename()).

http://pubs.opengroup.org/onlinepubs/009695399/functions/unlink.html

I've encountered at least one system (admittedly 20+ years ago), where
unlink("./") actually did work. Took me a while to correlate the weird fsck's
at reboots to the program that tried to remove './$A' when $A was unset...


--==_Exmh_1306411679_4127P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN3kKfcC3lWbTT17ARAvLDAKDJwYNfU2+Bj2Jfbfeslwi3jCNxAgCfecCT
LQRBNaZnhJ1431I8r5QcBgs=
=UND5
-----END PGP SIGNATURE-----

--==_Exmh_1306411679_4127P--

