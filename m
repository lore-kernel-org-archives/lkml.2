Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456Ab0KQWBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 17:01:22 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:60202 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758137Ab0KQWBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 17:01:21 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Werner Fink <werner@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
In-Reply-To: Your message of "Wed, 17 Nov 2010 00:10:24 +0100."
             <20101116231023.GB27594@tango.0pointer.de>
From: Valdis.Kletnieks@vt.edu
References: <1289922400.1253.3.camel@yio.site> <20101116155717.6671e484@lxorguk.ukuu.org.uk> <AANLkTimn7zyEjLhmOmUVQGnLDfM-A_uEgWETsM3nsyuY@mail.gmail.com> <20101116171447.29336514@lxorguk.ukuu.org.uk> <AANLkTi=ju4fON7Hz=j_tFtqFGD0b-c=-Ou+HQwfYDgOy@mail.gmail.com> <20101116195538.7fa66b97@lxorguk.ukuu.org.uk> <20101116213622.GA17824@tango.0pointer.de> <20101116225619.5fa7ef8b@lxorguk.ukuu.org.uk>
            <20101116231023.GB27594@tango.0pointer.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1290031268_4778P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 17 Nov 2010 17:01:08 -0500
Message-ID: <25482.1290031268@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020209.4CE450A4.020C,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1290031268_4778P
Content-Type: text/plain; charset=us-ascii

On Wed, 17 Nov 2010 00:10:24 +0100, Lennart Poettering said:

> When two users A and B are logged in, on tty1 resp. tty2, then as long
> as tty1 is active user A should get access to the sound card, usb key,
> .... As soon as we switch to tty2 user B should.

So I change to tty1, plug in my 8G USB memory stick, and I have access to it.
I start copying something big to it, and change to tty2 to do something else
while the long copy happens...

... and my copy craps out because tty1 lost access to the USB.

Brilliant.


--==_Exmh_1290031268_4778P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM5FCkcC3lWbTT17ARAmUpAKDVpYSutiwZzgPBMbXYztpx1TJf6QCgr8qh
Vyqa+blgZhlCzQJawWpbh1M=
=p3Wx
-----END PGP SIGNATURE-----

--==_Exmh_1290031268_4778P--

