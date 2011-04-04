Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab1DDXR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 19:17:59 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:55308 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897Ab1DDXR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 19:17:58 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        containers@lists.linux-foundation.org, Nathan Lynch <ntl@pobox.com>,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 05/10] Core checkpoint/restart support code
In-Reply-To: Your message of "Mon, 04 Apr 2011 14:55:11 PDT."
             <20110404215511.GA27628@count0.beaverton.ibm.com>
From: Valdis.Kletnieks@vt.edu
References: <1298936432-29607-1-git-send-email-ntl@pobox.com> <1298936432-29607-6-git-send-email-ntl@pobox.com> <20110403190324.GD15044@hallyn.com> <1301929228.31531.39.camel@tp-t61> <20110404151017.GA4857@hallyn.com> <1301931608.31531.49.camel@tp-t61> <20110404162753.GA3456@hallyn.com> <20110404104119.78189678.akpm@linux-foundation.org> <20110404185119.GB4782@peq.hallyn.com> <20110404124222.fd5eb85b.akpm@linux-foundation.org>
            <20110404215511.GA27628@count0.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1301959009_4775P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 04 Apr 2011 19:16:50 -0400
Message-ID: <31800.1301959010@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4D9A5163.00D4,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1301959009_4775P
Content-Type: text/plain; charset=us-ascii

On Mon, 04 Apr 2011 14:55:11 PDT, Matt Helsley said:

> Now we're back with a new minimal patch set. You're asking us to do the same
> thing and expect different results -- stack more patches on top and expect to
> get it reviewed. OK, but what reason do we have to believe this time will be
> any different?

Has the terrain changed any since last time? In particular, ISTR a bunch of
activity in namespace support since last time - does that change what your
patch set needs to do?

--==_Exmh_1301959009_4775P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNmlFhcC3lWbTT17ARAi5cAJ4zBClgnu1wJpFmOWFE9gqFpt84wQCgwcdX
gwYPaJN8orq6V/JzfnUsD8w=
=yJjo
-----END PGP SIGNATURE-----

--==_Exmh_1301959009_4775P--

