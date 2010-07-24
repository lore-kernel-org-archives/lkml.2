Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab0GXOov (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 10:44:51 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:44631 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab0GXOot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 10:44:49 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Bob Tracy <rct@gherkin.frus.com>
Cc: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: Re: [BUG] dm9601 driver won't init device properly
In-Reply-To: Your message of "Fri, 23 Jul 2010 14:57:36 CDT."
             <20100723195736.GA4321@gherkin.frus.com>
From: Valdis.Kletnieks@vt.edu
References: <20100723195736.GA4321@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1279982681_3953P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 24 Jul 2010 10:44:41 -0400
Message-ID: <93420.1279982681@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4C4AFC5A.0203,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1279982681_3953P
Content-Type: text/plain; charset=us-ascii

On Fri, 23 Jul 2010 14:57:36 CDT, Bob Tracy said:
> I've got one of the inexpensive Davicom DM9601 USB to fast Ethernet
> devices, commonly available on eBay for under $10 including shipping.
> It works fairly well in a WinXP environment with a MTU of 1000: 1500
> and 1492 are confirmed not working, and values between 1000 and 1492
> have not been tested at this point.

Wow. An "ethernet" card that won't do an MTU of 1500 even under Windows.  May I
add this to my gallery of examples I use when people say "no vendor could
*possibly* ship hardware that fscked up"? :)


--==_Exmh_1279982681_3953P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMSvxZcC3lWbTT17ARAtqfAJ46dE663dJ8GlPy6eROzqDk1f1wFwCg0SXR
DwzKDSP9yrzniqb3o54e8/8=
=P9l9
-----END PGP SIGNATURE-----

--==_Exmh_1279982681_3953P--

