Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab0EKOAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:00:08 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:32797 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902Ab0EKOAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:00:04 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Nils Radtke <lkml@Think-Future.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.34-rc7: keyboard CAPS on/off indifferent, always capital
In-Reply-To: Your message of "Tue, 11 May 2010 13:33:47 +0200."
             <20100511113347.GD9838@localhost>
From: Valdis.Kletnieks@vt.edu
References: <20100511113347.GD9838@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1273586399_5047P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 11 May 2010 09:59:59 -0400
Message-ID: <71911.1273586399@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A02020A.4BE962E0.0270,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1273586399_5047P
Content-Type: text/plain; charset=us-ascii

On Tue, 11 May 2010 13:33:47 +0200, Nils Radtke said:
>   When resuming, the keys are capitalized but the CAPS LED is not lit. shift+key doesn't
>   switch. Suspend-resume does temporarily fix it. As well as switching to console and back
>   to X.

For what it's worth, I'm seeing a similar thing intermittently on my laptop
running 2.6.34-rc5-mmotm0428.  It will about 50% of the time boot with
caps-lock set, but hitting Shift or Caps-Lock key won't light the corresponding
light (but it *does* actually change state).

Really sucks when the first thing you need to enter is the encryption key
for the disk.  Try twice, hit caps-lock, have it work. Of course, the key is
masked, so you can't tell which way it's set.

Problem resolves once the X server starts up.


--==_Exmh_1273586399_5047P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFL6WLfcC3lWbTT17ARAn7EAJ9p+6Xsw2FKLJp7P/K5xuaMz2CSKQCglN8W
Nw8Sg8wwj2IiAxp4PnmR1lo=
=NvUx
-----END PGP SIGNATURE-----

--==_Exmh_1273586399_5047P--

