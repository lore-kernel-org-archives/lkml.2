Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab1EYVGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:06:20 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:57299 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab1EYVGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:06:17 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Michael Witten <mfwitten@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Richard Yao <ryao@ic.sunysb.edu>, linux-kernel@vger.kernel.org
Subject: Re: UNIX Compatibility
In-Reply-To: Your message of "Wed, 25 May 2011 10:36:02 EDT."
             <20110525143602.GE8476@thunk.org>
From: Valdis.Kletnieks@vt.edu
References: <BANLkTin4wu1HNDeo8Rv7iddM9KkgZdhfgA@mail.gmail.com> <A7E21A2F-4338-465D-933A-66B0C4D15BE1@mit.edu> <BANLkTi=q7tDVkahrnng7+BJhvxh=gx71ng@mail.gmail.com> <20110524181619.GC26055@thunk.org> <BANLkTi=QUS5WfAMWTw7vuEwuBOVHsww3mA@mail.gmail.com> <1306297108.4819.28.camel@marge.simson.net> <64e4614dda6f4558a68a314d7b5979b5-mfwitten@gmail.com>
            <20110525143602.GE8476@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306357572_2932P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 25 May 2011 17:06:12 -0400
Message-ID: <25621.1306357572@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4DDD6F45.004F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306357572_2932P
Content-Type: text/plain; charset=us-ascii

On Wed, 25 May 2011 10:36:02 EDT, "Ted Ts'o" said:

> And of course, the supreme irony is that if your OS is encumbered with
> AT&T copyrighted code, you can use the Unix trademark even if you are
> not conformant to the Single Unix Specification.  (There's an escape
> clause for AT&T derived-Unix systems, which are automatically "Unix"
> even if they fail the SUS.)
> 
> Given all of that, what _use_ is the Single Unix Specification at this
> point?  What's the _point_?

We're pretty shameless in mugging other operating systems for good new ideas
(witness the recent patches stealing SEEK_HOLE and SEEK_DATA from Solaris), but
most of the time, the neat stuff like that isn't part of SUS anyhow, because only
one or two Unix-derived systems implemented the function.

Single most useful thing left in SUS?  The few places we're *really* divergent from SUS,
we can usually go back and read the SUS spec for the function in question and remind
ourself that yes, we diverged for a reason - the spec was on total crack. :)


--==_Exmh_1306357572_2932P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN3W9EcC3lWbTT17ARApqUAJ9OfLaOF/Q9XmIUjWVXPLB0bLKsagCgjt3n
+OPfCN9cweH0/REnQJO/Uuo=
=FQrA
-----END PGP SIGNATURE-----

--==_Exmh_1306357572_2932P--

